//
//  TableViewController.swift
//  onTheMap
//
//  Created by Drew Fleeman on 6/26/17.
//  Copyright © 2017 drew. All rights reserved.
//

import UIKit

class TableViewController: UITableViewController {
    
    var students: [Student]! {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.students
    }

    @IBAction func refreshTable(_ sender: UIBarButtonItem) {
        fetchStudents()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        fetchStudents()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.students.count
    }
    
    /*
     * Return one cell to the table
     */
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let student = students[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "StudentCell")!
        
//        cell.imageView?.image = UIImage(named: "icon-pin")
        cell.textLabel?.text = student.fullName
        cell.detailTextLabel?.text = student.mediaUrl
        
        return cell
    }
    
    func refresh() {
        tableView.reloadData()
    }
    
    func fetchStudents() {
        let request = NSMutableURLRequest(url: URL(string: "https://parse.udacity.com/parse/classes/StudentLocation?limit=100")!)
        request.addValue("QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr", forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue("QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY", forHTTPHeaderField: "X-Parse-REST-API-Key")
        let session = URLSession.shared
        let task = session.dataTask(with: request as URLRequest) { data, response, error in
            if error != nil { // Handle error...
                return
            }
            
            let results: [[String: AnyObject]]
            do {
                let json = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as? [String:Any]
                results = json?["results"] as! [[String : AnyObject]]
            } catch {
                print("JSON converting error")
                return
            }
            
//            clear students array
            (UIApplication.shared.delegate as! AppDelegate).students = [Student]()
            
            for result in results {
                let student = Student(dictionary: result)
                (UIApplication.shared.delegate as! AppDelegate).students.append(student)
            }
            DispatchQueue.main.async(execute: {
//                load up table of data
                self.refresh()
            })
        }
        task.resume()
    }
    
    /*
     * Try to open user's link when cell is tapped
     */
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let student = students[indexPath.row]
        if student.mediaUrl != "" {
            let url =  URL(string: student.mediaUrl)!
            UIApplication.shared.open(url, options: [:])
        }
    }
    
    @IBAction func logOut(_ sender: UIButton) {
        let request = NSMutableURLRequest(url: URL(string: "https://www.udacity.com/api/session")!)
        request.httpMethod = "DELETE"
        var xsrfCookie: HTTPCookie? = nil
        let sharedCookieStorage = HTTPCookieStorage.shared
        for cookie in sharedCookieStorage.cookies! {
            if cookie.name == "XSRF-TOKEN" { xsrfCookie = cookie }
        }
        if let xsrfCookie = xsrfCookie {
            request.setValue(xsrfCookie.value, forHTTPHeaderField: "X-XSRF-TOKEN")
        }
        let session = URLSession.shared
        let task = session.dataTask(with: request as URLRequest) { data, response, error in
            if error != nil { // Handle error…
                return
            }
            let range = Range(5..<data!.count)
            let newData = data?.subdata(in: range) /* subset response data! */
            print(NSString(data: newData!, encoding: String.Encoding.utf8.rawValue)!)
            DispatchQueue.main.async(execute: {
               self.dismiss(animated: true, completion: nil)
            })
        }
        task.resume()
    }
    

}
