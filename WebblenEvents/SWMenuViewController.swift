//
//  SWMenuViewController.swift
//  WebblenEvents
//
//  Created by Mukai Selekwa on 11/5/17.
//  Copyright © 2017 Mukai Selekwa. All rights reserved.
//

import UIKit
import Firebase

class SWMenuViewController: UIViewController {

    //Firebase References
    var dataBase = Firestore.firestore()
    var currentUser: AnyObject?
    
    //Menu Icons
    @IBOutlet weak var listEventsIcon: UIImageView!
    @IBOutlet weak var myInterestsIcon: UIImageView!
    @IBOutlet weak var createEventIcon: UIImageView!
    @IBOutlet weak var myEventsIcon: UIImageView!
    @IBOutlet weak var walletIcon: UIImageView!
    @IBOutlet weak var accountSettingsIcon: UIImageView!
    @IBOutlet weak var contactUsIcon: UIImageView!
    @IBOutlet weak var logoutIcon: UIImageView!
    
    //User Views
    @IBOutlet weak var userProfilePic: UIImageView!
    @IBOutlet weak var username: UILabel!
    @IBOutlet weak var userAccountValue: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //Set Menu Views
        let favIc = UIImage(named: "ic_favorite_white")
        let favTemplate = favIc?.withRenderingMode(.alwaysTemplate)

        let newEventIc = UIImage(named: "add_ic")
        let newEventTemplate = newEventIc?.withRenderingMode(.alwaysTemplate)
        
        let eventIc = UIImage(named: "ic_event")
        let eventTemplate = eventIc?.withRenderingMode(.alwaysTemplate)

        let walletIc = UIImage(named: "wallet_ic")
        let walletTemplate = walletIc?.withRenderingMode(.alwaysTemplate)
        
        let settingsIc = UIImage(named: "ic_settings")
        let settingsTemplate = settingsIc?.withRenderingMode(.alwaysTemplate)
        
        let contactIc = UIImage(named: "help-circle")
        let contactTemplate = contactIc?.withRenderingMode(.alwaysTemplate)
        
        let logoutIc = UIImage(named: "ic_exit_to_app")
        let logoutTemplate = logoutIc?.withRenderingMode(.alwaysTemplate)

        myInterestsIcon.image = favTemplate
        myInterestsIcon.tintColor = UIColor(red: 250/255, green: 250/255, blue: 250/255, alpha: 1.0)
        
        createEventIcon.image = newEventTemplate
        createEventIcon.tintColor = UIColor(red: 250/255, green: 250/255, blue: 250/255, alpha: 1.0)
        
        myEventsIcon.image = eventTemplate
        myEventsIcon.tintColor = UIColor(red: 250/255, green: 250/255, blue: 250/255, alpha: 1.0)
        walletIcon.image = walletTemplate
        walletIcon.tintColor = UIColor(red: 250/255, green: 250/255, blue: 250/255, alpha: 1.0)
        
        accountSettingsIcon.image = settingsTemplate
        accountSettingsIcon.tintColor = UIColor(red: 250/255, green: 250/255, blue: 250/255, alpha: 1.0)
        
        contactUsIcon.image = contactTemplate
        contactUsIcon.tintColor = UIColor(red: 250/255, green: 250/255, blue: 250/255, alpha: 1.0)
        
        logoutIcon.image = logoutTemplate
        logoutIcon.tintColor = UIColor(red: 250/255, green: 250/255, blue: 250/255, alpha: 1.0)
        
        
        //Database Handler
        currentUser = Auth.auth().currentUser
        loadFirestoreProfileData()
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func loadFirestoreProfileData(){
        if currentUser == nil {
            self.performSegue(withIdentifier: "loginSegue", sender: nil)
        }
        else {
            self.dataBase.collection("users").document((currentUser?.uid)!).getDocument(completion: {(snapshot, error) in
                if !(snapshot?.exists)! {
                    self.performSegue(withIdentifier: "SetupSegue", sender: nil)
                } else if error != nil{
                    print(error)
                } else {
                    let imageURL = snapshot?.data()!["profile_pic"] as? String
                    let currentUsername = snapshot?.data()!["username"] as? String
                    if imageURL != nil && currentUsername != nil {
                        let url = NSURL(string: imageURL!)
                        self.userProfilePic.sd_setImage(with: url! as URL)
                        self.userProfilePic.layer.cornerRadius = self.userProfilePic.frame.size.width / 2;
                        self.userProfilePic.clipsToBounds = true;
                        self.userProfilePic.layer.borderWidth = 2
                        self.userProfilePic.layer.borderColor = UIColor(red: 250/255, green: 250/255, blue: 250/255, alpha: 1.0).cgColor
                        self.username.text = "@" +  currentUsername!
                    } else {
                        self.performSegue(withIdentifier: "SetupSegue", sender: nil)
                    }
                }
            })
        }
    }
    
    @IBAction func didPressLogout(_ sender: Any) {
        if (Auth.auth().currentUser != nil){
            do{
                try Auth.auth().signOut()
                let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "initialView")
                present(vc, animated: true, completion: nil)
            } catch let error as NSError{
                print(error.localizedDescription)
            }
        }
    }
    
    @IBAction func didPressContactUs(_ sender: Any) {
        let settingsUrl = NSURL(string:"https://webblen.io") as! URL
        UIApplication.shared.open(settingsUrl, options: [:], completionHandler: nil)
    }
    

}
