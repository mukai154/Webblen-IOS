//
//  DashboardViewController.swift
//  WebblenEvents
//
//  Created by Mukai Selekwa on 5/16/18.
//  Copyright © 2018 Mukai Selekwa. All rights reserved.
//

import UIKit
import Firebase

class DashboardViewController: UIViewController {

    //Firebase References
    var dataBase = Firestore.firestore()
    var currentUser = Auth.auth().currentUser
    var profilePicStorage = Storage.storage().reference(forURL: "gs://webblen-events.appspot.com/profile_pics")
    var imagePicker = UIImagePickerController()
    var userImg:UIImage?
    
    
    @IBOutlet var dashboardView: UIView!
    @IBOutlet weak var updateRequiredLbl: UILabel!
    @IBOutlet weak var userProfilePic: UIImageViewX!
    @IBOutlet weak var usernameLbl: UILabel!
    @IBOutlet weak var accountValLbl: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    @IBOutlet weak var notificationView: UIViewX!
    @IBOutlet weak var notificationCountLbl: UILabel!
    
    var CURRENT_APP_VERSION = "3.3.0"
    var notificationCount:Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        loadFirestoreProfileData()

        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //** FIREBASE
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
                        self.userProfilePic.clipsToBounds = true;
                        self.userProfilePic.isHidden = false
                        self.usernameLbl.text = "@" +  currentUsername!
                        self.usernameLbl.isHidden = false
                        self.accountValLbl.isHidden = false
                        self.activityIndicator.isHidden = true
                        
                        self.dataBase.collection("app_release_info").document("ios").getDocument(completion: {(snapshot, error) in
                            if error != nil {
                                
                            } else {
                                let NEWEST_VERSION = snapshot?.data()!["versionNumber"] as? String
                                let required = snapshot?.data()!["required"] as? Bool
                                
                                if self.CURRENT_APP_VERSION != NEWEST_VERSION {
                                    if required! {
                                        self.showUpdateAlert()
                                        UIView.animate(withDuration: 1.0, delay: 0.0, options: UIViewAnimationOptions.curveEaseIn, animations: {
                                            self.dashboardView.alpha = 0.5
                                            self.dashboardView.isUserInteractionEnabled = false
                                        }, completion: nil)
                                        self.updateRequiredLbl.isHidden = false
                                    }
                                }
                            }
                        })
                        
                    } else {
                        self.performSegue(withIdentifier: "SetupSegue", sender: nil)
                    }
                }
            })
        }
    }
    
    func showUpdateAlert(){
        let alertController = UIAlertController(title: "Update Required", message: "A New Version of Webblen is Available in the App Store. Please Update From Your Current Version", preferredStyle: .actionSheet)
        let updateButton = UIAlertAction(title: "Update", style: .default, handler: { (action) -> Void in
            let appURL = NSURL(string:"https://itunes.apple.com/us/app/webblen/id1196159158?ls=1&mt=8") as! URL
            UIApplication.shared.open(appURL, options: [:], completionHandler: nil)
        })
        let cancelButton = UIAlertAction(title: "Cancel", style: .cancel, handler: { (action) -> Void in })
        alertController.addAction(updateButton)
        alertController.addAction(cancelButton)
        
        self.present(alertController, animated: true, completion: nil)
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
