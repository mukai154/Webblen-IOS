//
//  homeCell.swift
//  WebblenEvents
//
//  Created by Mukai Selekwa on 8/15/17.
//  Copyright © 2017 Mukai Selekwa. All rights reserved.
//

import UIKit

class homeCell: UITableViewCell {

    @IBOutlet weak var interestCategory: UIImageView!
    @IBOutlet weak var eventTitle: UILabel!
    @IBOutlet weak var eventDate: UILabel!
    @IBOutlet weak var isVerified: UIImageView!
    @IBOutlet weak var eventDescription: UITextView!
    @IBOutlet weak var eventPhoto: UIImageView!
    
    @IBOutlet weak var imageViewHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var verifiedWidth: NSLayoutConstraint!

    var currentDate : String?
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.layoutIfNeeded()
        
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/dd/yyyy"
        currentDate = formatter.string(from: date)
        
        eventDescription.textContainerInset = UIEdgeInsetsMake(5, -1, 0, 0)
        eventDescription.translatesAutoresizingMaskIntoConstraints = true
        eventDescription.textColor = UIColor.lightGray
        isVerified.isHidden = true
        verifiedWidth.constant = 0
        
        eventPhoto.layer.cornerRadius = 5
        eventPhoto.layer.masksToBounds = true

        
        // Initialization code
    }

    public func configure(eventTitle:String, eventDate:String, isVerified:Bool, eventDescription: String, eventPhoto: String?){
        
        
        self.eventTitle.text = eventTitle
        self.eventDate.text = eventDate
        self.eventDescription.text = eventDescription
        
        if (isVerified == true){
           self.isVerified.isHidden = false
            self.verifiedWidth.constant = 20
        }
        
        if (eventDate == currentDate){
            self.eventDate.text = "Today"
            self.eventDate.textColor = UIColor.red
        }
        
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
