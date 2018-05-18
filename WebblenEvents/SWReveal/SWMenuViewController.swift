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
    @IBOutlet weak var contactUsIcon: UIImageView!

    
    //User Views
    @IBOutlet weak var userProfilePic: UIImageView!
    @IBOutlet weak var username: UILabel!
    @IBOutlet weak var userAccountValue: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //Set Menu Views
        let listIc = UIImage(named: "ic_dashboard")
        let listTemplate = listIc?.withRenderingMode(.alwaysTemplate)
        
        let favIc = UIImage(named: "ic_favorite_white")
        let favTemplate = favIc?.withRenderingMode(.alwaysTemplate)

        let newEventIc = UIImage(named: "add_ic")
        let newEventTemplate = newEventIc?.withRenderingMode(.alwaysTemplate)
        
        let contactIc = UIImage(named: "help-circle")
        let contactTemplate = contactIc?.withRenderingMode(.alwaysTemplate)
        

        listEventsIcon.image = listTemplate
        listEventsIcon.tintColor = UIColor(red: 250/255, green: 250/255, blue: 250/255, alpha: 1.0)
        
        myInterestsIcon.image = favTemplate
        myInterestsIcon.tintColor = UIColor(red: 250/255, green: 250/255, blue: 250/255, alpha: 1.0)
        
        createEventIcon.image = newEventTemplate
        createEventIcon.tintColor = UIColor(red: 250/255, green: 250/255, blue: 250/255, alpha: 1.0)

        contactUsIcon.image = contactTemplate
        contactUsIcon.tintColor = UIColor(red: 250/255, green: 250/255, blue: 250/255, alpha: 1.0)
        
        
        
        //Database Handler
        currentUser = Auth.auth().currentUser
        loadFirestoreProfileData()
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.revealViewController().view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        self.revealViewController().frontViewController.revealViewController().tapGestureRecognizer()
        self.revealViewController().frontViewController.view.isUserInteractionEnabled = false
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.revealViewController().frontViewController.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        self.revealViewController().frontViewController.view.isUserInteractionEnabled = true
    }
    
    //** FUNCTIONS
    
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
                        self.changeProfileImage(imageURL: imageURL!)
                        self.username.text = "@" +  currentUsername!
                    } else {
                        self.performSegue(withIdentifier: "SetupSegue", sender: nil)
                    }
                }
            })
        }
    }
    
    //Change Profile Image
    public func changeProfileImage(imageURL: String){
        let url = NSURL(string: imageURL)
        self.userProfilePic.sd_setImage(with: url! as URL)
        self.userProfilePic.layer.cornerRadius = self.userProfilePic.frame.size.width / 2;
        self.userProfilePic.clipsToBounds = true;
        self.userProfilePic.layer.borderWidth = 2
        self.userProfilePic.layer.borderColor = UIColor(red: 250/255, green: 250/255, blue: 250/255, alpha: 1.0).cgColor
    }
    
    
    //** Btn Actions
    @IBAction func didPressDashboard(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }

    
    @IBAction func didPressContactUs(_ sender: Any) {
        let settingsUrl = NSURL(string:"https://webblen.io") as! URL
        UIApplication.shared.open(settingsUrl, options: [:], completionHandler: nil)
    }
    

}
