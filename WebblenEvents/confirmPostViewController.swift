//
//  confirmPostViewController.swift
//  WebblenEvents
//
//  Created by Mukai Selekwa on 8/10/17.
//  Copyright © 2017 Mukai Selekwa. All rights reserved.
//

import UIKit
import Firebase
import SwiftyStoreKit
import StoreKit
import CoreLocation


var sharedSecret = "3fd70aaa6f914c799e7930abd16e0523"

enum RegisteredPurchase : String {
    case event5 = "notifyFive"
    
}

//Network Activity Indicator
class NetworkActivityIndicatorManager : NSObject {
    
    private static var loadingCount = 0
    
    class func NetworkOperationStarted(){
    if loadingCount == 0 {
    
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    
        }
        
        loadingCount += 1
    }
    
    class func networkOperationFinished() {
       
        if loadingCount > 0 {
            loadingCount -= 1
        }
        
        if loadingCount == 0 {
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
        }
        
    }
    
}

//VIEWCONTROLLER
class confirmPostViewController: UIViewController {

//Outlets
    @IBOutlet weak var ePhoto: UIImageView!
    @IBOutlet weak var eTitle: UILabel!
    @IBOutlet weak var eAddress: UILabel!
    @IBOutlet weak var eDateTime: UILabel!
    @IBOutlet weak var eNotifyRadius: UILabel!
    @IBOutlet weak var eTotalCost: UILabel!

    
//Variables
    var eventTitle = "title"
    var eventDateTime = "date & time"
    var eventRadius = "radius"
    var eventImage : UIImage?
    var eventKey = "key"
    var eventUID = "uid"
    var paid = "false"
    var lat = 0.0
    var lon = 0.0
    var eventCost = 0
    
    var dataBaseRef: DatabaseReference!
    var currentUser: AnyObject?
    
    var Money : Int!
    
    let bundleID = "com.webblen.events"
    
    var event5 = RegisteredPurchase.event5
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
        
        //Uncomment the line below if you want the tap not not interfere and cancel other interactions.
        
        tap.cancelsTouchesInView = true
        view.addGestureRecognizer(tap)
        
        //Database Ref
        dataBaseRef = Database.database().reference()
        self.currentUser = Auth.auth().currentUser
        
        //Gather and display new event info
        self.dataBaseRef.child("Event").child(eventKey).observeSingleEvent(of: .value, with: {(snapshot) in
            
            if let eDict = snapshot.value as? [String: AnyObject]{
                self.ePhoto.image = UIImage(named: (eDict["category"] as? String)!)
                let eAddress = eDict["address"] as? String
                self.eAddress.text = eAddress
                self.eTitle.text = eDict["title"] as? String
                let eDate = eDict["date"] as! String
                let eTime = eDict["time"] as! String
                self.eDateTime.text = eDate + " | " + eTime
                self.eventRadius = eDict["radius"] as! String
                self.eNotifyRadius.text = "Notify those within " + (self.eventRadius) + " miles"
                self.paid = eDict["paid"] as! String            }

        })
        
        self.dataBaseRef.child("LocationCoordinates").child(eventKey).observeSingleEvent(of: .value, with: {(snapshot) in
            
            if let eDict = snapshot.value as? [String: AnyObject]{
                self.lat = eDict["lat"] as! Double
                self.lon = eDict["lon"] as! Double
                
            }
            
        })
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //Causes the view (or one of its embedded text fields) to resign the first responder status.
    func dismissKeyboard() {
        view.endEditing(true)
    }
    
    
    @IBAction func didPressConfirm(_ sender: Any) {
        
        if (currentUser?.uid == "5EeE4RHUxWTa0E8BmwK2b0V1kKn2" || currentUser?.uid == "KFDuKYEoHbUmc1B0nsfbssON6zY2" || currentUser?.uid == "3kMQYwkjlUOmZU651KbrblkMYWp2"){
            self.dataBaseRef.child("Event").child(self.eventKey).child("paid").setValue("false")
            self.dataBaseRef.child("Event").child(self.eventKey).child("verified").setValue("true")
            
            monitorRegionAtLocation(center: CLLocationCoordinate2DMake(self.lat, self.lon), identifier: self.eventKey)
            
            self.performSegue(withIdentifier: "eventPurchasedSegue", sender: nil)
        }
        else{
        purchase(purchase: event5)
        }
    }
    
    
    
    //Store Kit Functions
    func getInfo(purchase : RegisteredPurchase) {
        
        NetworkActivityIndicatorManager.NetworkOperationStarted()
        SwiftyStoreKit.retrieveProductsInfo([bundleID]) { result in
            if let product = result.retrievedProducts.first {
                let priceString = product.localizedPrice!
                print("Product: \(product.localizedDescription), price: \(priceString)")
            }
            else if let invalidProductId = result.invalidProductIDs.first {
                return self.showAlert(withTitle: "Could not retrieve product info", message: "Invalid product identifier: \(invalidProductId)")
            }
            else {
                print("Error: \(result.error)")
            }
        }
        
    }
    
    func purchase(purchase : RegisteredPurchase) {
        
        NetworkActivityIndicatorManager.NetworkOperationStarted()
        SwiftyStoreKit.purchaseProduct(bundleID, quantity: 1, atomically: true) { result in
            NetworkActivityIndicatorManager.networkOperationFinished()
            switch result {
            case .success(let purchase):
                print("Purchase Success: \(purchase.productId)")
            case .error(let error):
                switch error.code {
                case .unknown: print("Unknown error. Please contact support")
                case .clientInvalid: print("Not allowed to make the payment")
                case .paymentCancelled: break
                case .paymentInvalid: print("The purchase identifier was invalid")
                case .paymentNotAllowed: print("The device is not allowed to make the payment")
                case .storeProductNotAvailable: print("The product is not available in the current storefront")
                case .cloudServicePermissionDenied: print("Access to cloud service information is not allowed")
                case .cloudServiceNetworkConnectionFailed: print("Could not connect to the network")
                case .cloudServiceRevoked: print("User has revoked permission to use this cloud service")
                }
            }
        }
        
    }
    
