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

    
    @IBOutlet weak var myInterestsIcon: UIImageView!
    
    @IBOutlet weak var myEventsIcon: UIImageView!
    
    @IBOutlet weak var accountSettingsIcon: UIImageView!
    
    @IBOutlet weak var contactUsIcon: UIImageView!
    
    @IBOutlet weak var logoutIcon: UIImageView!

    @IBOutlet weak var username: UILabel!
    //Firebase References
    var dataBase = Firestore.firestore()
    var currentUser: AnyObject?
    
    //Variables
    var currentUsername: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //Set Menu Views
        let favIc = UIImage(named: "ic_favorite_white")
        let favTemplate = favIc?.withRenderingMode(.alwaysTemplate)

        let eventIc = UIImage(named: "ic_event")
        let eventTemplate = eventIc?.withRenderingMode(.alwaysTemplate)

        let logoutIc = UIImage(named: "ic_exit_to_app")
        let logoutTemplate = logoutIc?.withRenderingMode(.alwaysTemplate)

        let contactIc = UIImage(named: "help-circle")
        let contactTemplate = contactIc?.withRenderingMode(.alwaysTemplate)

        let settingsIc = UIImage(named: "ic_settings")
        let settingsTemplate = settingsIc?.withRenderingMode(.alwaysTemplate)

        myInterestsIcon.image = favTemplate
        myInterestsIcon.tintColor = UIColor(red: 189/255, green: 189/255, blue: 189/255, alpha: 1.0)
        
        myEventsIcon.image = eventTemplate
        myEventsIcon.tintColor = UIColor(red: 189/255, green: 189/255, blue: 189/255, alpha: 1.0)
        
        accountSettingsIcon.image = settingsTemplate
        accountSettingsIcon.tintColor = UIColor(red: 189/255, green: 189/255, blue: 189/255, alpha: 1.0)
        
        contactUsIcon.image = contactTemplate
        contactUsIcon.tintColor = UIColor(red: 189/255, green: 189/255, blue: 189/255, alpha: 1.0)
        
        logoutIcon.image = logoutTemplate
        logoutIcon.tintColor = UIColor(red: 189/255, green: 189/255, blue: 189/255, alpha: 1.0)
        
        
        //Database Handler
        currentUser = Auth.auth().currentUser
        
        if currentUser == nil {
            self.performSegue(withIdentifier: "loginSegue", sender: nil)
        }
        self.dataBase.collection("users").document((currentUser?.uid)!).getDocument(completion: {(snapshot, error) in
            if !(snapshot?.exists)! {
                self.performSegue(withIdentifier: "SetupSegue", sender: nil)
            }
            else if error != nil{
                print(error)
            }
            else {
                self.username.text = snapshot?.data()!["username"] as! String
            }
        })
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
    


}
