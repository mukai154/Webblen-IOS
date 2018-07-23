//
//  NewEventConfirmViewController.swift
//  WebblenEvents
//
//  Created by Mukai Selekwa on 6/30/18.
//  Copyright © 2018 Mukai Selekwa. All rights reserved.
//

import UIKit
import Firebase
import NVActivityIndicatorView
import PCLBlurEffectAlert
import SwiftyStoreKit

class NewEventConfirmViewController: UIViewController {
    
    //Payment Details
    var products = ["com.webblen.events.notify250",
                    "com.webblen.events.notify375",
                    "com.webblen.events.notify575",
                    "com.webblen.events.notify975",
                    "com.webblen.events.notify1975",
                    "com.webblen.events.notify3075",
                    "com.webblen.events.notify5975",
                    "com.webblen.events.notify8475",
                    "com.webblen.events.notify10000"]
    
    var sharedSecret = "3fd70aaa6f914c799e7930abd16e0523"
    
    //Firebase
    var dataBase = Firestore.firestore()
    var currentUser = Auth.auth().currentUser
    
    //New Event
    var newEvent:EventPost?
    var eventsFree = true
    var userHasFreeEvents = false
    var eventKey:String?
    
    
    //UI
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var eventUserPic: UIImageViewX!
    @IBOutlet weak var eventTitle: UILabel!
    @IBOutlet weak var eventUsername: UILabel!
    @IBOutlet weak var eventCaption: UILabel!
    @IBOutlet weak var eventImg: UIImageViewX!
    @IBOutlet weak var eventImgAspectRatio: NSLayoutConstraint!
    @IBOutlet weak var eventImageHeight: NSLayoutConstraint!
    @IBOutlet weak var addressLbl: UILabel!
    @IBOutlet weak var dateTimeLbl: UILabel!
    @IBOutlet weak var totalLbl: UILabel!
    
    //Activity & Colors
    var activeColor = UIColor(red: 30/300, green: 39/300, blue: 46/300, alpha: 1.0)
    var loadingColor = UIColor(red: 255/300, green: 192/300, blue: 72/300, alpha: 1.0)
    var inactiveColor = UIColor(red: 178/300, green: 190/300, blue: 195/300, alpha: 1.0)
    var loadingView = NVActivityIndicatorView(frame: CGRect(x: (100), y: (100), width: 125, height: 125),
                                              type: .circleStrokeSpin,
                                              color: UIColor(red: 158/255, green: 158/255, blue: 158/255, alpha: 1.0),
                                              padding: 0)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let xAxis = self.view.center.x
        let yAxis = self.view.center.y
        let frame = CGRect(x: (xAxis-25), y: (yAxis-25), width: 50, height: 50)
        loadingView = NVActivityIndicatorView(frame: frame, type: .circleStrokeSpin, color: activeColor, padding: 0)
        self.view.addSubview(loadingView)
        loadingView.startAnimating()
        
