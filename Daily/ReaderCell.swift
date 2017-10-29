//
//  ReaderCell.swift
//  Daily
//
//  Created by Trent Greene on 10/17/17.
//  Copyright © 2017 greene. All rights reserved.
//

import UIKit

class ReaderCell: UICollectionViewCell {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpViews()
    }
    
    func setUpViews() {
        addSubview(dateLabel)
        addSubview(entriesLabel)
        addConstraints(withVisualFormat: "V:|[v0][v1]|", views: dateLabel, entriesLabel)
        addConstraints(withVisualFormat: "H:|-8-[v0]-8-|", views: dateLabel)
        addConstraints(withVisualFormat: "H:|-8-[v0]-8-|", views: entriesLabel)
        dateLabel.widthAnchor.constraint(equalToConstant: frame.width - 16).isActive = true
        entriesLabel.widthAnchor.constraint(equalToConstant: frame.width - 16).isActive = true
    }
    
    var dateLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 24)
        label.textAlignment = .right
        label.text = "10/17/17"
        return label
    }()
    
    var entriesLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16)
        label.text = "4:30PM\nPlease God??\n\n3:02 PM\nI hope this works like I think it will"
        label.numberOfLines = 0
        return label
    }()
    
    func setUp(date: Date, entries: String) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yy"
        
        self.dateLabel.text = dateFormatter.string(from: date)
        self.entriesLabel.text = entries
        print(entries)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension UIView {
    func addConstraints(withVisualFormat format: String, views: UIView...) {
        var viewsDictionary = [String:UIView]()
        for (index, view) in views.enumerated() {
            let key = "v\(index)"
            view.translatesAutoresizingMaskIntoConstraints = false
            viewsDictionary[key] = view
        }
        
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: format, options: NSLayoutFormatOptions(), metrics: nil, views: viewsDictionary))
    }
}
