//
//  AccountVC.swift
//  Bank
//
//  Created by Joel Bollo on 11/07/2019.
//  Copyright © 2019 Joel Bollo. All rights reserved.
//

import UIKit
import CoreData

class AccountVC: UIViewController {
    @IBOutlet weak var accountId: UILabel!
    @IBOutlet weak var accountBalance: UILabel!
    @IBOutlet weak var accountDate: UILabel!
    @IBOutlet weak var moneyField: UITextField!
    @IBOutlet weak var withdrawMoney: UITextField!
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var selectedAccount = AccountModel()
    
    @IBAction func addMoney(_ sender: UIButton) {
        if moneyField.text != nil{
            selectedAccount.account_balance += Int(moneyField.text!)!
            accountBalance.text = String(selectedAccount.account_balance)
        }
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Account")
        request.returnsObjectsAsFaults = false
        
        do{
            print("---User Accounts---")
            let results = try context.fetch(request)
            
            if results.count>0{
                for result in results as! [NSManagedObject]{
                    if let name = result.value(forKey: "account_id") as? String{
                        if name == selectedAccount.account_id{
                            result.setValue(selectedAccount.account_balance, forKey: "account_balance")
                            try context.save()
                        }
                    }
                }
            }
            else{
                print("No results")
            }
        }
            
        catch{
            print("Couldn't fetch data")
        }
        
        moneyField.text = ""
        
    }
    
    @IBAction func withdrawButton(_ sender: UIButton) {
        let initialBalance = selectedAccount.account_balance
        
        if withdrawMoney.text != nil{
            selectedAccount.account_balance -= Int(withdrawMoney.text!)!
            accountBalance.text = String(selectedAccount.account_balance)
        }
            
        if selectedAccount.account_balance < 0 {
            
            selectedAccount.account_balance = initialBalance
            accountBalance.text = String(0)
                let alert = UIAlertController(title: "Not enough money", message: "", preferredStyle: .alert)
                let cancelAction = UIAlertAction(title: "Cancel", style: .default) { (actionCancel) in
                    alert.dismiss(animated: true, completion: nil)
                }
                alert.addAction(cancelAction)
                present(alert, animated: true, completion: nil)
            
        }
        
        
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Account")
        request.returnsObjectsAsFaults = false
        
        do{
            print("---User Accounts---")
            let results = try context.fetch(request)
            
            if results.count>0{
                for result in results as! [NSManagedObject]{
                    if let name = result.value(forKey: "account_id") as? String{
                        if name == selectedAccount.account_id{
                            result.setValue(selectedAccount.account_balance, forKey: "account_balance")
                            try context.save()
                        }
                    }
                }
            }
            else{
                print("No results")
            }
        }
            
        catch{
            print("Couldn't fetch data")
        }
        withdrawMoney.text = ""
    }
    
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
