//
//  ReaderCell.swift
//  Daily
//
//  Created by Trent Greene on 10/17/17.
//  Copyright © 2017 greene. All rights reserved.
//

import UIKit

class ReaderCell: UICollectionViewCell {
    
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
        return label
    }()
    
    var entriesLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16)
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
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

