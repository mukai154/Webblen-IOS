//
//  UserInfoViewController.swift
//  WebblenEvents
//
//  Created by Mukai Selekwa on 6/1/18.
//  Copyright © 2018 Mukai Selekwa. All rights reserved.
//

import UIKit
import Firebase

class UserInfoViewController: UIViewController {

    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var userImg: UIImageViewX!
    @IBOutlet weak var usernameLbl: UILabel!
    @IBOutlet weak var eventCountsView: UIViewX!
    @IBOutlet weak var eventsCreatedLbl: UILabel!
    @IBOutlet weak var eventsAttendedLbl: UILabel!
    
    //Firebase
    var dataBase = Firestore.firestore()
    var currentUser = Auth.auth().currentUser
    var selectedUserUID = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadData()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func loadData() {
        let selectedUserRef = dataBase.collection("users").document(selectedUserUID)
        selectedUserRef.getDocument(completion: {(snapshot, error) in
            if let snapshot = snapshot {
                if snapshot.exists {
                    let data = snapshot.data()!
                    let username = data["username"] as? String
                    let profile_pic = data["profile_pic"] as? String
                    let eventsCreated = data["eventsCreated"] as? Int
                    let eventsAttended = data["eventsAttended"] as? Int
                    
                    let usernameText = "@" + username!
                    self.usernameLbl.text = usernameText
                    if profile_pic != nil {
                        let url = NSURL(string: profile_pic!)
                        self.userImg.sd_setImage(with: url! as URL)
                        self.userImg.clipsToBounds = true
                        self.userImg.layer.borderWidth = 2
                        self.userImg.layer.borderColor = UIColor.white.cgColor

                    }
                    if eventsCreated != nil {
                        self.eventsCreatedLbl.text = String(eventsCreated!)
                    } else {
                        self.eventsCreatedLbl.text = "0"
                    }
                    
                    if eventsAttended != nil {
                        self.eventsAttendedLbl.text = String(eventsAttended!)
                    } else {
                        self.eventsAttendedLbl.text = "0"
                    }
                    
                    self.userImg.isHidden = false
                    self.usernameLbl.isHidden = false
                    self.eventCountsView.isHidden = false
                    self.activityIndicator.isHidden = true
                }
            }
        })
    }
    
    
    @IBAction func didPressDismiss(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
}
