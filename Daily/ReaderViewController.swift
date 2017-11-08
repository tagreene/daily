//
//  ReaderViewController.swift
//  Daily
//
//  Created by Trent Greene on 9/26/17.
//  Copyright © 2017 greene. All rights reserved.
//

import UIKit
import CoreData

class ReaderViewController: UIViewController, UICollectionViewDataSource {
    var containerView: UIView!
    var collectionView: UICollectionView!
    var startDateButton = UITextField()
    var endDateButton = UITextField()
    var submitButton = UIButton()
    var startDatePicker = UIDatePicker()
    var endDatePicker = UIDatePicker()
    var entries = [Entry]()
    var firstEntryDate: Date!
    var lastEntryDate: Date!
    var endDate: Date!
    var startDate: Date!
    var entriesDict = [(date: Date, entries: String)]()
    
    var systemBlue = UIColor(red: 0, green: 0.478431, blue: 1, alpha: 1)
    var ourGreen = UIColor(red: 150/255.0, green: 245.0/255.0, blue: 150/255.0, alpha: 1)
    var ourYellow = UIColor(red: 255/255, green: 254/255, blue: 254/255, alpha: 1)
    var ourBlue = UIColor(red: 207/255, green: 223/255, blue: 242/255, alpha: 1)
    var ourBlue2 = UIColor(red: 207/255, green: 223/255, blue: 242/255, alpha: 0.8)
    var ourSalmon = UIColor(red: 217.0/255.0, green: 133.0/255.0, blue: 137.0/255.0, alpha: 1)
    var ourYellow2 = UIColor(red: 255.0/255.0, green: 255.0/255.0, blue: 89.0/255.0, alpha: 0.8)

    
    let screenHeight = UIScreen.main.bounds.height
    let screenWidth = UIScreen.main.bounds.width
    
    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addGradient()
        queryForMinMaxDates()
        updateEntities()
        setUpDateSelection()
        setUpContainerView()
        setUpCollectionView()
        initTapGestureRecognizer()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        updateMinMaxDateQuery()
        updateEntities()
        collectionView.reloadData()
    }
    
    // MARK: - Set Up UIViews
    func setUpDateSelection() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yy"
        
        if lastEntryDate != nil {
            startDate = (Date(timeInterval: -60 * 60 * 24 * 6, since: lastEntryDate) > firstEntryDate)
                ? Date(timeInterval: -60 * 60 * 24 * 6, since: lastEntryDate)
                : firstEntryDate
            endDate = lastEntryDate
        } else {
            startDate = Date()
            endDate = Date()
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
        startDatePicker.setDate(startDate, animated: true)
        startDateButton = UITextField()
        startDateButton.inputView = startDatePicker
        startDateButton.text = dateFormatter.string(from: startDate)
        startDateButton.backgroundColor = ourYellow2
        startDateButton.textAlignment = .center
        startDateButton.font = .systemFont(ofSize: 24)
        startDateButton.textColor = systemBlue
        startDateButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(startDateButton)
        
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
        endDateButton = UITextField()
        endDateButton.inputView = endDatePicker
        endDateButton.text = dateFormatter.string(from: endDate)
        endDateButton.backgroundColor = ourYellow2
        endDateButton.textAlignment = .center
        endDateButton.font = .systemFont(ofSize: 24)
        endDateButton.textColor = systemBlue
        endDateButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(endDateButton)
        
        submitButton = UIButton(type: .system)
        submitButton.addTarget(self, action: #selector(submitButtonAction(_:)), for: .touchUpInside)
        submitButton.setTitle("📅 Update Dates 📅", for: [])
        submitButton.titleLabel!.font = .systemFont(ofSize: 24)
        submitButton.backgroundColor = ourGreen
        submitButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(submitButton)
        
        submitButton.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        submitButton.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        submitButton.heightAnchor.constraint(equalToConstant: screenHeight * 0.096).isActive = true
        if #available(iOS 11, *) {
            submitButton.bottomAnchor.constraintEqualToSystemSpacingBelow(view.safeAreaLayoutGuide.bottomAnchor, multiplier: 0).isActive = true
        } else {
            submitButton.bottomAnchor.constraint(equalTo: bottomLayoutGuide.topAnchor, constant: 0).isActive = true
        }
        
        startDateButton.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        startDateButton.bottomAnchor.constraint(equalTo: submitButton.topAnchor).isActive = true
        startDateButton.heightAnchor.constraint(equalToConstant: screenHeight * 0.063).isActive = true
        startDateButton.widthAnchor.constraint(equalToConstant: screenWidth * 0.498).isActive = true
        
        
        endDateButton.centerYAnchor.constraint(equalTo: startDateButton.centerYAnchor).isActive = true
        endDateButton.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        endDateButton.heightAnchor.constraint(equalToConstant: screenHeight * 0.063).isActive = true
        endDateButton.widthAnchor.constraint(equalToConstant: screenWidth * 0.498).isActive = true
    }
    
    func setUpCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.estimatedItemSize = CGSize(width: 1, height: 1)
        layout.minimumLineSpacing = 8
        collectionView = UICollectionView(frame: containerView.frame, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.layer.cornerRadius = 10
        collectionView.contentInset = UIEdgeInsetsMake(4, 0, 8, 0)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(ReaderCell.self, forCellWithReuseIdentifier: "readerCell")
        self.containerView.addSubview(collectionView)
        
        collectionView.topAnchor.constraint(equalTo: containerView.topAnchor).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor).isActive = true
        collectionView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor).isActive = true
        collectionView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor).isActive = true
        
    }
    
    func setUpContainerView() {
        containerView = UIView()
        containerView.layer.cornerRadius = 5
        containerView.translatesAutoresizingMaskIntoConstraints = false
        containerView.backgroundColor = ourYellow
        view.addSubview(containerView)
        
        let margins = view.layoutMarginsGuide
        containerView.leadingAnchor.constraint(equalTo: margins.leadingAnchor).isActive = true
        containerView.trailingAnchor.constraint(equalTo: margins.trailingAnchor).isActive = true
        
        if AppDelegate.isIPhone5() {
            containerView.bottomAnchor.constraint(equalTo: startDateButton.topAnchor, constant: -20).isActive = true
        } else {
            containerView.bottomAnchor.constraint(equalTo: startDateButton.topAnchor, constant: -32).isActive = true
        }
        
        if #available(iOS 11, *) {
            containerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 8).isActive = true
        } else {
            containerView.topAnchor.constraint(equalTo: topLayoutGuide.bottomAnchor, constant: 8).isActive = true
        }
    }
    
    func addGradient() {
        let gradient: CAGradientLayer = CAGradientLayer()
        gradient.frame.size = self.view.frame.size
        gradient.colors = [ourBlue.cgColor, ourBlue2.cgColor]
        gradient.endPoint = CGPoint.init(x: 1.0, y: 0.25)
        gradient.startPoint = CGPoint.init(x: 0.5, y: 1.0)
        self.view.layer.insertSublayer(gradient, at: 0)
    }
    
    // MARK: - UI Methods
    @objc func handleStartDatePicker(_ sender: UIDatePicker) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yy"
        startDateButton.text = dateFormatter.string(from: sender.date)
        startDate = sender.date
        
        // Handle Date Oddities
        if startDate > endDate {
            endDateButton.text = startDateButton.text
            endDate = startDate
            endDatePicker.setDate(startDate, animated: false)
        }
        print(startDate)
    }
    
    @objc func handleEndDatePicker(_ sender: UIDatePicker) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yy"
        endDateButton.text = dateFormatter.string(from: sender.date)
        endDate = sender.date
        
        
        // Handle Date Oddities
        if endDate < startDate {
            startDateButton.text = endDateButton.text
            startDate = endDate
            startDatePicker.setDate(endDate, animated: false)
        }
        print(endDate)
    }
    
    func initTapGestureRecognizer() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard(_:)))
        
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard(_ sender: UITapGestureRecognizer) {
        startDateButton.resignFirstResponder()
        endDateButton.resignFirstResponder()
    }
    
    @objc func submitButtonAction(_ sender: UIButton) {
        updateEntities()
        collectionView.reloadData()
    }
    
    func updateEntities() {
        guard let startDateString = startDateButton.text, let endDateString = endDateButton.text else { return }
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
        
        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "h:mm a"
        timeFormatter.amSymbol = "am"
        timeFormatter.pmSymbol = "pm"
        timeFormatter.locale = Locale(identifier: "en_US_POSIX")
        entriesDict.removeAll()
        
        // Increasing firstDate by 1 hour to handle any DST issues
        firstDate = Date(timeInterval: 60 * 60, since: firstDate)
        while firstDate < lastDate {
            print(firstDate)
            print(lastDate)
            let countLastDate = Date(timeInterval: 60 * 60 * 24, since: firstDate)
            print(countLastDate)
            let filteredEntries = entries.filter { $0.date! >= firstDate && $0.date! < countLastDate }
            var daysEntries = String()
            for i in filteredEntries {
                guard let entryDate = i.date else { return }
                let entryTime = timeFormatter.string(from: entryDate)
                guard let entryText = i.text else { return }
                
                daysEntries += "\(entryTime)\n\(entryText)\n\n"
            }
            daysEntries = String(daysEntries.dropLast(2)) // Kill the two hanging carriage returns - \n is treated as one character
            if !daysEntries.isEmpty {
                entriesDict.append((date: firstDate, entries: daysEntries))
            }
            firstDate = Date(timeInterval: 60 * 60 * 24, since: firstDate)
        }
        print(entriesDict)
    }
    
    // MARK: - CoreData Queries
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

}

// MARK: - UICollectionViewDelegateFlowLayout Extension
extension ReaderViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return entriesDict.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "readerCell", for: indexPath) as! ReaderCell
        cell.setUp(date: entriesDict.reversed()[indexPath.item].date, entries: entriesDict.reversed()[indexPath.item].entries)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: containerView.frame.width, height: 10)
    }
    
}
