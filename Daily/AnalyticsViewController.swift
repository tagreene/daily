//
//  AnalyticsViewController.swift
//  Daily
//
//  Created by Trent Greene on 9/26/17.
//  Copyright © 2017 greene. All rights reserved.
//

import UIKit
import Charts
import CoreData

class AnalyticsViewController: UIViewController, UITextFieldDelegate {
    var completionChart: PieChartView!
    var activityChart: BarChartView!
    var displayType: DisplayType!
    var startDate: UITextField!
    var endDate: UITextField!
    var submitButton: UIButton!
    var pieChartLabel: UILabel!
    var activityChartLabel: UILabel!
    var mostCommonWordDescription: UILabel!
    var mostCommonWordLabel: UILabel!
    var averageWordLengthLabel: UILabel!
    var averageWordLengthDescription: UILabel!
    var startDatePicker: UIDatePicker!
    var endDatePicker: UIDatePicker!
    var activeTextField = UITextField()
    var startDateDate: Date!
    var endDateDate: Date!
    var firstEntryDate: Date!
    var lastEntryDate: Date!
    
    
    var ourGreen = UIColor.init(red: 95.0/255.0, green: 255.0/255.0, blue: 88.0/255.0, alpha: 0.8)
    var ourYellow = UIColor.init(red: 255.0/255.0, green: 255.0/255.0, blue: 89.0/255.0, alpha: 0.9)
    var ourBlue = UIColor.init(red: 0.0/255.0, green: 173.0/255.0, blue: 217.0/255.0, alpha: 1.0)
    var ourSalmon = UIColor.init(red: 240.0/255.0, green: 113.0/255.0, blue: 122.0/255.0, alpha: 1.0)
    var systemBlue = UIColor(red: 0, green: 0.478431, blue: 1, alpha: 1)
    
    let pieChartDataLabels = ["Completed", "Missed"]
    let pieChartCompletionData = [0.36, 0.64]
    
//    let barChartDataLabels = [Date.init(timeInterval: -604800, since: Date()), Date.init(timeInterval: -518400, since: Date()), Date.init(timeInterval: -345600, since: Date()), Date.init(timeInterval: -259200, since: Date()), Date.init(timeInterval: -172800, since: Date()), Date.init(timeInterval: -86400, since: Date()), Date()]
//    let barChartEntryCountData = [1, 1, 2, 28, 1, 2, 1]
    
//    Super large data test set
    let barChartDataLabels = [Date.init(timeInterval: -604800, since: Date()), Date.init(timeInterval: -518400, since: Date()), Date.init(timeInterval: -345600, since: Date()), Date.init(timeInterval: -259200, since: Date()), Date.init(timeInterval: -172800, since: Date()), Date.init(timeInterval: -86400, since: Date()), Date(), Date.init(timeInterval: -604800, since: Date()), Date.init(timeInterval: -518400, since: Date()), Date.init(timeInterval: -345600, since: Date()), Date.init(timeInterval: -259200, since: Date()), Date.init(timeInterval: -172800, since: Date()), Date.init(timeInterval: -86400, since: Date()), Date(), Date.init(timeInterval: -604800, since: Date()), Date.init(timeInterval: -518400, since: Date()), Date.init(timeInterval: -345600, since: Date()), Date.init(timeInterval: -259200, since: Date()), Date.init(timeInterval: -172800, since: Date()), Date.init(timeInterval: -86400, since: Date()), Date()]
    let barChartEntryCountData = [1, 2, 1, 1, 1, 2, 5, 1, 2, 1, 1, 1, 2, 0, 1, 2, 1, 1, 1, 2, 5]
    
    
    let screenHeight = UIScreen.main.bounds.height
    let screenWidth = UIScreen.main.bounds.width
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // set up charts here
//        view.backgroundColor = .white
        setUpDates()
        setUpDateSelection()
        setUpBarChart(dates: barChartDataLabels, entryCount: barChartEntryCountData, color: ourBlue)
        setUpPieChart(labels: pieChartDataLabels, values: pieChartCompletionData)
        setUpWordLabels()
        initTapGestureRecognizer()

