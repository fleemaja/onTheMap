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
    
    @IBAction func openUdacitySignUpOnSafari(_ sender: UIButton) {
        if let requestUrl = URL(string: "https://www.udacity.com/account/auth#!/signup") {
            UIApplication.shared.open(requestUrl, options: [:], completionHandler: nil)
        }
    }
    
    @IBAction func authenticateCredentials(_ sender: UIButton) {
        
        // send email and pword to udacity api to authenticate
        let email = emailTextField.text!
        let password = passwordTextField.text!
        
        guard email.isEmpty == false && password.isEmpty == false else {
            showErrorAlert(message: "Email or password is empty")
            return
        }
        
        ApiClient.shared.authenticateUdacityCredentials(email: email, password: password) { data, response, error in
            if error != nil || data == nil { // Handle network error…
                DispatchQueue.main.async(execute: {
                    self.showErrorAlert(message: "Network or URL error")
                })
                return
            }
            let range = Range(5..<data!.count)
            let newData = data?.subdata(in: range)
            
            let json: Any!
            do {
                json = try JSONSerialization.jsonObject(with: newData!, options: .allowFragments)
            } catch {
                DispatchQueue.main.async(execute: {
                    self.showErrorAlert(message: "JSON Parsing Error")
                })
                return
            }
            
            let errorMessage = (json as AnyObject)["error"]!
            if errorMessage != nil {
                DispatchQueue.main.async(execute: {
                    self.showErrorAlert(message: "\(errorMessage ?? "")")
                })
                return
            }
            
            // successful login
            let session = (json as AnyObject)["account"]! as AnyObject
            self.getUser(id: (session as AnyObject)["key"]! as! String)
            DispatchQueue.main.async(execute: {
                self.performSegue(withIdentifier: "mapAndTable", sender: self)
            })
            
        }
        
    }
    
    func getUser(id: String) {
        ApiClient.shared.getUser(id: id) { data, response, error in
            if error != nil { // Handle error...
                DispatchQueue.main.async(execute: {
                    self.showErrorAlert(message: "Error getting user info")
                })
                return
            }
            let range = Range(5..<data!.count)
            let newData = data?.subdata(in: range)
            
            let json: Any!
            do {
                json = try JSONSerialization.jsonObject(with: newData!, options: .allowFragments)
            } catch {
                DispatchQueue.main.async(execute: {
                    self.showErrorAlert(message: "JSON Parsing Error")
                })
                return
            }
            
            guard let userData = (json as AnyObject)["user"]! as? [String : AnyObject] else {
                print("Can't find [user] in response")
                return
            }
            
            guard let firstName = userData["first_name"] as? String, let lastName = userData["last_name"] as? String else {
                print("Can't find [user]['first_name'] or [user]['last_name'] in response")
                return
            }
            
            let user = UdacityUser(dictionary: [
                "id": id as AnyObject,
                "firstName": firstName as AnyObject,
                "lastName": lastName as AnyObject,
                ])
            
            Model.shared.user = user
        }
    }

}

