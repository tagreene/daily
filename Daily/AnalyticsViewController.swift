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

class AnalyticsViewController: UIViewController {
    var completionChart: PieChartView!
    var activityChart: BarChartView!
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
    var entries = [Entry]()
    var words = [String]()
    var entryTuples = [(date: Date, int: Int)]()
    var avgWordCount = Double()
    var wordCountDict = [String : Int]()
    var mostUsedWord = String()
    
    var ourGreen = UIColor.init(red: 95.0/255.0, green: 255.0/255.0, blue: 88.0/255.0, alpha: 0.8)
    var ourYellow = UIColor.init(red: 255.0/255.0, green: 255.0/255.0, blue: 89.0/255.0, alpha: 0.9)
    var ourBlue = UIColor.init(red: 0.0/255.0, green: 173.0/255.0, blue: 217.0/255.0, alpha: 1.0)
    var ourSalmon = UIColor.init(red: 240.0/255.0, green: 113.0/255.0, blue: 122.0/255.0, alpha: 1.0)
    var systemBlue = UIColor(red: 0, green: 0.478431, blue: 1, alpha: 1)
    
    let pieChartDataLabels = ["Missed", "Completed"]
    let pieChartCompletionData = [0.36, 0.64]
    
    
    let screenHeight = UIScreen.main.bounds.height
    let screenWidth = UIScreen.main.bounds.width
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // set up charts here
        queryForMinMaxDates()
        setUpDateSelection()
        updateEntities()
        setUpBarChart()
        setUpPieChart()
        breakOutWords()
        setUpWordLabels()
        initTapGestureRecognizer()
        
