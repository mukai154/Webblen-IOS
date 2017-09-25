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
    @IBOutlet weak var promoCode: UITextField!
    
//Variables
    var eventTitle = "title"
    var eventDateTime = "date & time"
    var eventRadius = "radius"
    var eventImage : UIImage?
    var eventKey = "key"
    var eventUID = "uid"
    var paid = "false"
    var eventCost = 0
    
    var dataBaseRef: FIRDatabaseReference!
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
        dataBaseRef = FIRDatabase.database().reference()
        self.currentUser = FIRAuth.auth()?.currentUser
        
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
        
        if (promoCode.text == "Spitfire12"){
            self.dataBaseRef.child("Event").child(self.eventKey).child("paid").setValue("true")
            
            print("Admin Code Used")
            
            performSegue(withIdentifier: "eventPurchasedSegue", sender: nil)
        }
        else if (promoCode.text == "webblenfargo"){
            
            self.dataBaseRef.child("EventSupport").child(self.eventKey).child("paid").setValue("true")
            
            promoCode.text = "Support Code Sent"

            purchase(purchase: event5)
            
        }
        else {
        print("attempting to get purchase")
        purchase(purchase: event5)
        }

    }
    
    
    
    //Store Kit Functions
    func getInfo(purchase : RegisteredPurchase) {
        
        NetworkActivityIndicatorManager.NetworkOperationStarted()
        SwiftyStoreKit.retrieveProductsInfo([bundleID + "." + purchase.rawValue], completion: {
            result in
            NetworkActivityIndicatorManager.networkOperationFinished()
            
            self.showAlert(alert: self.alertForProductRetrievalInfo(result: result))
        })
        
    }
    
    func purchase(purchase : RegisteredPurchase) {
        
        NetworkActivityIndicatorManager.NetworkOperationStarted()
        SwiftyStoreKit.purchaseProduct(bundleID + "." + purchase.rawValue, completion: {
            result in
            NetworkActivityIndicatorManager.networkOperationFinished()
            
            if case .success(let product) = result {
                
                if product.productId == self.bundleID + "." + "notifyFive" {
                    
                    self.dataBaseRef.child("Event").child(self.eventKey).child("paid").setValue("true")
                    
                    print("success")
                    
                    self.performSegue(withIdentifier: "eventPurchasedSegue", sender: nil)
                    
                }
                
                if product.needsFinishTransaction {
                    SwiftyStoreKit.finishTransaction(product.transaction)
                }
                self.showAlert(alert: self.alertForPurchaseResult(result: result))
                
                
            }
        })
        
    }
    
    func restorePurchases() {
        
        NetworkActivityIndicatorManager.NetworkOperationStarted()
        SwiftyStoreKit.restorePurchases(atomically: true,  completion: {
            result in
            NetworkActivityIndicatorManager.networkOperationFinished()
            
            for product in result.restoredProducts {
                if product.needsFinishTransaction {
                    SwiftyStoreKit.finishTransaction(product.transaction)
                }
            }
            self.showAlert(alert: self.alertForRestorePurchases(result: result))
            
            
        })
        
    }
    
    func verifyReceipt() {
        NetworkActivityIndicatorManager.NetworkOperationStarted()
        SwiftyStoreKit.verifyReceipt(password: sharedSecret, completion: {
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
        SwiftyStoreKit.verifyReceipt(password: sharedSecret, completion: {
            result in
            NetworkActivityIndicatorManager.networkOperationFinished()

                    
                    switch result{
                    case .success(let receipt):
                        
                        let productID = self.bundleID + "." + product.rawValue
        
                        let purchaseResult = SwiftyStoreKit.verifyPurchase(productId: productID, inReceipt: receipt)
                        self.showAlert(alert: self.alertForVerifyPurchase(result: purchaseResult))
                            
                        
                    case .error(let error):
                        self.showAlert(alert: self.alertForVerifyReceipt(result: result))
                        if case .noReceiptData = error {
                            self.refreshReceipt()
                            
                        }
                        
                    }
            
        })
    }
    
    func refreshReceipt() {
        SwiftyStoreKit.refreshReceipt( completion: {
            result in
            
            self.showAlert(alert: self.alertForRefreshRecepit(result: result))
        })
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
    func alertForPurchaseResult(result : PurchaseResult) -> UIAlertController {
        switch result {
        case .success(let product):
            print("Purchase Succesful: \(product.productId)")
            
            return alertWithTitle(title: "Thank You", message: "Purchase completed")
        case .error(let error):
            print("Purchase Failed: \(error)")
            switch error {
            case .failed(let error):
                if (error as NSError).domain == SKErrorDomain {
                    return alertWithTitle(title: "Purchase Failed", message: "Check your internet connection or try again later.")
                }
                else {
                    return alertWithTitle(title: "Purchase Failed", message: "Unknown Error. Please Contact Support")
                }
            case.invalidProductId(let productID):
                return alertWithTitle(title: "Purchase Failed", message: "\(productID) is not a valid product identifier")
            case .noProductIdentifier:
                return alertWithTitle(title: "Purchase Failed", message: "Product not found")
            case .paymentNotAllowed:
                return alertWithTitle(title: "Purchase Failed", message: "You are not allowed to make payments")
                
            }
        }
    }
    func alertForRestorePurchases(result : RestoreResults) -> UIAlertController {
        if result.restoreFailedProducts.count > 0 {
            print("Restore Failed: \(result.restoreFailedProducts)")
            return alertWithTitle(title: "Restore Failed", message: "Unknown Error. Please Contact Support")
        }
        else if result.restoredProducts.count > 0 {
            return alertWithTitle(title: "Purchases Restored", message: "All purchases have been restored.")
            
        }
        else {
            return alertWithTitle(title: "Nothing To Restore", message: "No previous purchases were made.")
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
    func alertForRefreshRecepit(result : RefreshReceiptResult) -> UIAlertController {
        
        switch result {
        case .success(let receiptData):
            return alertWithTitle(title: "Receipt Refreshed", message: "Receipt refreshed successfully")
        case .error(let error):
            return alertWithTitle(title: "Receipt refresh failed", message: "Receipt refresh failed")
        }
    }
    
}

