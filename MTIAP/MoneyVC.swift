//
//  MoneyVC.swift
//  MTIAP
//
//  Created by Mohammmad Tahir on 07/11/17.
//  Copyright © 2017 Mohammmad Tahir. All rights reserved.
//

import UIKit

class MoneyVC: UITableViewController {

  override func viewDidLoad() {
    super.viewDidLoad()
    IAPService.shared.getProduct()
  }
  
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    switch indexPath.row {
    case 0: IAPService.shared.purchase(product: .consumable)
    case 1: IAPService.shared.purchase(product: .nonConsumable)
    case 2: IAPService.shared.purchase(product: .autoRenewingSubscription)
    case 3: IAPService.shared.purchase(product: .nonRenewingSubscription)
    default:IAPService.shared.restorePurchases()
    }
  }
}
