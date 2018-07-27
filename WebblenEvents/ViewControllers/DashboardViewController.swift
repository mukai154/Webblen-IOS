//
//  DashboardViewController.swift
//  WebblenEvents
//
//  Created by Mukai Selekwa on 5/16/18.
//  Copyright © 2018 Mukai Selekwa. All rights reserved.
//

import UIKit
import Firebase
import PCLBlurEffectAlert
import CoreLocation
import UserNotifications
import Hero

class DashboardViewController: UIViewController, CLLocationManagerDelegate {

    //Firebase References
    var dataBase = Firestore.firestore()
    var currentUser = Auth.auth().currentUser
    var profilePicStorage = Storage.storage().reference(forURL: "gs://webblen-events.appspot.com/profile_pics")
    var imagePicker = UIImagePickerController()
    var userImg:UIImage?
    var username:String?
    
    
    @IBOutlet var dashboardView: UIView!
    @IBOutlet weak var updateRequiredLbl: UILabel!
    @IBOutlet weak var userProfilePic: UIImageViewX!
    @IBOutlet weak var userQRCode: UIImageViewX!
    @IBOutlet weak var userQRBtn: UIButton!
    @IBOutlet weak var usernameLbl: UILabel!
    @IBOutlet weak var accountValLbl: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    @IBOutlet weak var notificationView: UIViewX!
    @IBOutlet weak var notificationCountLbl: UILabel!
    
    @IBOutlet weak var heartIcon: UIImageView!
    @IBOutlet weak var calendarIcon: UIImageView!
    @IBOutlet weak var walletIcon: UIImageView!
    @IBOutlet weak var mapIcon: UIImageView!
    @IBOutlet weak var listIcon: UIImageView!
    
    
    //QRCODE
    var filter = CIFilter(name: "CIQRCodeGenerator")
    var uidQRCodeImg:UIImage?
    var uidQRCodeImgLarge:UIImage?
    var scaleX:CGFloat?
    var scaleY:CGFloat?
    
    //Location
    var locationManager = CLLocationManager()
    
    //App
    var CURRENT_APP_VERSION = "3.4.2"
    var notificationCount:Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        UIApplication.shared.applicationIconBadgeNumber = 0
        locationAccessCheck()
        requestPermissions()
        setHeroIDS()
        loadFirestoreProfileData()
    }
    
    //Override Status Bar
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        UIApplication.shared.statusBarStyle = .default
    }
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return .default
    }
    
    //HERO TRANSITIONS
    func setHeroIDS(){
        heartIcon.hero.id = "heart"
        calendarIcon.hero.id = "calendar"
        walletIcon.hero.id = "wallet"
        mapIcon.hero.id = "map"
        listIcon.hero.id = "list"
        userProfilePic.hero.id = "profileImage"
        usernameLbl.hero.id = "username"
        accountValLbl.hero.id = "accountValue"
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
                        self.setUIDQRCode(key: (self.currentUser?.uid)!)
                        self.setUIDQRCodeLarge(key: (self.currentUser?.uid)!)
                        self.userProfilePic.sd_setImage(with: url! as URL)
                        self.userProfilePic.clipsToBounds = true
                        self.userProfilePic.isHidden = false
                        self.userQRCode.clipsToBounds = true
                        self.userQRBtn.isHidden = false
                        self.userQRCode.isHidden = false
                        self.username = "@" +  currentUsername!.lowercased()
                        self.usernameLbl.text = self.username
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
            let appURL = NSURL(string:"https://itunes.apple.com/us/app/webblen/id1196159158?ls=1&mt=8")! as URL
            UIApplication.shared.open(appURL, options: [:], completionHandler: nil)
        })
        let cancelButton = UIAlertAction(title: "Cancel", style: .cancel, handler: { (action) -> Void in })
        alertController.addAction(updateButton)
        alertController.addAction(cancelButton)
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    func setUIDQRCode(key: String){
        let uidData = key.data(using: String.Encoding.isoLatin1)
        filter?.setValue(uidData, forKey: "inputMessage")
        let generatedImg = filter?.outputImage
        if generatedImg != nil {
            scaleX = self.userQRCode.frame.width / (generatedImg?.extent.size.width)!
            scaleY = self.userQRCode.frame.height / (generatedImg?.extent.size.height)!
        } else {
            scaleX = 50
            scaleY = 50
        }
        let transform = CGAffineTransform(scaleX: scaleX!, y: scaleY!)
        
        if let output = filter?.outputImage?.transformed(by: transform){
            uidQRCodeImg = UIImage(ciImage: output)
            self.userQRCode.image = uidQRCodeImg
        }
    }
    
    func setUIDQRCodeLarge(key: String){
        let uidData = key.data(using: String.Encoding.isoLatin1)
        filter?.setValue(uidData, forKey: "inputMessage")
        let generatedImg = filter?.outputImage
        if generatedImg != nil {
            scaleX = 50
            scaleY = 50
        }
        let transform = CGAffineTransform(scaleX: scaleX!, y: scaleY!)
        
        if let output = filter?.outputImage?.transformed(by: transform){
            uidQRCodeImgLarge = UIImage(ciImage: output)
        }
    }

    @IBAction func didPressQRBtn(_ sender: Any) {
        let alertController = PCLBlurEffectAlertController(title: "Account ID", message: nil, effect: UIBlurEffect(style: .regular),style: .alert)
        alertController.addImageView(with: uidQRCodeImgLarge!)
        let backAction = PCLBlurEffectAlertAction(title: "Back", style: .default) { _ in}
        let copyAction = PCLBlurEffectAlertAction(title: "Copy", style: .default) { _ in
            UIPasteboard.general.string = self.currentUser?.uid
            self.showBlurAlert(title: "Saved to Clipboard!", message: nil)
        }
        alertController.configure(cornerRadius: 15.0)
        alertController.configure(backgroundColor: .white)
        alertController.configure(buttonBackgroundColor: .white)
        alertController.configure(buttonTextColor: [.default: .black, .destructive: .black])
        alertController.addAction(backAction)
        alertController.addAction(copyAction)
        alertController.show()
    }
    
    @IBAction func didPressMyEvents(_ sender: Any) {
        performSegue(withIdentifier: "myEventsSegue", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "myEventsSegue"){
            let eventIn = segue.destination as! EventListViewController
            eventIn.myEvents = true
        } else if (segue.identifier == "walletSegue"){
            let eventIn = segue.destination as! WalletViewController
            eventIn.userImg = self.userImg
            eventIn.username = self.username ?? ""
        }
    }
    
    func requestPermissions(){
        //Notification Request
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { (granted, error) in }
        //Location Request
        locationManager.delegate = self
        locationManager.requestAlwaysAuthorization()
    }
    
    func locationAccessCheck(){
        func locationAccessCheck(){
            if CLLocationManager.locationServicesEnabled(){
                switch CLLocationManager.authorizationStatus() {
                case .notDetermined, .restricted, .denied:
                    showBlurAlert(title: "Not Able to Retrieve Your Location", message: "It looks like this device has location services disabled. Enable them to Know What is Happening Around You")
                case .authorizedAlways:
                    break
                case .authorizedWhenInUse:
                    break
                }
            }
        }
    }
    
}
