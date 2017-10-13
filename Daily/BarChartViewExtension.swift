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
            // Would love to know if theres a better way of handling this
            let ourValue = String(Int(values[ourIndex]))
            ourIndex += 1
            return ourValue
            
        }
    }
    
    func setBarChartData(dataSource: [(Date, Int)], label: String, color: UIColor) {
        
        var dataEntries: [BarChartDataEntry] = []
        
        var values: [Double] = []
        var days: [String] = []
        
        for i in 0..<dataSource.count {
            let dataEntry = BarChartDataEntry(x: Double(i), y: Double(dataSource[i].1))
            
            dataEntries.append(dataEntry)
            values.append(dataEntry.y)
        }
        
        for i in 0..<dataSource.count {
            let date = dataSource[i].0
            let calendar = Calendar.current
            
            let month = calendar.component(.month, from: date)
            let day = calendar.component(.day, from: date)
            
            
            days.append("\(month)/\(day)")
        }
        
        print(days)
        
        let chartDataSet = BarChartDataSet(values: dataEntries, label: label)
        chartDataSet.colors = [color]
        chartDataSet.valueFormatter = IntValueFormatter(values: values)
        chartDataSet.valueFont = .systemFont(ofSize: 12.0)
        
        
        let chartData = BarChartData(dataSet: chartDataSet)
        
        let chartFormatter = BarChartFormatter(labels: days)
        let xAxis = XAxis()
        xAxis.valueFormatter = chartFormatter
        self.xAxis.valueFormatter = xAxis.valueFormatter
        self.xAxis.granularity = 1

        self.data = chartData
    }
    
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
}
