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
    
    func setBarChartData(xValues: [Date], yValues: [Int], label: String, color: UIColor) {
        
        var dataEntries: [BarChartDataEntry] = []
        var values: [Double] = []
        var days: [String] = []
        
        for i in 0..<yValues.count {
            let dataEntry = BarChartDataEntry(x: Double(i), y: Double(yValues[i]))
            
            dataEntries.append(dataEntry)
            values.append(dataEntry.y)
        }
        
        for i in 0..<xValues.count {
            let date = xValues[i]
            let calendar = Calendar.current
            
            let month = calendar.component(.month, from: date)
            let day = calendar.component(.day, from: date)
            
            
            days.append("\(month)/\(day)")
        }
        
        let chartDataSet = BarChartDataSet(values: dataEntries, label: label)
        chartDataSet.colors = [color]
        chartDataSet.valueFormatter = IntValueFormatter(values: values)
        
        
        let chartData = BarChartData(dataSet: chartDataSet)
        
        let chartFormatter = BarChartFormatter(labels: days)
        let xAxis = XAxis()
        xAxis.valueFormatter = chartFormatter
        self.xAxis.valueFormatter = xAxis.valueFormatter
        
        
        self.data = chartData
    }
}
