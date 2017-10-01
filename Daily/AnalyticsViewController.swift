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
    
    let pieChartDataLabels = ["Completed", "Missed"]
    let pieChartCompletionData = [0.64, 0.36]
    let screenHeight = UIScreen.main.bounds.height
    let screenWidth = UIScreen.main.bounds.width
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // set up charts here
        setUpPieChart(labels: pieChartDataLabels, values: pieChartCompletionData)
        view.backgroundColor = .lightGray
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
        view.addSubview(completionChart)
        
        let heightConstraint = completionChart.heightAnchor.constraint(equalToConstant: screenHeight * 0.25)
        let widthConstraint = completionChart.widthAnchor.constraint(equalToConstant: screenWidth * 0.5)


        heightConstraint.isActive = true
        widthConstraint.isActive = true
    }
}
