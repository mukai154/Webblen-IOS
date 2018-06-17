//
//  GroupOptionsViewController.swift
//  WebblenEvents
//
//  Created by Mukai Selekwa on 6/16/18.
//  Copyright © 2018 Mukai Selekwa. All rights reserved.
//

import UIKit
import Firebase

class GroupOptionsViewController: UIPageViewController {

    //Database Variables
    var database = Firestore.firestore()
    var webblenGroup:webblenGroup?
    var currentUser = Auth.auth().currentUser
    var groupKey:String?
    var groupName:String?
    var groupSize:Int?
    var isNewGroup = false
    
    //UI
    @IBOutlet weak var groupNameTxtField: UITextField!
    @IBOutlet weak var addMemberView: UIView!
    @IBOutlet weak var removeMemberView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if isNewGroup {
            removeMemberView.isHidden = true
        }
        // Do any additional setup after loading the view.
    }
    
    

    //Button Actions
    @IBAction func didPressCreate(_ sender: Any) {
    }
    @IBAction func didPressBack(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    @IBAction func didPressAddMember(_ sender: Any) {
        performSegue(withIdentifier: "addMemberSegue", sender: nil)
    }
    @IBAction func didPressRemoveMember(_ sender: Any) {
//        performSegue(withIdentifier: "removeMemberSegue", sender: nil)
    }
    
}
