//
//  RegisterVC.swift
//  Bank
//
//  Created by Joel Bollo on 11/07/2019.
//  Copyright © 2019 Joel Bollo. All rights reserved.
//

import UIKit
import CoreData

class RegisterVC: UIViewController {
    
    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var cardNo: UITextField!
    @IBOutlet weak var cardPin: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var repeatPassword: UITextField!
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var newUserEntity = User()
    var activeUser = UserModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewData()
        //resetAllRecords(in: "User")
        
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
    
    
    func insertUser(){
        
        if(checkPassword()){
             newUserEntity = User(context: self.context)
            
            newUserEntity.username = username.text
            newUserEntity.password = password.text
            newUserEntity.card_no = cardNo.text
            newUserEntity.card_pin = cardPin.text
            
            activeUser.username = username.text!
            activeUser.password = password.text!
            activeUser.card_no = cardNo.text!
            activeUser.card_pin = cardPin.text!
            
            print("Logged user is: \(newUserEntity.username!)")
            
            do{
                try context.save()
            }
            catch{
                print("User not inserted")
            }
            
        }

        
    }
    
    func viewData(){
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "User")
        request.returnsObjectsAsFaults = false
        
        do{
            print("---New print---")
            let results = try context.fetch(request)
            
            if results.count>0{
                for result in results as! [NSManagedObject]{
                    if let username = result.value(forKey: "username") as? String{
                        print(username)
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
    }
    
    func checkPassword() -> Bool{
        var flag = false
        
        if(password.text != repeatPassword.text){
            let alert = UIAlertController(title: "Password doesn't match!", message: "", preferredStyle: .alert)
            let cancelAction = UIAlertAction(title: "Cancel", style: .default) { (actionCancel) in
                alert.dismiss(animated: true, completion: nil)
            }
            alert.addAction(cancelAction)
            present(alert, animated: true, completion: nil)
            flag = false
        }
        else{
            flag = true
        }
        
        return flag
    }
    
    
    func checkDuplicateUser() -> Bool{
        
        var userExists = false
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "User")
        request.returnsObjectsAsFaults = false
        request.predicate = NSPredicate(format: "username = %@", username.text!)
        
        do{
            let results = try context.fetch(request)
            if results.count>0{
                let alert = UIAlertController(title: "Username already exists", message: "", preferredStyle: .alert)
                let cancelAction = UIAlertAction(title: "Cancel", style: .default) { (actionCancel) in
                    alert.dismiss(animated: true, completion: nil)
                }
                alert.addAction(cancelAction)
                present(alert, animated: true, completion: nil)
                userExists = true
                
            }
            else{
                print("No results")
            }
        }
            
        catch{
            print("Couldn't fetch data")
        }
        return userExists
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if(checkDuplicateUser() || !checkPassword()){
            return false
        }
        return true
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "registerToAccounts"){
            let nav = segue.destination as! NVC
            let destination = nav.viewControllers[0] as! AccountsVC
            destination.activeUser = activeUser
        }
    }
    
    @IBAction func registerButton(_ sender: UIButton) {
        if(!checkDuplicateUser()){
            insertUser()
            performSegue(withIdentifier: "registerToAccounts", sender: self)
            viewData()
        }
    }
    
    
}