        addGradient()
    }
    
    func setUpDates() {
        let context = AppDelegate.viewContext
        
        /*
         Currently, if you use perform here, your app will crash as setUpDateSelection() will try to unwrap firstEntryDate
         before you've retrieved them
 
         i.e. you have a race condition
 
         performAndWait solves this, but maybe theres a better way
         perhaps pass set up dates in a closure?
 
         As of now, performAndWait does not cause a real performance loss, so maybe that is the best answer
         */
        
        context.performAndWait {
            let request: NSFetchRequest<Entry> = Entry.fetchRequest()
            request.sortDescriptors = [NSSortDescriptor(key: "date", ascending: true)]
            request.fetchLimit = 1
            if let entries = try? context.fetch(request) {
                self.firstEntryDate = entries[0].date
                print(self.firstEntryDate)
            }
        }
        
        context.performAndWait {
            let request: NSFetchRequest<Entry> = Entry.fetchRequest()
            request.sortDescriptors = [NSSortDescriptor(key: "date", ascending: false)]
            request.fetchLimit = 1
            if let entries = try? context.fetch(request) {
                self.lastEntryDate = entries[0].date
                print(self.lastEntryDate)
            }
        }
    }
    
    func setUpWordLabels() {
        mostCommonWordLabel = UILabel()
        mostCommonWordLabel.text = "Peanuts"
        mostCommonWordLabel.font = .systemFont(ofSize: 32)
        mostCommonWordLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(mostCommonWordLabel)
        
        mostCommonWordDescription = UILabel()
        mostCommonWordDescription.text = "is your most used word"
        mostCommonWordDescription.font = .systemFont(ofSize: 16)
        mostCommonWordDescription.numberOfLines = 2
        mostCommonWordDescription.lineBreakMode = .byWordWrapping
        mostCommonWordDescription.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(mostCommonWordDescription)
        
        averageWordLengthLabel = UILabel()
        averageWordLengthLabel.text = "102.7"
        averageWordLengthLabel.font = .systemFont(ofSize: 32)
        averageWordLengthLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(averageWordLengthLabel)
        
        averageWordLengthDescription = UILabel()
        averageWordLengthDescription.text = "Average words \nper entry"
        averageWordLengthDescription.textAlignment = .right
        averageWordLengthDescription.numberOfLines = 2
        averageWordLengthDescription.font = .systemFont(ofSize: 16)
        averageWordLengthDescription.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(averageWordLengthDescription)
        
        let margins = view.layoutMarginsGuide
        
        if #available(iOS 11, *) {
            mostCommonWordLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16).isActive = true
            averageWordLengthDescription.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16).isActive = true
        } else {
            mostCommonWordLabel.topAnchor.constraint(equalTo: topLayoutGuide.bottomAnchor, constant: 16).isActive = true
            averageWordLengthDescription.topAnchor.constraint(equalTo: topLayoutGuide.bottomAnchor, constant: 16).isActive = true
        }
        
        mostCommonWordDescription.leadingAnchor.constraint(equalTo: margins.leadingAnchor, constant: 16).isActive = true
        mostCommonWordDescription.widthAnchor.constraint(equalToConstant: screenWidth * 0.45).isActive = true
        mostCommonWordDescription.topAnchor.constraint(equalTo: mostCommonWordLabel.bottomAnchor, constant: 0).isActive = true
        
        mostCommonWordLabel.leadingAnchor.constraint(equalTo: margins.leadingAnchor, constant: 16).isActive = true
        
        averageWordLengthLabel.trailingAnchor.constraint(equalTo: margins.trailingAnchor, constant: -16).isActive = true
        averageWordLengthLabel.topAnchor.constraint(equalTo: averageWordLengthDescription.bottomAnchor, constant: 0).isActive = true

        averageWordLengthDescription.trailingAnchor.constraint(equalTo: margins.trailingAnchor, constant: -16).isActive = true
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
        
        let margins = view.layoutMarginsGuide
        activityChart.heightAnchor.constraint(equalToConstant: screenHeight * 0.25).isActive = true
        activityChart.widthAnchor.constraint(equalToConstant: screenWidth * 0.95).isActive = true
        activityChart.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        activityChart.bottomAnchor.constraint(equalTo: startDate.topAnchor, constant: -32).isActive = true
        
        activityChartLabel = UILabel()
        activityChartLabel.text = { setActivityChartLabelText(data: entryCount) }()
        activityChartLabel.font = .systemFont(ofSize: 16)
        activityChartLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(activityChartLabel)
        
        activityChartLabel.bottomAnchor.constraint(equalTo: activityChart.topAnchor, constant: 0).isActive = true
        activityChartLabel.leadingAnchor.constraint(equalTo: margins.leadingAnchor, constant: 16).isActive = true
        
        
    }
    
    func setActivityChartLabelText(data: [Int]) -> String {
        let totalEntries = Double(data.count)
        let totalSum = Double(data.reduce(0, +))
        let average = totalSum / totalEntries
        let string = String(format: "%.1f", average)
        return "Average \(string) entries per day"
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
        
        // I really, really don't like the way the top and leading anchors of this chart is setup
        // I haven't found a way to adjust the size of the background rect without modifying the size of the chart
        // Hence the gross constriants with no constant values
        completionChart.heightAnchor.constraint(equalToConstant: screenHeight * 0.25).isActive = true
        completionChart.widthAnchor.constraint(equalToConstant: screenWidth * 0.5).isActive = true
        completionChart.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        completionChart.bottomAnchor.constraint(equalTo: activityChartLabel.topAnchor, constant: -8).isActive = true

        pieChartLabel = UILabel()
        let ourPercent = Int(round(pieChartCompletionData[1] * 100))
        pieChartLabel.text = "\(ourPercent)% of days contained entries in this period"
        pieChartLabel.translatesAutoresizingMaskIntoConstraints = false
        pieChartLabel.lineBreakMode = .byWordWrapping
        pieChartLabel.numberOfLines = 4
        pieChartLabel.font = .systemFont(ofSize: 16)
        pieChartLabel.sizeToFit()
        
        view.addSubview(pieChartLabel)
        
        let margins = view.layoutMarginsGuide
        pieChartLabel.centerYAnchor.constraint(equalTo: completionChart.centerYAnchor).isActive = true
        pieChartLabel.trailingAnchor.constraint(equalTo: margins.trailingAnchor).isActive = true
        pieChartLabel.widthAnchor.constraint(equalToConstant: screenWidth * 0.45).isActive = true
    }
    
    func addGradient() {
        let gradient: CAGradientLayer = CAGradientLayer()
        gradient.frame.size = self.view.frame.size
        gradient.colors = [UIColor.init(red: 205.0/255.0, green: 255.0/255.0, blue: 255.0/255.0, alpha: 1.0).cgColor, UIColor.init(red: 205.0/255.0, green: 255.0/255.0, blue: 255.0/255.0, alpha: 0.5).cgColor]
        gradient.endPoint = CGPoint.init(x: 1.0, y: 0.25)
        gradient.startPoint = CGPoint.init(x: 0.5, y: 1.0)
        self.view.layer.insertSublayer(gradient, at: 0)
    }
    
    func setUpDateSelection() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/YY"
        
        startDatePicker = UIDatePicker()
        startDatePicker.addTarget(self, action: #selector(handleStartDatePicker(_:)), for: .valueChanged)
        startDatePicker.datePickerMode = .date
        startDatePicker.minimumDate = firstEntryDate
        startDatePicker.maximumDate = lastEntryDate
        startDate = UITextField()
        startDate.inputView = startDatePicker
        startDate.text = dateFormatter.string(from: firstEntryDate)
        startDate.font = .systemFont(ofSize: 24)
        startDate.textColor = systemBlue
        startDate.translatesAutoresizingMaskIntoConstraints = false
        startDateDate = Date()
        view.addSubview(startDate)
        
        endDatePicker = UIDatePicker()
        endDatePicker.addTarget(self, action: #selector(handleEndDatePicker(_:)), for: .valueChanged)
        endDatePicker.datePickerMode = .date
        endDatePicker.minimumDate = firstEntryDate
        endDatePicker.maximumDate = lastEntryDate
        endDate = UITextField()
        endDate.inputView = endDatePicker
        endDate.text = dateFormatter.string(from: lastEntryDate)
        endDate.font = .systemFont(ofSize: 24)
        endDate.textColor = systemBlue
        endDate.translatesAutoresizingMaskIntoConstraints = false
        endDateDate = Date()
        view.addSubview(endDate)
        
        submitButton = UIButton(type: .system)
        submitButton.setTitle("📅 Update Dates 📅", for: [])
        submitButton.titleLabel!.font = .systemFont(ofSize: 24)
        submitButton.backgroundColor = ourGreen
        submitButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(submitButton)
        
        let margins = view.layoutMarginsGuide
        
        submitButton.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        submitButton.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        submitButton.heightAnchor.constraint(equalToConstant: screenHeight * 0.096).isActive = true
        if #available(iOS 11, *) {
            submitButton.bottomAnchor.constraintEqualToSystemSpacingBelow(view.safeAreaLayoutGuide.bottomAnchor, multiplier: 0).isActive = true
        } else {
            submitButton.bottomAnchor.constraint(equalTo: bottomLayoutGuide.topAnchor, constant: 0).isActive = true
        }
        
        startDate.leadingAnchor.constraint(equalTo: margins.leadingAnchor, constant: 16).isActive = true
        startDate.bottomAnchor.constraint(equalTo: submitButton.topAnchor, constant: -16).isActive = true
        
        endDate.centerYAnchor.constraint(equalTo: startDate.centerYAnchor).isActive = true
        endDate.trailingAnchor.constraint(equalTo: margins.trailingAnchor, constant: 0).isActive = true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.activeTextField = textField
    }
    
    func initTapGestureRecognizer() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard(_:)))
        
        view.addGestureRecognizer(tap)
    }
    
    @objc func handleStartDatePicker(_ sender: UIDatePicker) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/YY"
        startDate.text = dateFormatter.string(from: sender.date)
        startDateDate = sender.date
        print(startDateDate)
    }
    
    @objc func handleEndDatePicker(_ sender: UIDatePicker) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/YY"
        endDate.text = dateFormatter.string(from: sender.date)
        endDateDate = sender.date
        print(endDateDate)
    }
    
    @objc func dismissKeyboard(_ sender: UITapGestureRecognizer) {
        startDate.resignFirstResponder()
        endDate.resignFirstResponder()
    }
}
