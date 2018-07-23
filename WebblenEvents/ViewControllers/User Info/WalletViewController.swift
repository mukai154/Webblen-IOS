//
//  WalletViewController.swift
//  WebblenEvents
//
//  Created by Mukai Selekwa on 4/4/18.
//  Copyright © 2018 Mukai Selekwa. All rights reserved.
//

import UIKit
import Firebase
import SDWebImage
import Hero

class WalletViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    //Firebase References
    var dataBase = Firestore.firestore()
    var currentUser = Auth.auth().currentUser
    var profilePicStorage = Storage.storage().reference(forURL: "gs://webblen-events.appspot.com/profile_pics")
    var imagePicker = UIImagePickerController()
    var userImg:UIImage?
    
    //User UI
    @IBOutlet weak var profilePicBtn: UIButton!
    @IBOutlet weak var profileImageShadowView: UIViewX!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var profileUsernameLabel: UILabel!
    @IBOutlet weak var eventRatioView: UIViewX!
    @IBOutlet weak var walletInfoTable: UITableView!
    @IBOutlet weak var backArrowBtn: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //image picker
        imagePicker.delegate = self
        
        //Data
        loadFirestoreProfileData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //HERO TRANSITIONS
    func setHeroIDS(){
        profileImageView.hero.id = "profile_pic"
        profileUsernameLabel.hero.id = "username"
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
                        self.profileImageView.sd_setImage(with: url! as URL)
                        self.profileImageView.layer.cornerRadius = self.profileImageView.frame.size.width / 2
                        self.profileImageView.clipsToBounds = true
                        self.profileImageView.layer.borderWidth = 2
                        self.profileImageView.layer.borderColor = UIColor(red: 250/255, green: 250/255, blue: 250/255, alpha: 1.0).cgColor
                        self.profileImageView.isHidden = false
                        self.profileUsernameLabel.text = "@" +  currentUsername!.lowercased()
                        self.profileUsernameLabel.isHidden = false
                        self.activityIndicator.isHidden = true
                        self.profilePicBtn.isEnabled = true
                    } else {
                        self.performSegue(withIdentifier: "SetupSegue", sender: nil)
                    }
                }
            })
        }
    }
    
    //*** BUTTON ACTIONS
    @IBAction func didPressProfilePic(_ sender: Any) {
        imagePicker.allowsEditing = true
        imagePicker.sourceType = .photoLibrary
        self.present(imagePicker, animated: true, completion: nil)
    }
    @IBAction func didPressBackArrowBtn(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }


    //*** METHODS
    //Photo has been selected
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerEditedImage] as? UIImage {
            profileImageView.image = image
            profileImageView.clipsToBounds = true
        }
        let imageData = UIImageJPEGRepresentation(self.profileImageView.image!, 1.0)
        let imageRef = self.profilePicStorage.child((self.currentUser?.uid)! + ".jpg")
        let uploadImage = imageRef.putData(imageData!, metadata: nil) {(metadata, error) in
            if error != nil {
                self.showAlert(withTitle: "Photo Update Error", message: "There was in issue updating your profile pic.")
                return
            }
            imageRef.downloadURL(completion: {(url, error) in
                if let url = url {
                    let userDocRef = self.dataBase.collection("users")
                    userDocRef.document((self.currentUser?.uid)!).updateData(["profile_pic":url.absoluteString])
                    //SWMenuViewController.changeProfileImage(url.absoluteString)
                }
            })
        }
        self.dismiss(animated: true, completion: nil)
    }
}

//*** EXTENSIONS

//** TABLE
extension WalletViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        
        let lblTitle = cell?.viewWithTag(1) as! UILabel
        let lblDetail = cell?.viewWithTag(2) as! UILabel
        let lblSelection1 = cell?.viewWithTag(3) as! UILabel
        let lblSelection2 = cell?.viewWithTag(4) as! UILabel
        
        cell?.backgroundColor =     indexPath.row % 2 == 0 ? #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0) : #colorLiteral(red: 0.9215686275, green: 0.9215686275, blue: 0.9215686275, alpha: 1)
        
        lblSelection2.isHidden = false
        
        if [0,1,2,4].contains(indexPath.row) {
            lblSelection2.isHidden = true
        }
        
        if indexPath.row == 0 {
            lblTitle.text = "WEBBLEN"
            lblDetail.text = "Tokens that can be traded and transferred at anytime .Webblen can be converted to Web Power in a process called powering up."
            lblSelection1.text = "0.000 WBLN  ▼"
        }
        
        if indexPath.row == 1 {
            lblTitle.text = "WEB POWER"
            lblDetail.text = "Influence tokens which give you more control over event payout and allow you to earn more on attendance rewards."
            lblSelection1.text = "0.000 WBLN  ▼"
        }
        
        if indexPath.row == 2 {
            lblTitle.text = "WEB DOLLARS"
            lblDetail.text = "Tokens worth about $1.00 of WBLN,currently collecting 0% APR."
            lblSelection1.text = "$0.00"
        }
        
        if indexPath.row == 3 {
            lblTitle.text = "SAVING"
            lblDetail.text = "Balance subject to 3 day withdraw waiting period,web Dollars currently collecting 0% APR."
            lblSelection1.text = "0.000 WBLN  ▼"
            lblSelection2.text = "$0.00  ▼"
        }
        
        if indexPath.row == 4 {
            lblTitle.text = "Account Value"
            lblDetail.text = "The value is based on an average value of WBLN in US dollars. "
            lblSelection1.text = "$0.00"
        }
        cell?.selectionStyle = UITableViewCellSelectionStyle.none
        return cell!
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
}
