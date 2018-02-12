//
//  MyEventsTableViewCell.swift
//  WebblenEvents
//
//  Created by Mukai Selekwa on 1/7/17.
//  Copyright © 2017 Mukai Selekwa. All rights reserved.
//

import UIKit

class MyEventsTableViewCell: UITableViewCell {

    @IBOutlet weak var interestCategory: UIImageView!
    @IBOutlet weak var eventTitle: UILabel!
    @IBOutlet weak var eventDescription: UITextView!
    @IBOutlet weak var eventDate: UILabel!
    @IBOutlet weak var isVerified: UIImageView!

    
    @IBOutlet weak var verifiedWidth: NSLayoutConstraint!

    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        eventDescription.textContainerInset = UIEdgeInsetsMake(5, -1, 0, 0)
        eventDescription.translatesAutoresizingMaskIntoConstraints = true
        eventDescription.textColor = UIColor.lightGray
        verifiedWidth.constant = 0
        

    }
    
    public func configure(eventTitle:String, eventDate:String, isVerified:String, eventDescription: String, eventPhoto: String?){
        self.eventTitle.text = eventTitle
        self.eventDate.text = eventDate
        self.eventDescription.text = eventDescription
        
        if (isVerified == "true"){
            self.isVerified.isHidden = false
            self.verifiedWidth.constant = 20
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