        addGradient()
    }
    
    func setUpNoEntryView() {
        let noEntryLabel = UILabel()
        noEntryLabel.text = "You haven't submitted an entry yet! \n\nWhat do you expect to see???"
        noEntryLabel.font = .systemFont(ofSize: 56)
        noEntryLabel.textColor = .white
        noEntryLabel.numberOfLines = 0
        noEntryLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(noEntryLabel)
        
        noEntryLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 8).isActive = true
        noEntryLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -8).isActive = true
        noEntryLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        updateMinMaxDateQuery()
        submitButtonAction(submitButton)
        breakOutWords()
    }
    
    func updateMinMaxDateQuery() {
        queryForMinMaxDates()
        guard lastEntryDate != nil else { return }
        startDatePicker.minimumDate = firstEntryDate
        startDatePicker.maximumDate = lastEntryDate
        endDatePicker.minimumDate = firstEntryDate
        endDatePicker.maximumDate = lastEntryDate
    }
    
    func queryForMinMaxDates() {
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
            if let entries = try? context.fetch(request), entries != [] {
                self.firstEntryDate = entries[0].date
                print(self.firstEntryDate)
            }
        }
        
        context.performAndWait {
            let request: NSFetchRequest<Entry> = Entry.fetchRequest()
            request.sortDescriptors = [NSSortDescriptor(key: "date", ascending: false)]
            request.fetchLimit = 1
            if let entries = try? context.fetch(request), entries != [] {
                self.lastEntryDate = entries[0].date
                print(self.lastEntryDate)
            }
        }
    }
    
    func setUpWordLabels() {
        mostCommonWordLabel = UILabel()
        print("most used word \(mostUsedWord), \(mostUsedWord.isEmpty)")
        mostCommonWordLabel.text = mostUsedWord
        
        mostCommonWordLabel.font = .systemFont(ofSize: 32)
        mostCommonWordLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(mostCommonWordLabel)
        
        mostCommonWordDescription = UILabel()
        mostCommonWordDescription.text = "most used word"
        mostCommonWordDescription.font = .systemFont(ofSize: 16)
        mostCommonWordDescription.numberOfLines = 2
        mostCommonWordDescription.lineBreakMode = .byWordWrapping
        mostCommonWordDescription.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(mostCommonWordDescription)
        
        averageWordLengthLabel = UILabel()
        averageWordLengthLabel.text = "\(avgWordCount)"
        averageWordLengthLabel.font = .systemFont(ofSize: 32)
        averageWordLengthLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(averageWordLengthLabel)
        
        averageWordLengthDescription = UILabel()
        averageWordLengthDescription.text = "average word count"
        averageWordLengthDescription.textAlignment = .right
        averageWordLengthDescription.numberOfLines = 2
        averageWordLengthDescription.font = .systemFont(ofSize: 16)
        averageWordLengthDescription.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(averageWordLengthDescription)
        
        let margins = view.layoutMarginsGuide
        
        if #available(iOS 11, *) {
            mostCommonWordLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16).isActive = true
            averageWordLengthDescription.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20).isActive = true
        } else {
            mostCommonWordLabel.topAnchor.constraint(equalTo: topLayoutGuide.bottomAnchor, constant: 16).isActive = true
            averageWordLengthDescription.topAnchor.constraint(equalTo: topLayoutGuide.bottomAnchor, constant: 20).isActive = true
        }
        
        mostCommonWordDescription.leadingAnchor.constraint(equalTo: margins.leadingAnchor, constant: 16).isActive = true
        mostCommonWordDescription.widthAnchor.constraint(equalToConstant: screenWidth * 0.45).isActive = true
        mostCommonWordDescription.topAnchor.constraint(equalTo: mostCommonWordLabel.bottomAnchor, constant: 0).isActive = true
        
        mostCommonWordLabel.leadingAnchor.constraint(equalTo: margins.leadingAnchor, constant: 16).isActive = true
        
        averageWordLengthLabel.trailingAnchor.constraint(equalTo: margins.trailingAnchor, constant: -16).isActive = true
        averageWordLengthLabel.topAnchor.constraint(equalTo: averageWordLengthDescription.bottomAnchor, constant: 0).isActive = true
        
        averageWordLengthDescription.trailingAnchor.constraint(equalTo: margins.trailingAnchor, constant: -16).isActive = true
    }
    
    func breakOutWords() {
        var string = entries.reduce("") { $0 + $1.text! + " " }
        string = string.localizedCapitalized
        words = []
        
        print("does this print???")
        
        // You need to understand what this is actually doing
        string.enumerateSubstrings(in: string.startIndex..<string.endIndex, options: .byWords) {
            (substring, _, _, _) -> () in
            self.words.append(substring!)
        }
        
        // Better rounding method below
        avgWordCount = Double(words.count) / Double(entries.count)
        avgWordCount = round(avgWordCount * 10) / 10
        if avgWordCount.isNaN {
            avgWordCount = 0
        }
        
        let dedupedWords: [String] = words.removeDuplicates()
        
        wordCountDict = [:]
        for i in dedupedWords {
            wordCountDict[i] = words.filter { $0 == i }.count
        }
        
        // In case of multiple zvalues having the same highest count, the below will return the most recently used one
        // I think?
        let optionalMostUsedWord = wordCountDict.max { a, b in a.value < b.value }?.key
        guard let ourMostUsedWord = optionalMostUsedWord else {
            mostUsedWord = "No Data🤷🏻‍♀️"
            return
        }
        mostUsedWord = ourMostUsedWord
    }
    
    func setUpBarChart() {
        activityChart = BarChartView()
        activityChart.translatesAutoresizingMaskIntoConstraints = false
        activityChart.setBarChartFormatting()
        activityChart.setBarChartData(dataSource: entryTuples, label: "Daily Activity", color: ourBlue)
        view.addSubview(activityChart)
        
        let margins = view.layoutMarginsGuide
        activityChart.heightAnchor.constraint(equalToConstant: screenHeight * 0.25).isActive = true
        activityChart.widthAnchor.constraint(equalToConstant: screenWidth * 0.95).isActive = true
        activityChart.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        activityChart.bottomAnchor.constraint(equalTo: startDate.topAnchor, constant: -32).isActive = true
        
        activityChartLabel = UILabel()
        activityChartLabel.text = { setActivityChartLabelText(data: entryTuples) }()
        activityChartLabel.font = .systemFont(ofSize: 16)
        activityChartLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(activityChartLabel)
        
        activityChartLabel.bottomAnchor.constraint(equalTo: activityChart.topAnchor, constant: 0).isActive = true
        activityChartLabel.leadingAnchor.constraint(equalTo: margins.leadingAnchor, constant: 16).isActive = true
    }
    
    func setActivityChartLabelText(data: [(Date, Int)]) -> String {
        let totalEntries = Double(data.count)
        let totalSum = Double(data.reduce(0) { $0 + $1.1 })
        let average = totalSum / totalEntries
        let string = String(format: "%.1f", average)
        return "Average \(string) entries per day"
    }
    
    func setUpPieChart() {
        
        let labels = ["Missed", "Completed"]
        let countEmptyDays = entryTuples.filter { $0.1 == 0 }.count
        
        // The dance below is to get a nice human readible double rounded out of percentEmpty, which is used in the values command
        // we also get intPercentEmpty, which supplies the pieChartLabel
        var percentEmpty = Double(countEmptyDays) / Double(entryTuples.count)
        let intPercentEmpty = Int(round(percentEmpty * 100))
        percentEmpty = Double(intPercentEmpty) / 100
        let values: [Double] = [percentEmpty, 1 - percentEmpty]
        
        
        completionChart = PieChartView()
        completionChart.setPieChartData(labels: labels, values: values, colors: [ourYellow, ourGreen])
        completionChart.setPieChartFormatting()
        completionChart.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(completionChart)
        
        // I really, really don't like the way the top and leading anchors of this chart is setup
        // I haven't found a way to adjust the size of the background rect without modifying the size of the chart
        // Hence the gross constriants with no constant values
        completionChart.heightAnchor.constraint(equalToConstant: screenHeight * 0.25).isActive = true
        completionChart.widthAnchor.constraint(equalToConstant: screenWidth * 0.5).isActive = true
        completionChart.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        completionChart.bottomAnchor.constraint(equalTo: activityChartLabel.topAnchor, constant: -8).isActive = true
        
        pieChartLabel = UILabel()
        pieChartLabel.text = "\(100 - intPercentEmpty)% completion rate"
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
        print(firstEntryDate)
        print(lastEntryDate)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yy"
        if lastEntryDate != nil {
            startDateDate = Date(timeInterval: -60 * 60 * 24 * 6, since: lastEntryDate)
            endDateDate = lastEntryDate
        } else {
            startDateDate = Date()
            endDateDate = Date()
        }
        
        startDatePicker = UIDatePicker()
        startDatePicker.addTarget(self, action: #selector(handleStartDatePicker(_:)), for: .valueChanged)
        startDatePicker.datePickerMode = .date
        if lastEntryDate != nil {
            startDatePicker.minimumDate = firstEntryDate
            startDatePicker.maximumDate = lastEntryDate
        } else {
            startDatePicker.minimumDate = Date()
            startDatePicker.maximumDate = Date()
        }
        startDatePicker.setDate(startDateDate, animated: true)
        startDate = UITextField()
        startDate.inputView = startDatePicker
        startDate.text = dateFormatter.string(from: startDateDate)
        startDate.font = .systemFont(ofSize: 24)
        startDate.textColor = systemBlue
        startDate.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(startDate)
        
        endDatePicker = UIDatePicker()
        endDatePicker.addTarget(self, action: #selector(handleEndDatePicker(_:)), for: .valueChanged)
        endDatePicker.datePickerMode = .date
        if lastEntryDate != nil {
            endDatePicker.minimumDate = firstEntryDate
            endDatePicker.maximumDate = lastEntryDate
        } else {
            endDatePicker.minimumDate = Date()
            endDatePicker.maximumDate = Date()
        }
        endDate = UITextField()
        endDate.inputView = endDatePicker
        endDate.text = dateFormatter.string(from: endDateDate)
        endDate.font = .systemFont(ofSize: 24)
        endDate.textColor = systemBlue
        endDate.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(endDate)
        
        submitButton = UIButton(type: .system)
        submitButton.setTitle("📅 Update Dates 📅", for: [])
        submitButton.titleLabel!.font = .systemFont(ofSize: 24)
        submitButton.backgroundColor = ourGreen
        submitButton.translatesAutoresizingMaskIntoConstraints = false
        submitButton.addTarget(self, action: #selector(submitButtonAction(_:)), for: .touchUpInside)
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
        endDate.trailingAnchor.constraint(equalTo: margins.trailingAnchor, constant: -16).isActive = true
    }
    
    
    @objc func submitButtonAction(_ sender: UIButton) {
        updateEntities()
        activityChart.clear()
        activityChart.setBarChartData(dataSource: entryTuples, label: "Daily Activity", color: ourBlue)
        activityChartLabel.text = { setActivityChartLabelText(data: entryTuples) }()
        
        
        let labels = ["Missed", "Completed"]
        let countEmptyDays = entryTuples.filter { $0.1 == 0 }.count
        
        // The dance below is to get a nice human readible double rounded out of percentEmpty, which is used in the values command
        // we also get intPercentEmpty, which supplies the pieChartLabel
        var percentEmpty = Double(countEmptyDays) / Double(entryTuples.count)
        let intPercentEmpty = Int(round(percentEmpty * 100))
        percentEmpty = Double(intPercentEmpty) / 100
        let values: [Double] = [percentEmpty, 1 - percentEmpty]
        
        completionChart.clear()
        completionChart.setPieChartData(labels: labels, values: values, colors: [ourYellow, ourGreen])
        pieChartLabel.text = "\(100 - intPercentEmpty)% completion rate"
        
        breakOutWords()
        averageWordLengthLabel.text = "\(avgWordCount)"
        mostCommonWordLabel.text = mostUsedWord
        
    }
    
    func updateEntities() {
        guard let startDateString = startDate.text, let endDateString = endDate.text else { return }
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yy"
        
        guard var firstDate = dateFormatter.date(from: startDateString) else { return }
        guard var lastDate = dateFormatter.date(from: endDateString) else { return }
        
        lastDate = Date(timeInterval: 60 * 60 * 24, since: lastDate)
        
        let context = AppDelegate.viewContext
        let ourRequest: NSFetchRequest<Entry> = Entry.fetchRequest()
        ourRequest.sortDescriptors = []
        ourRequest.predicate = NSPredicate(format: "date >= %a AND date < %a", argumentArray: [firstDate as NSDate, lastDate as NSDate])
        
        
        // Can you just add a closure to perform?
        context.performAndWait {
            let entryArray = try? context.fetch(ourRequest)
            
            guard let ourEntryArray = entryArray else {
                print("No Entries???")
                return
            }
            
            
            self.entries = ourEntryArray
        }
        
        self.entryTuples.removeAll()
        while firstDate < lastDate {
            let countLastDate = Date(timeInterval: 60 * 60 * 24, since: firstDate)
            let filteredEntries = entries.filter { $0.date! >= firstDate && $0.date! < countLastDate }
            self.entryTuples.append((date: firstDate, int: filteredEntries.count))
            firstDate = Date(timeInterval: 60 * 60 * 24, since: firstDate)
        }
        print("E N T R Y  T U P L E S \n \(entryTuples) \n _______________________ \n")
    }
    
    func initTapGestureRecognizer() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard(_:)))
        
        view.addGestureRecognizer(tap)
    }
    
    @objc func handleStartDatePicker(_ sender: UIDatePicker) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yy"
        startDate.text = dateFormatter.string(from: sender.date)
        startDateDate = sender.date
        
        // Handle Date Oddities
        print("Start: \(startDateDate)")
        print("End: \(endDateDate)")
        if startDateDate > endDateDate {
            endDate.text = startDate.text
            endDateDate = startDateDate
            endDatePicker.setDate(startDateDate, animated: false)
        }
    }
    
    @objc func handleEndDatePicker(_ sender: UIDatePicker) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yy"
        endDate.text = dateFormatter.string(from: sender.date)
        endDateDate = sender.date
        
        
        // Handle Date Oddities
        if endDateDate < startDateDate {
            startDate.text = endDate.text
            startDateDate = endDateDate
            startDatePicker.setDate(endDateDate, animated: false)
        }
    }
    
    @objc func dismissKeyboard(_ sender: UITapGestureRecognizer) {
        startDate.resignFirstResponder()
        endDate.resignFirstResponder()
    }
}
