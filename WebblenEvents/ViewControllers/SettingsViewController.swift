//
//  SettingsViewController.swift
//  WebblenEvents
//
//  Created by Mukai Selekwa on 1/17/17.
//  Copyright © 2017 Mukai Selekwa. All rights reserved.
//

import UIKit
import Firebase

class SettingsViewController: UIViewController {



    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        //Uncomment the line below if you want the tap not not interfere and cancel other interactions.
        //tap.cancelsTouchesInView = false
        


        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func didPressBack(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    

}
