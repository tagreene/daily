//
//  BarChartViewExtension.swift
//  Daily
//
//  Created by Trent Greene on 10/2/17.
//  Copyright © 2017 greene. All rights reserved.
//

import Charts
import Foundation

extension BarChartView {
    // MARK: - Value Formatters
    // This class controls the X axis labels -- Essentially pulls them from the array of strings based on the index
    private class BarChartFormatter: NSObject, IAxisValueFormatter {
        var labels: [String] = []
        
        func stringForValue(_ value: Double, axis: AxisBase?) -> String {
            return labels[Int(value)]
        }
        
        init(labels: [String]) {
            super.init()
            self.labels = labels
        }
    }
    
    // This controls the format of the y axis values
    // Just takes in an array of values and pulls them based on the index
    private class IntValueFormatter: NSObject, IValueFormatter {
        var strIntValues: [String] = []
        var values: [Double] = []
        var ourIndex = 0
        
        init(values: [Double]) {
            super.init()
            self.values = values
        }
        
        func stringForValue(_ value: Double, entry: ChartDataEntry, dataSetIndex: Int, viewPortHandler: ViewPortHandler?) -> String {
            
            // The double conversion seems gross prima facie, but is safe as our inputs will never have a value after our decimal point (They are generated as Ints in our value controller)
            // Much easier and briefer than bothering to creating a NumberFormatter
            
            let ourValue = String(Int(values[ourIndex]))
            ourIndex += 1
            guard ourValue != "0" else { return " " }
            return ourValue
            
        }
    }
    
    // MARK: - Set Chart Formatting and Data
    func setBarChartFormatting() {
        self.chartDescription = nil
        self.legend.enabled = false
        self.isUserInteractionEnabled = false
        self.fitBars = true
        self.xAxis.drawGridLinesEnabled = false
        self.xAxis.labelPosition = .bottom
        self.rightAxis.enabled = false
        self.leftAxis.enabled = false
        
        // The below mimics setting the spaceBottom to zero, but also guards against the x axis autogenerating its minimum to a >0 value in highly dynamic sets
        self.leftAxis.axisMinimum = 0.0
    }
    
    func setBarChartData(dataSource: [(date: Date, int: Int)], label: String, color: UIColor) {
        
        var dataEntries: [BarChartDataEntry] = []
        var values: [Double] = []
        var stringDates: [String] = []
        let dateGranularity = DateGranularity.init(dataSource.count)
        
        // Determine Data Granularity
        switch dateGranularity {
        case .daily:
            let dailyData = setUpDailyData(dataSource)
            dataEntries = dailyData.barChartData
            values = dailyData.values
            stringDates = dailyData.days
        case .weekly:
            let weeklyData = setUpWeeklyData(dataSource)
            dataEntries = weeklyData.barChartData
            values = weeklyData.values
            stringDates = weeklyData.weeks
        case .monthly:
            let monthlyData = setUpMonthlyData(dataSource)
            dataEntries = monthlyData.barChartData
            values = monthlyData.values
            stringDates = monthlyData.months
        case .yearly:
            let yearlyData = setUpYearlyData(dataSource)
            dataEntries = yearlyData.barChartData
            values = yearlyData.values
            stringDates = yearlyData.years
        }
        
        let chartDataSet = BarChartDataSet(values: dataEntries, label: label)
        chartDataSet.colors = [color]
        chartDataSet.valueFormatter = IntValueFormatter(values: values)
        chartDataSet.valueFont = .systemFont(ofSize: 12.0)
        
        
        let chartData = BarChartData(dataSet: chartDataSet)
        
        let chartFormatter = BarChartFormatter(labels: stringDates)
        let xAxis = XAxis()
        xAxis.valueFormatter = chartFormatter
        self.xAxis.valueFormatter = xAxis.valueFormatter
        self.xAxis.granularity = 1
        
        self.data = chartData
    }
    
    // MARK: - Granulatity Functions
    func setUpDailyData(_ dataSource: [(date: Date, int: Int)]) -> (barChartData: [BarChartDataEntry], values: [Double], days: [String]) {
        var dataEntries: [BarChartDataEntry] = []
        var values: [Double] = []
        var days: [String] = []
        
        
        for i in 0..<dataSource.count {
            let dataEntry = BarChartDataEntry(x: Double(i), y: Double(dataSource[i].int))
            
            dataEntries.append(dataEntry)
            values.append(dataEntry.y)
            
            // Handle Labels
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MM/dd"
            let stringDate = dateFormatter.string(from: dataSource[i].date)
            days.append(stringDate)
        }
        
        let ourTuple = (barChartData: dataEntries, values: values, days: days)
        return ourTuple
    }
    
