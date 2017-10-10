//
//  NewEntryViewController.swift
//  Daily
//
//  Created by Trent Greene on 9/6/17.
//  Copyright © 2017 greene. All rights reserved.
//

import UIKit
import CoreData

class NewEntryViewController: UIViewController, UITextViewDelegate {

    let defaultString = "Say whatever ..."
    let confirmationString = "🌊😎~Submitted~😎🌊"
    
    let screenHeight = UIScreen.main.bounds.height
    
    var ourTextView: UITextView!
    var cancelButton: UIButton!
    var submitButton: UIButton!
    var deleteAlert: UIAlertController!
    
    func deleteEntry() {
        let deleteCompletion = {
            self.ourTextView.text = self.defaultString
            self.ourTextView.textColor = UIColor.darkGray
        }
        ourTextView.shakeHorizontally(deleteCompletion)
    }
    
    @objc func initDeleteAlert(_ sender: UIButton) {
        guard ourTextView.text != defaultString else { return }
        
        let deleteAlert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        deleteAlert.addAction(cancelAction)
        
        let deleteAction = UIAlertAction(title: "Clear Text", style: .destructive, handler: { (action) -> Void in
            self.deleteEntry()
        })
        deleteAlert.addAction(deleteAction)
        
        present(deleteAlert, animated: true, completion: nil)
    }
    
    @objc func createEntry(_ sender: UIButton) {
        if let entryString = ourTextView.text, entryString != defaultString, entryString != confirmationString {
            
            let context = AppDelegate.viewContext
            context.perform {
                let entry = Entry(context: context)
                entry.text = entryString
                entry.date = Date()
                
                do {
                    try context.save()
                } catch let err {
                    print(err)
                }
            }
            
            
            // Change Text -- Replace this with better feedback (Haptic?)
            let createCompletion = {
                self.ourTextView.text = self.confirmationString
                self.ourTextView.textColor = .darkGray
            }
            
            ourTextView.shakeVertically(createCompletion)
            
            // Debug - Is Core Data Working?
            context.perform {
                let sortDescriptor = NSSortDescriptor(key: "date", ascending: true)
                let request: NSFetchRequest<Entry> = Entry.fetchRequest()
                request.sortDescriptors = [sortDescriptor]
                if let recentEntries = try? context.fetch(request) {
                    for entry in recentEntries {
                        print(entry.date!, entry.text!)
                    }
                }
            }
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initializeOurTextView()
        
        initializeCancelButton()
        initializeSubmitButton()
        print(submitButton.bounds.height)
        print(cancelButton.bounds.height)
        
        initTapGestureRecognizer()

        addGradient()
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    func initializeCancelButton() {
        cancelButton = UIButton(type: .system)
        cancelButton.translatesAutoresizingMaskIntoConstraints = false
        cancelButton.setTitle("🌀 Start Over 🌀", for: [])
        cancelButton.titleLabel!.font = .systemFont(ofSize: 24)
        cancelButton.backgroundColor = UIColor.init(red: 255.0/255.0, green: 255.0/255.0, blue: 89.0/255.0, alpha: 0.9)
        cancelButton.addTarget(self, action: #selector(initDeleteAlert(_:)), for: .touchUpInside)
        view.addSubview(cancelButton)
        
        let leadingConstraint = cancelButton.leadingAnchor.constraint(equalTo: view.leadingAnchor)
        let trailingConstraint = cancelButton.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        let heightConstraint = cancelButton.heightAnchor.constraint(equalToConstant: screenHeight * 0.096)
        
        if #available(iOS 11, *) {
            let bottomConstraint = cancelButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 0)
            bottomConstraint.isActive = true
        } else {
            let bottomConstraint = cancelButton.bottomAnchor.constraint(equalTo: bottomLayoutGuide.topAnchor)
            bottomConstraint.isActive = true
        }
        
        
        leadingConstraint.isActive = true
        trailingConstraint.isActive = true
        heightConstraint.isActive = true
        
    }
    
    func initializeSubmitButton() {
        submitButton = UIButton(type: .system)
        submitButton.translatesAutoresizingMaskIntoConstraints = false
        submitButton.setTitle("🏋️‍♀️ Submit 🏋️‍♀️", for: [])
        submitButton.titleLabel!.font = .systemFont(ofSize: 24)
        submitButton.backgroundColor = UIColor.init(red: 95.0/255.0, green: 255.0/255.0, blue: 88.0/255.0, alpha: 0.8)
        submitButton.addTarget(self, action: #selector(NewEntryViewController.createEntry(_:)), for: .touchUpInside)
        view.addSubview(submitButton)
        
        let bottomConstraint = submitButton.bottomAnchor.constraint(equalTo: cancelButton.topAnchor)
        let leadingConstraint = submitButton.leadingAnchor.constraint(equalTo: view.leadingAnchor)
        let trailingConstraint = submitButton.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        let heightConstraint = submitButton.heightAnchor.constraint(equalToConstant: screenHeight * 0.096)
        
        bottomConstraint.isActive = true
        leadingConstraint.isActive = true
        trailingConstraint.isActive = true
        heightConstraint.isActive = true
    }

    func initializeOurTextView() {
        ourTextView = UITextView()
        
        ourTextView.delegate = self
        ourTextView.text = defaultString
        ourTextView.textColor = UIColor.darkGray
        ourTextView.backgroundColor = UIColor.init(red: 255.0/255.0, green: 255.0/255.0, blue: 255.0/255.0, alpha: 0.8)
        ourTextView.layer.cornerRadius = 5
        ourTextView.font = .systemFont(ofSize: 16)
        ourTextView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(ourTextView)
        
        let margins = view.layoutMarginsGuide
        let leadingConstraint = ourTextView.leadingAnchor.constraint(equalTo: margins.leadingAnchor)
        let trailingConstraint = ourTextView.trailingAnchor.constraint(equalTo: margins.trailingAnchor)
        let heightConstraint = ourTextView.heightAnchor.constraint(equalToConstant: screenHeight * 0.48)
        
        if #available(iOS 11, *) {
            let topConstraint = ourTextView.topAnchor.constraintEqualToSystemSpacingBelow(view.safeAreaLayoutGuide.topAnchor, multiplier: 1)
            topConstraint.isActive = true
        } else {
            let topConstraint = ourTextView.topAnchor.constraint(equalTo: topLayoutGuide.bottomAnchor, constant: 8)
            topConstraint.isActive = true
        }
        
        leadingConstraint.isActive = true
        trailingConstraint.isActive = true
        heightConstraint.isActive = true
    }
    
    func addGradient() {
        let gradient: CAGradientLayer = CAGradientLayer()
        gradient.frame.size = self.view.frame.size
        gradient.colors = [UIColor.init(red: 240.0/255.0, green: 113.0/255.0, blue: 122.0/255.0, alpha: 1.0).cgColor, UIColor.init(red: 217.0/255.0, green: 84.0/255.0, blue: 89.0/255.0, alpha: 0.7).cgColor]
        gradient.endPoint = CGPoint.init(x: 1.0, y: 0.25)
        gradient.startPoint = CGPoint.init(x: 0.5, y: 1.0)
        self.view.layer.insertSublayer(gradient, at: 0)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func initTapGestureRecognizer() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard(_:)))
        
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard(_ sender: UITapGestureRecognizer) {
        textViewDidEndEditing(ourTextView)
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == defaultString || textView.text == confirmationString {
            textView.text = nil
            textView.textColor = UIColor.black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        
        if textView.text.isEmpty {
            textView.text = defaultString
            textView.textColor = UIColor.darkGray
        }
        
        textView.resignFirstResponder()
    }
}


