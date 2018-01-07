//
//  confirmPostViewController.swift
//  WebblenEvents
//
//  Created by Mukai Selekwa on 8/10/17.
//  Copyright © 2017 Mukai Selekwa. All rights reserved.
//

import UIKit
import Firebase
import CoreLocation
import NVActivityIndicatorView
import SwiftyStoreKit



class confirmPostViewController: UIViewController {

//Outlets
    @IBOutlet weak var ePhoto: UIImageView!
    @IBOutlet weak var eTitle: UILabel!
    @IBOutlet weak var eAddress: UILabel!
    @IBOutlet weak var eDateTime: UILabel!
    @IBOutlet weak var eNotifyRadius: UILabel!
    @IBOutlet weak var eTotalCost: UILabel!
    @IBOutlet weak var eventCategories: UILabel!
    
    
//Variables
    var eventCreator : String?
    var eventTitle = "title"
    var eventDateTime = "date & time"
    var eventRadius = 0
    var eventImage : UIImage?
    var eventKey = "key"
    var eventUID = "uid"
    var paid = false
    var lat = 0.0
    var lon = 0.0
    var eventCost = 0
    var eventChosenCategories : [String] = []
    var didPurchaseEvent = false
    
    var products = ["com.webblen.events.notify250",
                    "com.webblen.events.notify375",
                    "com.webblen.events.notify575",
                    "com.webblen.events.notify975",
                    "com.webblen.events.notify1975",
                    "com.webblen.events.notify3075",
                    "com.webblen.events.notify5975",
                    "com.webblen.events.notify8475",
                    "com.webblen.events.notify10000"
                    ]
    var sharedSecret = "3fd70aaa6f914c799e7930abd16e0523"
    
    var dataBase = Firestore.firestore()
    var currentUser: AnyObject?
    
    var loadingView = NVActivityIndicatorView(frame: CGRect(x: (100), y: (100), width: 125, height: 125), type: .ballRotateChase, color: UIColor(red: 158/255, green: 158/255, blue: 158/255, alpha: 1.0), padding: 0)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let xAxis = self.view.center.x
        let yAxis = self.view.center.y
        
        let frame = CGRect(x: (xAxis-147), y: (yAxis-135), width: 300, height: 300)
        loadingView = NVActivityIndicatorView(frame: frame, type: .ballRotateChase, color: UIColor(red: 158/255, green: 158/255, blue: 158/255, alpha: 0.7), padding: 0)
        self.view.addSubview(loadingView)
        loadingView.startAnimating()
        
        for product in products {
            retrieveProducts(product: product)
        }

        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
        
        //Uncomment the line below if you want the tap not not interfere and cancel other interactions.
        
        tap.cancelsTouchesInView = true
        view.addGestureRecognizer(tap)
        
        //Database Ref
        self.currentUser = Auth.auth().currentUser
        
        let eventRef = dataBase.collection("events").document(eventKey)
        eventRef.getDocument(completion: {(event, error) in
            if let event = event {
                self.eventChosenCategories = event.data()["categories"] as! [String]
                self.eventCategories.text = "Categories: " + self.eventChosenCategories.joined(separator: ", ")
                self.ePhoto.image = UIImage(named: self.eventChosenCategories.first!)
                self.eTitle.text = event.data()["title"] as! String
                self.eAddress.text = event.data()["address"] as! String
                self.eventCreator = event.data()["author"] as! String
                let eDate = event.data()["date"] as! String
                let eTime = event.data()["time"] as! String
                self.eDateTime.text = eDate + " | " + eTime
                self.eventRadius = event.data()["radius"] as! Int
                if self.eventRadius < 275 {
                    self.eTotalCost.text = "Event Total: $2.99"
                }
                else if self.eventRadius < 400 {
                    self.eTotalCost.text = "Event Total: $4.99"
                }
                else if self.eventRadius < 600 {
                     self.eTotalCost.text = "Event Total: $9.99"
                }
                else if self.eventRadius < 1000 {
                    self.eTotalCost.text = "Event Total: $14.99"
                }
                else if self.eventRadius < 2000 {
                     self.eTotalCost.text = "Event Total: $19.99"
                }
                else if self.eventRadius < 3100 {
                     self.eTotalCost.text = "Event Total: $24.99"
                }
                else if self.eventRadius < 6000 {
                     self.eTotalCost.text = "Event Total: $26.99"
                }
                else if self.eventRadius < 8500 {
                     self.eTotalCost.text = "Event Total: $29.99"
                }
                else if self.eventRadius <= 10000 {
                     self.eTotalCost.text = "Event Total: $34.99"
                }
                self.eNotifyRadius.text = "Notify those within " + String(self.eventRadius) + " meters"
                self.paid = event.data()["paid"] as! Bool
                self.loadingView.stopAnimating()
            }
            else {
                print("doc does not exist")
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
        
        loadingView.startAnimating()
        
        if (self.eventCreator == "Webblen"){
            didPurchaseEvent = true
            dataBase.collection("events").document(eventKey).updateData([
                "verified": true,
                "paid": true
            ]) { err in
                if let err = err {
                    print("Error updating document: \(err)")
                } else {
                    self.loadingView.stopAnimating()
                    self.performSegue(withIdentifier: "homeSegue", sender: nil)
                }
            }
        }
        else{
            if eventRadius < 275 {
                purchaseProduct(product: self.products[0])
            }
            else if eventRadius < 400 {
                purchaseProduct(product: self.products[1])            }
            else if eventRadius < 600 {
                purchaseProduct(product: self.products[2])
            }
            else if eventRadius < 1000 {
                purchaseProduct(product: self.products[3])
            }
            else if eventRadius < 2000 {
                purchaseProduct(product: self.products[4])
            }
            else if eventRadius < 3100 {
                purchaseProduct(product: self.products[5])
            }
            else if eventRadius < 6000 {
                purchaseProduct(product: self.products[6])
            }
            else if eventRadius < 8500 {
                purchaseProduct(product: self.products[7])
            }
            else if eventRadius <= 10000 {
                purchaseProduct(product: self.products[8])
            }
        }
    }
    
    @IBAction func didPressCancel(_ sender: Any) {
        performSegue(withIdentifier: "homeSegue", sender: nil)
    }
    
    
    func eventPurchased(){
        dataBase.collection("events").document(eventKey).updateData([
            "verified": true,
            "paid": true
        ]) { err in
            if let err = err {
                print("Error updating document: \(err)")
            } else {
                self.loadingView.stopAnimating()
                self.performSegue(withIdentifier: "homeSegue", sender: nil)
            }
        }
    }
    
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
}


