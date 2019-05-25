//
//  IAPService.swift
//  MTIAP
//
//  Created by Mohammmad Tahir on 07/11/17.
//  Copyright © 2017 Mohammmad Tahir. All rights reserved.

import Foundation
import StoreKit

//MARK:- Product List 

public enum IAPProduct: String {
  case consumable = "com.apple.app.MyConsumable"
  case nonConsumable = "com.apple.app.MyNonConsumable"
  case autoRenewingSubscription = "com.apple.app.AutoRenewingSubscription"
  case nonRenewingSubscription = "com.apple.app.NonRenewingSubscription"
}

public class IAPService: NSObject {
  
  private override init() {}
  static let shared = IAPService()
  
  // MARK: Initial Setup
  
  var products =     [SKProduct]()
  let paymentQueue = SKPaymentQueue.default()
  
  
  // Get All Products 
  
  func getProduct() {
    
    let products: Set = [IAPProduct.autoRenewingSubscription.rawValue,
                         IAPProduct.consumable.rawValue,
                         IAPProduct.nonConsumable.rawValue,
                         IAPProduct.nonRenewingSubscription.rawValue]
    
    let request = SKProductsRequest(productIdentifiers: products)
    request.delegate = self
    request.start()
    paymentQueue.add(self)
  }
  
  
  // MARK:- Purchase Product
  
  func purchase(product: IAPProduct) -> Void {
    
    guard let productToPurchase = products.filter({$0.productIdentifier == product.rawValue}).first else {return}
    let payment = SKPayment(product: productToPurchase)
    paymentQueue.add(payment)
  }
  
  // MARK:- Restore Purchase
  
  func restorePurchases() -> Void {
    print("Restore Purchases")
    paymentQueue.restoreCompletedTransactions()
  }
  
  deinit {
    print(#function)
  }
}

// MARK:- SKProductsRequestDelegate

extension IAPService: SKProductsRequestDelegate {
  
  public func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
    
    for product in response.products {
      print(product.localizedDescription)
    }
  }
}

// MARK:- SKPaymentTransactionObserver

extension IAPService: SKPaymentTransactionObserver {
  
  public func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
    
    for transaction in transactions {
      print(transaction.transactionState.status(), transaction.payment.productIdentifier)
      switch transaction.transactionState {
      case .purchasing: break
      default: queue.finishTransaction(transaction)
      }
    }
  }
}

// MARK:- SKPayment State

extension SKPaymentTransactionState {
  
  func status() -> String {
    switch self {
    case .deferred:   return("deferred")
    case .failed:     return("failed")
    case .purchased:  return("purchased")
    case .purchasing: return("purchasing")
    case .restored:   return("restored")
    @unknown default:
      fatalError()
    }
  }
}