        for product in products {
            retrieveProducts(product: product)
        }
        loadEventData()
        setUserData()
    }
    
    @IBAction func didPressBack(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func didPressConfirmBtn(_ sender: Any) {
        loadingView.startAnimating()
        let eventRadius = (newEvent?.radius)!
        if (userHasFreeEvents || eventsFree ){
            eventPurchased()
        } else {
            if eventRadius < 275 {
                purchaseProduct(product: self.products[0])
            } else if eventRadius < 400 {
                purchaseProduct(product: self.products[1])
            } else if eventRadius < 600 {
                purchaseProduct(product: self.products[2])
            } else if eventRadius < 1000 {
                purchaseProduct(product: self.products[3])
            } else if eventRadius < 2000 {
                purchaseProduct(product: self.products[4])
            } else if eventRadius < 3100 {
                purchaseProduct(product: self.products[5])
            } else if eventRadius < 6000 {
                purchaseProduct(product: self.products[6])
            } else if eventRadius < 8500 {
                purchaseProduct(product: self.products[7])
            } else if eventRadius <= 10000 {
                purchaseProduct(product: self.products[8])
            }
        }
    }
    
    
    func loadEventData(){
        if newEvent != nil {
            setUserData()
            setEventTotal(val: (newEvent?.radius)!)
            eventTitle.text = newEvent?.title
            eventCaption.text = newEvent?.caption
            addressLbl.text = "Address: " + (newEvent?.address)!
            dateTimeLbl.text = "Date & Time: " + (newEvent?.startDate)! + " | " + (newEvent?.startTime)!
            //Set Image
            if newEvent?.uploadedImage as? String == "" {
                eventImgAspectRatio.isActive = false
                eventImageHeight.isActive = true
                eventImg.isHidden = true
            } else {
                eventImg.image = newEvent?.uploadedImage as! UIImage
            }
        }
    }
    
    func setUserData(){
        self.dataBase.collection("users").document((currentUser?.uid)!).getDocument(completion: {(snapshot, error) in
            if !(snapshot?.exists)! {
                self.performSegue(withIdentifier: "SetupSegue", sender: nil)
            } else if error != nil{
//                print(error)
            } else {
                let imageURL = snapshot?.data()!["profile_pic"] as? String
                let currentUsername = snapshot?.data()!["username"] as? String
                let hasFreeEvents = snapshot?.data()!["hasFreeEvents"] as? Bool
                if hasFreeEvents != nil {
                    self.userHasFreeEvents = hasFreeEvents!
                }
                if imageURL != nil && currentUsername != nil {
                    self.newEvent?.author = currentUsername!
                    self.newEvent?.authorImagePath = imageURL!
                    let url = NSURL(string: imageURL!)
                    self.eventUserPic.sd_setImage(with: url! as URL)
                    self.eventUserPic.isHidden = false
                    self.eventUsername.text = "@" +  currentUsername!.lowercased()
                    self.activityIndicator.isHidden = true
                    self.loadingView.stopAnimating()
                }
            }
        })
    }
    
    func setEventTotal(val: Double){
        if eventsFree {
            totalLbl.text = "Total: FREE"
        } else if val < 275 {
            totalLbl.text = "Total: $2.99"
        } else if val < 400 {
            totalLbl.text = "Total: $4.99"
        } else if val < 600 {
            totalLbl.text = "Total: $9.99"
        } else if val < 1000 {
            totalLbl.text = "Total: $14.99"
        } else if val < 2000 {
            totalLbl.text = "Total: $19.99"
        } else if val < 3100 {
            totalLbl.text = "Total: $24.99"
        } else if val < 6000 {
            totalLbl.text = "Total: $26.99"
        } else if val < 8500 {
            totalLbl.text = "Total: $29.99"
        } else {
            totalLbl.text = "Total: $34.99"
        }
    }
    
    func eventPurchased(){
        let uploadVal = newEvent?.uploadedImage as? String
        //Event With Image
        if uploadVal != "" {
            uploadEventWithImage()
        } else {
            uploadEventWithoutImage()
        }
    }
    
    func uploadEventWithImage(){
        let newEventReference = dataBase.collection("eventposts").document()
        eventKey = newEventReference.documentID
        //Event Image Path & Data
        let imageStorage = Storage.storage().reference(forURL: "gs://webblen-events.appspot.com/events")
        let imagePath = self.eventKey! + ".jpg"
        let imageRef = imageStorage.child(imagePath)
        let imageData = UIImageJPEGRepresentation((self.newEvent?.uploadedImage)! as! UIImage, 1.0)
        //Upload Image
        let uploadImage = imageRef.putData(imageData!, metadata: nil) {(metadata, error) in
            if error != nil {
                self.showAlert(withTitle: "Event Upload Error", message: "Error occurred while uploading event")
            } else {
                imageRef.downloadURL(completion: {(url, error) in
                    if let url = url {
                        newEventReference.setData([
                            "title": (self.newEvent?.title)!,
                            "address": (self.newEvent?.address)!,
                            "startDate": (self.newEvent?.startDate)!,
                            "endDate": (self.newEvent?.endDate)!,
                            "description": (self.newEvent?.description)!,
                            "caption": (self.newEvent?.caption)!,
                            "tags": (self.newEvent?.tags)!,
                            "eventKey": newEventReference.documentID,
                            "lat": (self.newEvent?.lat)!,
                            "lon": (self.newEvent?.lon)!,
                            "pathToImage": url.absoluteString,
                            "radius": (self.newEvent?.radius)!,
                            "startTime": (self.newEvent?.startTime)!,
                            "endTime": (self.newEvent?.endTime)!,
                            "author": (self.newEvent?.author)!,
                            "authorImagePath": (self.newEvent?.authorImagePath)!,
                            "views": 0,
                            "website": (self.newEvent?.website)!,
                            "fbSite": (self.newEvent?.fbSite)!,
                            "twitterSite": (self.newEvent?.twitterSite)! ])
                        self.eventPurchasedAlert()
                    }
                })
            }
        }
    }
    
    func uploadEventWithoutImage(){
        let newEventReference = dataBase.collection("eventposts").document()
        eventKey = newEventReference.documentID
        newEventReference.setData([
            "title": (self.newEvent?.title)!,
            "address": (self.newEvent?.address)!,
            "startDate": (self.newEvent?.startDate)!,
            "endDate": (self.newEvent?.endDate)!,
            "description": (self.newEvent?.description)!,
            "caption": (self.newEvent?.caption)!,
            "tags": (self.newEvent?.tags)!,
            "eventKey": newEventReference.documentID,
            "lat": (self.newEvent?.lat)!,
            "lon": (self.newEvent?.lon)!,
            "pathToImage": "",
            "radius": (self.newEvent?.radius)!,
            "startTime": (self.newEvent?.startTime)!,
            "endTime": (self.newEvent?.endTime)!,
            "author": (self.newEvent?.author)!,
            "views": 0,
            "website": (self.newEvent?.website)!,
            "fbSite": (self.newEvent?.fbSite)!,
            "twitterSite": (self.newEvent?.twitterSite)! ])
        eventPurchasedAlert()
    }
    
    
    //PAYMENTS
    func retrieveProducts(product: String){
        SwiftyStoreKit.retrieveProductsInfo([product]) { result in
            if let product = result.retrievedProducts.first {
                let priceString = product.localizedPrice!
                print("Product: \(product.localizedDescription), price: \(priceString)")
            }
            else if let invalidProductId = result.invalidProductIDs.first {
                return
            }
            else {
                print("Error: \(result.error)")
            }
        }
    }
    
    func purchaseProduct(product: String){
        SwiftyStoreKit.retrieveProductsInfo([product]) { result in
            if let product = result.retrievedProducts.first {
                SwiftyStoreKit.purchaseProduct(product, quantity: 1, atomically: true) { result in
                    switch result {
                    case .success(let product):
                        // fetch content from your server, then:
                        if product.needsFinishTransaction {
                            SwiftyStoreKit.finishTransaction(product.transaction)
                        }
                        print("Purchase Success: \(product.productId)")
                        self.eventPurchased()
                    case .error(let error):
                        switch error.code {
                        case .unknown: self.loadingView.stopAnimating()
                        case .clientInvalid: self.loadingView.stopAnimating()
                        case .paymentCancelled: break
                        case .paymentInvalid: print("The purchase identifier was invalid")
                        case .paymentNotAllowed: self.showAlert(withTitle: "Payment Not Allowed", message: "This Device Cannot Make Payments")
                        self.loadingView.stopAnimating()
                        case .storeProductNotAvailable: print("The product is not available in the current storefront")
                        case .cloudServicePermissionDenied: print("Access to cloud service information is not allowed")
                        case .cloudServiceNetworkConnectionFailed: self.showAlert(withTitle: "Event Could Not Be purchased", message: "Please Check Your Connection")
                        self.loadingView.stopAnimating()
                        case .cloudServiceRevoked: print("User has revoked permission to use this cloud service")
                        }
                    }
                    
                }
            }
        }
    }
    
    func verifyPurchases(product: String, sharedSecret: String){
        let appleValidator = AppleReceiptValidator(service: .production, sharedSecret: sharedSecret)
        SwiftyStoreKit.verifyReceipt(using: appleValidator) { result in
            switch result {
            case .success(let receipt):
                // Verify the purchase of Consumable or NonConsumable
                let purchaseResult = SwiftyStoreKit.verifyPurchase(
                    productId: product,
                    inReceipt: receipt)
                
                switch purchaseResult {
                case .purchased(let receiptItem):
                    print("Product is purchased: \(receiptItem)")
                case .notPurchased:
                    print("The user has never purchased this product")
                }
            case .error(let error):
                print("Receipt verification failed: \(error)")
            }
        }
    }
    
    func eventPurchasedAlert(){
        let alertController = PCLBlurEffectAlertController(title: "Event Purchase Successful!", message: "Interested Users Will be Able to Find this Event", style: .alert)
        let action = PCLBlurEffectAlertAction(title: "OK", style: .default) { _ in self.performSegue(withIdentifier: "homeSegue", sender: nil) }
        alertController.addAction(action)
        present(alertController, animated: true, completion: nil)
    }
}
