//
//  LoginViewController.swift
//  onTheMap
//
//  Created by Drew Fleeman on 6/26/17.
//  Copyright © 2017 drew. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func openUdacitySignUpOnSafari(_ sender: UIButton) {
        if let requestUrl = URL(string: "https://www.udacity.com/account/auth#!/signup") {
            UIApplication.shared.open(requestUrl, options: [:], completionHandler: nil)
        }
    }
    
    @IBAction func authenticateCredentials(_ sender: UIButton) {
        
        // send email and pword to udacity api to authenticate
        
        // if successful: segue to map
        
        // if unsuccessful: alert view w/ either failed network or incorrect credentials notice
        
    }

}