    func setUpWeeklyData(_ dataSource: [(date: Date, int: Int)]) -> (barChartData: [BarChartDataEntry], values: [Double], weeks: [String]) {
        var dataEntries: [BarChartDataEntry] = []
        var values: [Double] = []
        var weeks: [String] = []
        
        var index = 0.0
        var firstDay = dataSource[0].date
        let lastDay = dataSource.reversed()[0].date
        while firstDay <= lastDay {
            let weekEndDate = Date(timeInterval: 60 * 60 * 24 * 7, since: firstDay)
            let tempData = dataSource.filter { $0.date >= firstDay && $0.date < weekEndDate }
            let totalCount = Double(tempData.reduce(0) {$0 + $1.int})
            
            let dataEntry = BarChartDataEntry(x: index, y: totalCount)
            dataEntries.append(dataEntry)
            values.append(dataEntry.y)
            
            // Handle Labels
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MM/dd"
            let stringDate = dateFormatter.string(from: firstDay)
            weeks.append(stringDate)
            
            // Increment
            index += 1.0
            firstDay = Date(timeInterval: 60 * 60 * 24 * 7, since: firstDay)
        }
        
        let ourTuple = (barChartData: dataEntries, values: values, weeks: weeks)
        return ourTuple
    }
    
    func setUpMonthlyData(_ dataSource: [(date: Date, int: Int)]) -> (barChartData: [BarChartDataEntry], values: [Double], months: [String]) {
        var dataEntries: [BarChartDataEntry] = []
        var values: [Double] = []
        var months: [String] = []
        
        // Filter based on month
        var index = 0.0
        let calendar = Calendar.current
        
        // This method creates artificial dates constructed from the date components of dataSources' start and end date
        // We could extend DateComponents to conform to comparable...
        // But, given that DateComponents properties are stored as optionals, we would need to handle the possibility of them being nil
        // Which would boil down to giving the `<` operator a default value in case one of the DateComponents has a nil property being compared.
        // e.g. guard let rhsYear = rhs.year else { return (would need a bool here) }
        // Therefore, creating artificial comp dates is simpler, and limits the chance of false comparisons
        // P.S. we're gonna do the same dance for the year method
        
        let startDateComponents = calendar.dateComponents([.month, .year], from: dataSource[0].date)
        let endDateComponents = calendar.dateComponents([.month, .year], from: dataSource.reversed()[0].date)
        var compStartDate = calendar.date(from: startDateComponents)!
        let compEndDate = calendar.date(from: endDateComponents)!
        
        while compStartDate <= compEndDate {
            let compStartComponents = calendar.dateComponents([.month, .year], from: compStartDate)
            let tempData = dataSource.filter { (date: Date, int: Int) -> Bool in
                let components = calendar.dateComponents([.month, .year], from: date)
                return components == compStartComponents
            }
            let totalCount = Double(tempData.reduce(0) {$0 + $1.int})
            
            let dataEntry = BarChartDataEntry(x: index, y: totalCount)
            dataEntries.append(dataEntry)
            values.append(dataEntry.y)
            
            // Handle Labels
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MM/yy"
            let stringDate = dateFormatter.string(from: compStartDate)
            months.append(stringDate)
            
            // Increment
            index += 1.0
            let tempStartDate = calendar.date(byAdding: .month, value: 1, to: compStartDate)!
            compStartDate = tempStartDate
        }
        
        let ourTuple = (barChartData: dataEntries, values: values, months: months)
        return ourTuple
    }
    
    func setUpYearlyData(_ dataSource: [(date: Date, int: Int)]) -> (barChartData: [BarChartDataEntry], values: [Double], years: [String]) {
        var dataEntries: [BarChartDataEntry] = []
        var values: [Double] = []
        var years: [String] = []
        
        // Filter based on year
        var index = 0.0
        let calendar = Calendar.current
        
        let startDateComponents = calendar.dateComponents([.year], from: dataSource[0].date)
        let endDateComponents = calendar.dateComponents([.year], from: dataSource.reversed()[0].date)
        var compStartDate = calendar.date(from: startDateComponents)!
        let compEndDate = calendar.date(from: endDateComponents)!
        
        while compStartDate <= compEndDate {
            let compStartComponents = calendar.dateComponents([.year], from: compStartDate)
            let tempData = dataSource.filter { (date: Date, int: Int) -> Bool in
                let components = calendar.dateComponents([.year], from: date)
                return components == compStartComponents
            }
            let totalCount = Double(tempData.reduce(0) {$0 + $1.int})
            
            let dataEntry = BarChartDataEntry(x: index, y: totalCount)
            dataEntries.append(dataEntry)
            values.append(dataEntry.y)
            
            
            // Handle Labels
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy"
            let stringDate = dateFormatter.string(from: compStartDate)
            years.append(stringDate)
            
            // Increment
            index += 1.0
            let tempStartDate = calendar.date(byAdding: .year, value: 1, to: compStartDate)!
            compStartDate = tempStartDate
        }
        
        let ourTuple = (barChartData: dataEntries, values: values, years: years)
        return ourTuple
    }
}

