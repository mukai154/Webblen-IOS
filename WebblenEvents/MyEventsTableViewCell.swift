//
//  MyEventsTableViewCell.swift
//  WebblenEvents
//
//  Created by Mukai Selekwa on 1/7/17.
//  Copyright © 2017 Mukai Selekwa. All rights reserved.
//

import UIKit

class MyEventsTableViewCell: UITableViewCell {

    @IBOutlet weak var eventCategoryPic: UIImageView!
    @IBOutlet weak var eventTitle: UILabel!
    @IBOutlet weak var eventDescription: UITextView!
    @IBOutlet weak var eventDate: UILabel!
    @IBOutlet weak var isVerified: UIImageView!
    @IBOutlet weak var eventPic: UIImageView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        eventDescription.textContainerInset = UIEdgeInsetsMake(0, 0, 0, 0)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
