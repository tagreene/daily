//
//  AnalyticsViewController.swift
//  Daily
//
//  Created by Trent Greene on 9/26/17.
//  Copyright © 2017 greene. All rights reserved.
//

import UIKit
import Charts

class AnalyticsViewController: UIViewController {
    var completionChart: PieChartView!
    var activityChart: BarChartView!
    
    let pieChartDataLabels = ["Completed", "Missed"]
    let pieChartCompletionData = [0.64, 0.36]
    
    let barChartDataLabels = [Date.init(timeInterval: -604800, since: Date()), Date.init(timeInterval: -518400, since: Date()), Date.init(timeInterval: -345600, since: Date()), Date.init(timeInterval: -259200, since: Date()), Date.init(timeInterval: -172800, since: Date()), Date.init(timeInterval: -86400, since: Date()), Date()]
    let barChartEntryCountData = [1, 1, 2, 3, 8, 2, 1]
    
    
    let screenHeight = UIScreen.main.bounds.height
    let screenWidth = UIScreen.main.bounds.width
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // set up charts here
        setUpPieChart(labels: pieChartDataLabels, values: pieChartCompletionData)
        setUpBarChart(dates: barChartDataLabels, entryCount: barChartEntryCountData)
        
        view.backgroundColor = .lightGray
    }
    
    func setUpBarChart(dates: [Date], entryCount: [Int]) {
        activityChart = BarChartView()
        var dataEntries: [BarChartDataEntry] = []
        var days: [String] = []
        
        for i in 0..<entryCount.count {
            let dataEntry = BarChartDataEntry(x: Double(i + 1), y: Double(entryCount[i]))
            dataEntries.append(dataEntry)
        }
        
        for i in 0..<dates.count {
            let date = dates[i]
            let calendar = Calendar.current
            
            let month = calendar.component(.month, from: date)
            let day = calendar.component(.day, from: date)
            let year = calendar.component(.year, from: date)
            
            
            days.append("\(month)/\(day)/\(year)")
        }
        
        let barChartDataSet = BarChartDataSet(values: dataEntries, label: "Submission Count")
        let barChartData = BarChartData()
        
    }
    
    func setUpPieChart(labels: [String], values: [Double]) {
        completionChart = PieChartView()
        var dataEntries: [PieChartDataEntry] = []
        
        for i in 0..<values.count {
            let dataEntry = PieChartDataEntry(value: values[i], label: labels[i])
            dataEntries.append(dataEntry)
        }
        
        let pieChartDataSet = PieChartDataSet(values: dataEntries, label: "Completion Rate")
        pieChartDataSet.setColors(.green, .red)
        pieChartDataSet.drawValuesEnabled = false
        let pieChartData = PieChartData(dataSet: pieChartDataSet)

        self.completionChart.data = pieChartData
        completionChart.translatesAutoresizingMaskIntoConstraints = false
        completionChart.legend.enabled = false
        completionChart.chartDescription = nil
        completionChart.drawHoleEnabled = false
        completionChart.drawEntryLabelsEnabled = false
        completionChart.isUserInteractionEnabled = false
//        view.addSubview(completionChart)
        
        let heightConstraint = completionChart.heightAnchor.constraint(equalToConstant: screenHeight * 0.25)
        let widthConstraint = completionChart.widthAnchor.constraint(equalToConstant: screenWidth * 0.5)


        heightConstraint.isActive = true
        widthConstraint.isActive = true
    }
}
