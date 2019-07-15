//
//  LoginVC.swift
//  Bank
//
//  Created by Joel Bollo on 11/07/2019.
//  Copyright © 2019 Joel Bollo. All rights reserved.
//

import UIKit
import CoreData

class LoginVC: UIViewController {
    
    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var password: UITextField!
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var activeUser = UserModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewData()
        
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
                        print("user: \(username)")
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
    
    func checkPassword() -> Bool {
        var passwordCorrect = false
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "User")
        request.returnsObjectsAsFaults = false
        request.predicate = NSPredicate(format: "username = %@", username.text!)
        
        do{
            print("---New print---")
            let results = try context.fetch(request)
            
            if results.count>0{
                for result in results as! [NSManagedObject]{
                    if let pass = result.value(forKey: "password") as? String{
                        if pass == password.text{
                            passwordCorrect = true
                        }
                        else{
                            let alert = UIAlertController(title: "Username or password incorrect", message: "", preferredStyle: .alert)
                            let cancelAction = UIAlertAction(title: "Cancel", style: .default) { (actionCancel) in
                                self.dismiss(animated: true, completion: nil)
                            }
                            alert.addAction(cancelAction)
                            present(alert, animated: true, completion: nil)
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
        
        return passwordCorrect
    }
    
    func getUser() -> Bool{
        var userLogged = false
        

        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "User")
        request.returnsObjectsAsFaults = false
        request.predicate = NSPredicate(format: "username = %@", username.text!)
        
        do{
            let results = try context.fetch(request)
            if results.count>0{
                for result in results as! [NSManagedObject]{
                    if(checkPassword()){
                        userLogged = true
                        activeUser.username = (result.value(forKey: "username") as! String)
                        activeUser.password = (result.value(forKey: "password") as! String)
                        activeUser.card_no = (result.value(forKey: "card_no") as! String)
                        activeUser.card_pin = (result.value(forKey: "card_pin") as! String)
                        print("Logged user is: \(activeUser.username)")
                        
                    }
                }
            }
            else{
                let alert = UIAlertController(title: "Username or password incorrect", message: "", preferredStyle: .alert)
                let cancelAction = UIAlertAction(title: "Cancel", style: .default) { (actionCancel) in
                    self.dismiss(animated: true, completion: nil)
                }
                alert.addAction(cancelAction)
                present(alert, animated: true, completion: nil)
                print("Wrong username")
            }
        }
            
        catch{
            print("Couldn't fetch data")
        }
    
        return userLogged
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if(!getUser()){
            return false
        }
        else{
            
        }

        return true
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "loginToAccounts"){
            let nav = segue.destination as! NVC
            let destination = nav.viewControllers[0] as! AccountsVC
            destination.activeUser = activeUser
        }

    }
    
    @IBAction func loginButton(_ sender: UIButton) {
        if(getUser()){
            performSegue(withIdentifier: "loginToAccounts", sender: self)
        }
    }
    
}
