//
//  WebblenIAPService.swift
//  WebblenEvents
//
//  Created by Mukai Selekwa on 12/10/17.
//  Copyright © 2017 Mukai Selekwa. All rights reserved.
//

import Foundation
import StoreKit

class IAPService: NSObject {
    
    
    private override init() {}
    static let shared = IAPService()
    
    var products = [SKProduct]()
    let paymentQueue = SKPaymentQueue.default()
    
    func getProducts(){
        
        let products: Set = [IAPProducts.event250.rawValue,
                             IAPProducts.event375.rawValue,
                             IAPProducts.event575.rawValue,
                             IAPProducts.event975.rawValue,
                             IAPProducts.event1975.rawValue,
                             IAPProducts.event3075.rawValue,
                             IAPProducts.event5975.rawValue,
                             IAPProducts.event8475.rawValue,
                             IAPProducts.event10000.rawValue]
        
        let request = SKProductsRequest(productIdentifiers: products)
        request.delegate = self
        request.start()
        paymentQueue.add(self)
    }
    
    func purchase(product: IAPProducts) {
        guard let productToPurchase = products.filter({ $0.productIdentifier == product.rawValue }).first else { return }
        let payment = SKPayment(product: productToPurchase)
        paymentQueue.add(payment)
    }
    
    func restorePurchases() {
        print("restore purchases")
        paymentQueue.restoreCompletedTransactions()
    }
    
}

extension IAPService: SKProductsRequestDelegate {
    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        products = response.products
        for product in response.products {
            print(product.localizedTitle)
        }
    }
}

extension IAPService: SKPaymentTransactionObserver {
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        for transaction in transactions {
            print(transaction.transactionState.status(), transaction.payment.productIdentifier)
            
            switch transaction.transactionState {
            case .purchasing: break
            default: queue.finishTransaction(transaction)
            }
        }
    }
}

extension SKPaymentTransactionState {
    func status() -> String {
        switch self {
        case .deferred: return "deferred"
        case .failed: return "failed"
        case .purchased: return "purchased"
        case .purchasing: return "purchasing"
        case .restored: return "restored"
        }
    }
}
