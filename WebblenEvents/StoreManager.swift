//
//  StoreManager.swift
//  WebblenEvents
//
//  Created by Mukai Selekwa on 9/12/17.
//  Copyright © 2017 Mukai Selekwa. All rights reserved.
//

import Foundation
import StoreKit


class StoreManager: NSObject {
    
    
    //Let's cearte a shared object so we can access our methods from anywhere in the app
    //Also this class should extend NSObject so we can make it as the delegate for our StoreKit
    
    /** This is a shared object of the StoreManager and you should only access their methods throgh the shared object */
    
    static var shared:StoreManager = {
        return StoreManager()
    }()
    
    
    
    //Let's create an array that will hold all our SKProducts receieved from the store after the request
    
    var productsFromStore = [SKProduct]()
    
    
    
    //Let's create an array to hold our productsID
    
    let purchasableProductsIds:Set<String> = ["com.webblen.events.5DollarEvent"] //For now we only have one product
    
    
    
    //Let's create our first call method
    
    func setup(){
        
        //In order to display the products for the user, the first thing we need to is to request our SKProduct from the store so we can show the product in our app and make it available for the user to purchase.
        
        
        //Let's load the products when we call the setup method
        
        //We should call our setup method when the app launches and the best place will be in AppDelegate
        
        self.requestProducts(ids: self.purchasableProductsIds)
        
        
        
        
        //We need to become the delegate for the SKPaymentTransaction
        
        SKPaymentQueue.default().add(self)
        
    }
    
    
    //Create a function load our products when the app launches and prepare them for us
    // 1- Request products by product id from the store
    func requestProducts(ids:Set<String>){
        
        //Before we make any payment we need to check if the user can make payments
        
        if SKPaymentQueue.canMakePayments(){
            
            //Create the request which we will send to Store
            //Note that we can request more than one preoduct at once
            let request = SKProductsRequest(productIdentifiers: ids)
            
            //Now we need to become the delegate for the Request so we can get responses
            request.delegate = self
            request.start()
            
            
        }else{
            
            print("User can't make payments from this account")
        }
        
    }
    
}


//Now in order to receive the calls you need to implement the delegate methods of SKProductsRequestDelegate
extension StoreManager:SKProductsRequestDelegate{
    
    
    //This method will be called when ever the request finished processing on the Store
    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        
        //In the response there are the products SKProduct we requested in the request
        
        let products = response.products
        
        if products.count > 0{
            
            //Loop through each product
            for product in products{
                
                //And add it to our array for later use
                self.productsFromStore.append(product)
            }
            
            
        }else{
            
            print("Products now found")
        }
        
        
        //Let's post a notification when our products have loaded so we can load them inside our tabelview
        NotificationCenter.default.post(name: NSNotification.Name.init("SKProductsHaveLoaded"), object: nil)
        
        
        
        
        //We can also check to see if we have sent wrong products ids
        
        let invalidProductsIDs = response.invalidProductIdentifiers
        
        for id in invalidProductsIDs{
            
            print("Wrong product id: ",id)
        }
    }
    
    func request(_ request: SKRequest, didFailWithError error: Error) {
        
        print("error requesting products from the store",error.localizedDescription)
        
    }
    
    
}



//We also need to implement the delegate methods for the SKPaymentTransactionObserver

extension StoreManager:SKPaymentTransactionObserver{
    
    //Two methods we will be interested in:
    
    
    //This mehtod will be called whenever there is an update from the store about a product or subscription etc...
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        
        //As you can see there are transactions and we need to loop through them in order to see what each transaction has for status
        
        for transaction in transactions{
            
            
            
            switch transaction.transactionState {
            case .purchased:
                self.purchaseCompleted(transaction: transaction)
            case .failed:
                self.purchaseFailed(transaction: transaction)
            case .restored:
                self.purchaseRestored(transaction: transaction)
            case .purchasing,.deferred:
                print("Pending")
                
            }
        }
        
        
        
    }
    
    //We will use it in future
    func paymentQueueRestoreCompletedTransactionsFinished(_ queue: SKPaymentQueue) {
        
    }
    
    //Let's implement different function for each state
    
    func purchaseCompleted(transaction:SKPaymentTransaction){
        
        self.unlockContentForTransaction(trans: transaction)
        
        //Only after we have unlocked the content for the user
        SKPaymentQueue.default().finishTransaction(transaction)
        
    }
    
    func purchaseFailed(transaction:SKPaymentTransaction){
        
        //In case of failed we need to check why it failed
        
        if let error = transaction.error as? SKError{
            
            switch error {
            case SKError.clientInvalid:
                print("User not allowed to make a payment request")
            case SKError.unknown:
                print("Unkown error while proccessing SKPayment")
            case SKError.paymentCancelled:
                print("User cancaled the payment request (Cancel)")
                
            case SKError.paymentInvalid:
                print("The purchase id was not valid")
                
            case SKError.paymentNotAllowed:
                print("This device is not allowed to make payments")
                
            default:
                break
            }
            
        }
        
        //Only after we have unlocked the content for the user
        SKPaymentQueue.default().finishTransaction(transaction)
        
    }
    
    func purchaseRestored(transaction:SKPaymentTransaction){
        
        self.unlockContentForTransaction(trans: transaction)
        
        //Only after we have unlocked the content for the user
        SKPaymentQueue.default().finishTransaction(transaction)
    }
    
    
    
    //This function will unlock whatever the transaction have for product ID
    
    func unlockContentForTransaction(trans:SKPaymentTransaction){
        
        print("Should unlock the content for product ID",trans.payment.productIdentifier)
    }
}
