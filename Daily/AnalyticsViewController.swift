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
    
    var ourGreen = UIColor.init(red: 95.0/255.0, green: 255.0/255.0, blue: 88.0/255.0, alpha: 0.8)
    var ourYellow = UIColor.init(red: 255.0/255.0, green: 255.0/255.0, blue: 89.0/255.0, alpha: 0.9)
    var ourBlue = UIColor.init(red: 0.0/255.0, green: 173.0/255.0, blue: 217.0/255.0, alpha: 1.0)
    
    let pieChartDataLabels = ["Completed", "Missed"]
    let pieChartCompletionData = [0.36, 0.64]
    
    let barChartDataLabels = [Date.init(timeInterval: -604800, since: Date()), Date.init(timeInterval: -518400, since: Date()), Date.init(timeInterval: -345600, since: Date()), Date.init(timeInterval: -259200, since: Date()), Date.init(timeInterval: -172800, since: Date()), Date.init(timeInterval: -86400, since: Date()), Date()]
    let barChartEntryCountData = [1, 1, 2, 28, 1, 2, 1]
    
//    Super large data test set
//    let barChartDataLabels = [Date.init(timeInterval: -604800, since: Date()), Date.init(timeInterval: -518400, since: Date()), Date.init(timeInterval: -345600, since: Date()), Date.init(timeInterval: -259200, since: Date()), Date.init(timeInterval: -172800, since: Date()), Date.init(timeInterval: -86400, since: Date()), Date(), Date.init(timeInterval: -604800, since: Date()), Date.init(timeInterval: -518400, since: Date()), Date.init(timeInterval: -345600, since: Date()), Date.init(timeInterval: -259200, since: Date()), Date.init(timeInterval: -172800, since: Date()), Date.init(timeInterval: -86400, since: Date()), Date(), Date.init(timeInterval: -604800, since: Date()), Date.init(timeInterval: -518400, since: Date()), Date.init(timeInterval: -345600, since: Date()), Date.init(timeInterval: -259200, since: Date()), Date.init(timeInterval: -172800, since: Date()), Date.init(timeInterval: -86400, since: Date()), Date(), Date.init(timeInterval: -604800, since: Date()), Date.init(timeInterval: -518400, since: Date()), Date.init(timeInterval: -345600, since: Date()), Date.init(timeInterval: -259200, since: Date()), Date.init(timeInterval: -172800, since: Date()), Date.init(timeInterval: -86400, since: Date()), Date(),Date.init(timeInterval: -604800, since: Date()), Date.init(timeInterval: -518400, since: Date()), Date.init(timeInterval: -345600, since: Date()), Date.init(timeInterval: -259200, since: Date()), Date.init(timeInterval: -172800, since: Date()), Date.init(timeInterval: -86400, since: Date()), Date(), Date.init(timeInterval: -604800, since: Date()), Date.init(timeInterval: -518400, since: Date()), Date.init(timeInterval: -345600, since: Date()), Date.init(timeInterval: -259200, since: Date()), Date.init(timeInterval: -172800, since: Date()), Date.init(timeInterval: -86400, since: Date()), Date(), Date.init(timeInterval: -604800, since: Date()), Date.init(timeInterval: -518400, since: Date()), Date.init(timeInterval: -345600, since: Date()), Date.init(timeInterval: -259200, since: Date()), Date.init(timeInterval: -172800, since: Date()), Date.init(timeInterval: -86400, since: Date()), Date(), Date.init(timeInterval: -604800, since: Date()), Date.init(timeInterval: -518400, since: Date()), Date.init(timeInterval: -345600, since: Date()), Date.init(timeInterval: -259200, since: Date()), Date.init(timeInterval: -172800, since: Date()), Date.init(timeInterval: -86400, since: Date()), Date()]
//    let barChartEntryCountData = [1, 1, 2, 28, 1, 2, 1, 1, 1, 2, 28, 1, 2, 1, 1, 1, 2, 28, 1, 2, 1, 1, 1, 2, 28, 1, 2, 1, 1, 1, 2, 28, 1, 2, 1, 1, 1, 2, 28, 1, 2, 1, 1, 1, 2, 28, 1, 2, 1, 1, 1, 2, 28, 1, 2, 1]
    
    
    let screenHeight = UIScreen.main.bounds.height
    let screenWidth = UIScreen.main.bounds.width
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // set up charts here
//        setUpPieChart(labels: pieChartDataLabels, values: pieChartCompletionData)
//        setUpBarChart(dates: barChartDataLabels, entryCount: barChartEntryCountData, color: ourBlue)
        
        addGradient()
        
        view.backgroundColor = .lightGray
    }
    
    func setUpBarChart(dates: [Date], entryCount: [Int], color: UIColor) {
        
        activityChart = BarChartView()
        activityChart.translatesAutoresizingMaskIntoConstraints = false
        activityChart.chartDescription = nil
        activityChart.legend.enabled = false
        activityChart.isUserInteractionEnabled = false
        activityChart.fitBars = true
        activityChart.xAxis.drawGridLinesEnabled = false
        activityChart.xAxis.labelPosition = .bottom
        activityChart.rightAxis.enabled = false
        activityChart.leftAxis.enabled = false
        
        // The below mimics setting the spaceBottom to zero, but also guards against the x axis autogenerating its minimum to a >0 value in highly dynamic sets
        activityChart.leftAxis.axisMinimum = 0.0

    
        
        
        
        
        activityChart.setBarChartData(xValues: dates, yValues: entryCount, label: "Daily Activity", color: color)
        view.addSubview(activityChart)
        
        let heightConstraint = activityChart.heightAnchor.constraint(equalToConstant: screenHeight * 0.25)
        let widthConstraint = activityChart.widthAnchor.constraint(equalToConstant: screenWidth * 0.8)
        if #available(iOS 11, *) {
            let topConstraint = activityChart.topAnchor.constraintEqualToSystemSpacingBelow(view.safeAreaLayoutGuide.topAnchor, multiplier: 1)
            topConstraint.isActive = true
        } else {
            let topConstraint = activityChart.topAnchor.constraint(equalTo: topLayoutGuide.bottomAnchor, constant: 8)
            topConstraint.isActive = true
        }

        heightConstraint.isActive = true
        widthConstraint.isActive = true
    }
    
    func setUpPieChart(labels: [String], values: [Double]) {
        completionChart = PieChartView()
        var dataEntries: [PieChartDataEntry] = []
        
        for i in 0..<values.count {
            let dataEntry = PieChartDataEntry(value: values[i], label: labels[i])
            dataEntries.append(dataEntry)
        }
        
        let pieChartDataSet = PieChartDataSet(values: dataEntries, label: "Completion Rate")
        pieChartDataSet.setColors(ourYellow, ourGreen)
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
        if #available(iOS 11, *) {
            let topConstraint = completionChart.topAnchor.constraintEqualToSystemSpacingBelow(view.safeAreaLayoutGuide.topAnchor, multiplier: 1)
            topConstraint.isActive = true
        } else {
            let topConstraint = completionChart.topAnchor.constraint(equalTo: topLayoutGuide.bottomAnchor, constant: 8)
            topConstraint.isActive = true
        }


        heightConstraint.isActive = true
        widthConstraint.isActive = true
    }
    
    func addGradient() {
        let gradient: CAGradientLayer = CAGradientLayer()
        gradient.frame.size = self.view.frame.size
        gradient.colors = [UIColor.init(red: 205.0/255.0, green: 255.0/255.0, blue: 255.0/255.0, alpha: 1.0).cgColor, UIColor.init(red: 205.0/255.0, green: 255.0/255.0, blue: 255.0/255.0, alpha: 0.5).cgColor]
        gradient.endPoint = CGPoint.init(x: 1.0, y: 0.25)
        gradient.startPoint = CGPoint.init(x: 0.5, y: 1.0)
        self.view.layer.insertSublayer(gradient, at: 0)
    }
}
