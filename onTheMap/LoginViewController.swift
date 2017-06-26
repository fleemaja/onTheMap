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
        let email = emailTextField.text!
        let password = passwordTextField.text!
        
        guard email.isEmpty == false && password.isEmpty == false else {
            showErrorAlert(message: "Email or password is empty")
            return
        }
        
        let request = NSMutableURLRequest(url: URL(string: "https://www.udacity.com/api/session")!)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = "{\"udacity\": {\"username\": \"\(email)\", \"password\": \"\(password)\"}}".data(using: String.Encoding.utf8)
        let session = URLSession.shared
        let task = session.dataTask(with: request as URLRequest) { data, response, error in
            if error != nil { // Handle network error…
                DispatchQueue.main.async(execute: {
                    self.showErrorAlert(message: "Network or URL error")
                })
                return
            }
            let range = Range(5..<data!.count)
            let newData = data?.subdata(in: range) /* subset response data! */
            
            let json: Any!
            do {
                json = try JSONSerialization.jsonObject(with: newData!, options: .allowFragments)
            } catch {
                DispatchQueue.main.async(execute: {
                    self.showErrorAlert(message: "JSON Parsing Error")
                })
                return
            }
            
//            print(NSString(data: newData!, encoding: String.Encoding.utf8.rawValue)!)
//            DispatchQueue.main.async(execute: {
//                self.showErrorAlert(message: NSString(data: newData!, encoding: String.Encoding.utf8.rawValue)! as String)
//            })
            let errorMessage = (json as AnyObject)["error"]!
            if errorMessage != nil {
                DispatchQueue.main.async(execute: {
                    self.showErrorAlert(message: "\(errorMessage ?? "")")
                })
                return
            }
            
            DispatchQueue.main.async(execute: {
                self.performSegue(withIdentifier: "mapAndTable", sender: self)
            })
            
        }
        task.resume()
        
    }

}

