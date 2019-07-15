//
//  AccountVC.swift
//  Bank
//
//  Created by Joel Bollo on 11/07/2019.
//  Copyright © 2019 Joel Bollo. All rights reserved.
//

import UIKit

class AccountVC: UIViewController {
    @IBOutlet weak var accountId: UILabel!
    @IBOutlet weak var accountBalance: UILabel!
    @IBOutlet weak var accountDate: UILabel!
    
    var selectedAccount = AccountModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        accountId.text = selectedAccount.account_id
        accountBalance.text = String(selectedAccount.account_balance)
        
        let dateformatter = DateFormatter()
        dateformatter.dateFormat = "dd-MMM-yyyy HH:mm:ss"
        let time = dateformatter.string(from: selectedAccount.date_created)
        accountDate.text = time
        
    }
}
