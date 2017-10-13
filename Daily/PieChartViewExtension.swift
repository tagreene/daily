//
//  PieChartViewExtension.swift
//  Daily
//
//  Created by Trent Greene on 10/12/17.
//  Copyright © 2017 greene. All rights reserved.
//

import Foundation
import Charts

extension PieChartView {
    func setPieChartFormatting() {
        self.legend.enabled = false
        self.chartDescription = nil
        self.drawHoleEnabled = false
        self.drawEntryLabelsEnabled = false
        self.isUserInteractionEnabled = false
    }
    
    func setPieChartData(labels: [String], values: [Double], colors: [UIColor]) {
        var dataEntries: [PieChartDataEntry] = []
        
        for i in 0..<values.count {
            let dataEntry = PieChartDataEntry(value: values[i], label: labels[i])
            dataEntries.append(dataEntry)
        }
        
        let pieChartDataSet = PieChartDataSet(values: dataEntries, label: "Completion Rate")
        pieChartDataSet.setColors(colors[0], colors[1])
        pieChartDataSet.drawValuesEnabled = false
        let pieChartData = PieChartData(dataSet: pieChartDataSet)
        
        self.data = pieChartData
    }
}
