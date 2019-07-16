//
//  ViewController.swift
//  Bank
//
//  Created by Joel Bollo on 11/07/2019.
//  Copyright © 2019 Joel Bollo. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var ButtonsView: UIView!
    var loginSelect = false;
    @IBOutlet weak var navItem: UINavigationItem!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.bringSubviewToFront(ButtonsView)
        
    }
    
    @IBAction func loginButton(_ sender: UIButton) {
    }
    
    @IBAction func registerButton(_ sender: UIButton) {
    }
    
}

