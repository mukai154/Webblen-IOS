//
//  HomeTableViewCell.swift
//  
//
//  Created by Mukai Selekwa on 1/5/17.
//
//

import UIKit

public class HomeTableViewCell: UITableViewCell {



    @IBOutlet weak var username: UILabel!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var evDescription: UILabel!
    @IBOutlet weak var category: UIImageView!

    
    override public func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override public func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    

}
