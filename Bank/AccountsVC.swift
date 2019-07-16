//
//  AccountsVC.swift
//  Bank
//
//  Created by Joel Bollo on 11/07/2019.
//  Copyright © 2019 Joel Bollo. All rights reserved.
//

import UIKit
import CoreData

class AccountsVC: UITableViewController {
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var accounts = [Account]()
    let currentDate = Date()
    var activeUser = UserModel()
    var selectedAccount = AccountModel()
    
    
    
    @IBAction func addAccount(_ sender: Any) {
        var textField = UITextField()
        let newAccount = Account(context: self.context)
        let alert = UIAlertController(title: "Add New Account", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Account", style: .default) { (action) in
            let name = textField.text
            self.insertAccount(name: name!, time: self.currentDate)
            self.tableView.reloadData()

        }
        
        let actionCancel = UIAlertAction(title: "Cancel", style: .default) { (actionCancel) in
            alert.dismiss(animated: true, completion: nil)
            self.context.delete(newAccount)
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Account Name"
            textField = alertTextField
            action.isEnabled = false
            
            let txt = textField.text
            if txt?.count != nil{
                action.isEnabled = true
            }
        }
        
        alert.addAction(action)
        alert.addAction(actionCancel)
        
        present(alert, animated: true, completion: nil)
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        //resetAllRecords(in: "Account")
        loadAccounts()

    }

    // MARK: - Table view
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == UITableViewCell.EditingStyle.delete{
            let alert = UIAlertController(title: "Are you sure?", message: "", preferredStyle: .alert)
            let actionYes = UIAlertAction(title: "Yes", style: .default) { (actionYes) in
                self.context.delete(self.accounts[indexPath.row])
                self.accounts.remove(at: indexPath.row)
                self.tableView.deleteRows(at: [indexPath], with: UITableView.RowAnimation.automatic)
                self.saveAccounts()
            }
            
            let actionNo = UIAlertAction(title: "No", style: .default) { (actionNo) in
                alert.dismiss(animated: true, completion: nil)
                self.tableView.reloadData()
            }
            
            alert.addAction(actionYes)
            alert.addAction(actionNo)
            
            present(alert, animated: true, completion:nil)
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "toAccount", sender: self)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return accounts.count
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.tableView.reloadData()
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "accountCell", for: indexPath) as! Cell
        let dateformatter = DateFormatter()
        dateformatter.dateFormat = "dd-MMM-yyyy HH:mm:ss"
        let time = dateformatter.string(from: accounts[indexPath.row].date_created ?? currentDate)
        cell.accountID?.text = accounts[indexPath.row].account_id
        cell.accountDate?.text = time
        
        
        return cell
    }
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        
        if let destinationVC = segue.destination as? AccountVC{
            if let indexPath = tableView.indexPathForSelectedRow{
                if segue.identifier == "toAccount"{
                    
                    selectedAccount.account_balance = Int(accounts[indexPath.row].account_balance)
                    selectedAccount.account_id = accounts[indexPath.row].account_id!
                    selectedAccount.date_created = accounts[indexPath.row].date_created!
                    destinationVC.selectedAccount = selectedAccount
                    
                }
            }
        }
    
        else{
            if segue.identifier == "logout"{
                let logout = segue.destination as! ViewController
                logout.navigationItem.hidesBackButton = true
            }
        }

    }
    
    
    // MARK: Data
    
    func printAccounts(){
        print("ARRAY:")
        for account in accounts{
            print("-\(account.account_id!)")
        }
        print("Count: \(accounts.count)")
    }
    
    func loadAccounts(){
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Account")
        request.returnsObjectsAsFaults = false
        
        do{
            print("---User Accounts---")
            let results = try context.fetch(request)
            
            if results.count>0{
                for result in results as! [NSManagedObject]{
                    if let username = result.value(forKey: "account_owner") as? String{
                        if username == activeUser.username{
                            accounts.append(result as! Account)
                            print(result.value(forKey: "account_id")!)
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
        
        tableView.reloadData()
    }
    
    func insertAccount(name: String, time: Date){
            let newAccount = NSEntityDescription.insertNewObject(forEntityName: "Account", into: context)
        
            newAccount.setValue(activeUser.username, forKey: "account_owner")
            newAccount.setValue(0, forKey: "account_balance")
            newAccount.setValue(name, forKey: "account_id")
            newAccount.setValue(time, forKey: "date_created")
            accounts.append(newAccount as! Account)

            do{
                try context.save()
            }
            catch{
                print("Account not inserted")
            }
        
    }
    
    
    
    func saveAccounts(){
        do {
            try context.save()
        }
        catch {
            print("Error saving, \(error)")
        }
        
    }
 
    
    
    func resetAllRecords(in entity : String){
        
        let context = ( UIApplication.shared.delegate as! AppDelegate ).persistentContainer.viewContext
        let deleteFetch = NSFetchRequest<NSFetchRequestResult>(entityName: entity)
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: deleteFetch)
        do
        {
            try context.execute(deleteRequest)
            try context.save()
        }
        catch
        {
            print ("There was an error")
        }
        
    }

}