    func restorePurchases() {
        
        NetworkActivityIndicatorManager.NetworkOperationStarted()
        SwiftyStoreKit.restorePurchases(atomically: true) { results in
            
            NetworkActivityIndicatorManager.networkOperationFinished()
            if results.restoreFailedPurchases.count > 0 {
                print("Restore Failed: \(results.restoreFailedPurchases)")
            }
            else if results.restoredPurchases.count > 0 {
                print("Restore Success: \(results.restoredPurchases)")
            }
            else {
                print("Nothing to Restore")
            }
        }
        
    }
    
    func verifyReceipt() {
        NetworkActivityIndicatorManager.NetworkOperationStarted()
        SwiftyStoreKit.verifyReceipt(using: sharedSecret as! ReceiptValidator, completion: {
            result in
            NetworkActivityIndicatorManager.networkOperationFinished()
            
            self.showAlert(alert: self.alertForVerifyReceipt(result: result))
            
            if case .error(let error) = result {
                if case .noReceiptData = error {
                    
                    self.refreshReceipt()
                    
                }
            }
            
        })
    }
    
    
    func verifyPurchase(product : RegisteredPurchase) {
        NetworkActivityIndicatorManager.NetworkOperationStarted()
        let appleValidator = AppleReceiptValidator(service: .production, sharedSecret: sharedSecret)
        SwiftyStoreKit.verifyReceipt(using: appleValidator) { result in
            switch result {
            case .success(let receipt):
                // Verify the purchase of Consumable or NonConsumable
                let purchaseResult = SwiftyStoreKit.verifyPurchase(
                    productId: self.bundleID,
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
    
    func refreshReceipt() {
        SwiftyStoreKit.fetchReceipt(forceRefresh: true) { result in
            switch result {
            case .success(let receiptData):
                let encryptedReceipt = receiptData.base64EncodedString(options: [])
                print("Fetch receipt success:\n\(encryptedReceipt)")
            case .error(let error):
                print("Fetch receipt failed: \(error)")
            }
        }
    }
    
//Dismiss
    @IBAction func didPressCancel(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    
    
}

//Alerts
extension confirmPostViewController {
    
    
    func alertWithTitle(title : String, message : String) -> UIAlertController {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        return alert
        
    }
    func showAlert(alert : UIAlertController) {
        guard let _ = self.presentedViewController else {
            self.present(alert, animated: true, completion: nil)
            return
        }
        
    }
    func alertForProductRetrievalInfo(result : RetrieveResults) -> UIAlertController {
        if let product = result.retrievedProducts.first {
            let priceString = product.localizedPrice!
            return alertWithTitle(title: product.localizedTitle, message: "\(product.localizedDescription) - \(priceString)")
            
        }
        else if let invalidProductID = result.invalidProductIDs.first {
            return alertWithTitle(title: "Could not retreive product info", message: "Invalid product identifier: \(invalidProductID)")
        }
        else {
            let errorString = result.error?.localizedDescription ?? "Unknown Error. Please Contact Support"
            return alertWithTitle(title: "Could not retreive product info" , message: errorString)
            
        }
        
    }
   

    func alertForVerifyReceipt(result: VerifyReceiptResult) -> UIAlertController {
        
        switch result {
        case.success(let receipt):
            return alertWithTitle(title: "Receipt Verified", message: "Receipt Verified Remotely")
        case .error(let error):
            switch error {
            case .noReceiptData:
                return alertWithTitle(title: "Receipt Verification", message: "No receipt data found, application will try to get a new one. Try Again.")
            default:
                return alertWithTitle(title: "Receipt verification", message: "Receipt Verification failed")
            }
        }
    }
    func alertForVerifySubscription(result: VerifySubscriptionResult) -> UIAlertController {
        switch result {
        case .purchased(let expiryDate):
            return alertWithTitle(title: "Product is Purchased", message: "Product is valid until \(expiryDate)")
        case .notPurchased:
            return alertWithTitle(title: "Not purchased", message: "This product has never been purchased")
        case .expired(let expiryDate):
            
            return alertWithTitle(title: "Product Expired", message: "Product is expired since \(expiryDate)")
        }
    }
    func alertForVerifyPurchase(result : VerifyPurchaseResult) -> UIAlertController {
        switch result {
        case .purchased:
            return alertWithTitle(title: "Product is Purchased", message: "Product will not expire")
        case .notPurchased:
            
            return alertWithTitle(title: "Product not purchased", message: "Product has never been purchased")
            
            
        }
        
    }

    
    func monitorRegionAtLocation(center: CLLocationCoordinate2D, identifier: String ) {
        // Make sure the app is authorized.
        if CLLocationManager.authorizationStatus() == .authorizedAlways {
            // Make sure region monitoring is supported.
            if CLLocationManager.isMonitoringAvailable(for: CLCircularRegion.self) {
                // Register the region.
                let maxDistance = 1000.0
                let region = CLCircularRegion(center: center,
                                              radius: maxDistance, identifier: identifier)
                region.notifyOnEntry = true
                region.notifyOnExit = false
            }
        }
    }
    
    
}

