//
//  TableViewController.swift
//  onTheMap
//
//  Created by Drew Fleeman on 6/26/17.
//  Copyright © 2017 drew. All rights reserved.
//

import UIKit

class TableViewController: UITableViewController {
    
    var students: [StudentInformation]! {
        return Model.shared.students
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
        ApiClient.shared.logOut() { data, response, error in
            if error != nil { // Handle error…
                self.showErrorAlert(message: "Could not log out. Network Error")
                return
            }
            
            DispatchQueue.main.async(execute: {
                self.dismiss(animated: true, completion: nil)
            })
        }
    }
    
    func fetchStudents() {
        ApiClient.shared.fetchStudents() { data, response, error in
            if error != nil { // Handle error...
                DispatchQueue.main.async(execute: {
                    self.showErrorAlert(message: "Failed to fetch links. Network error")
                })
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
            Model.shared.students = [StudentInformation]()
            
            for result in results {
                let student = StudentInformation(dictionary: result)
                Model.shared.students.append(student)
            }
            
            DispatchQueue.main.async(execute: {
                self.refresh()
            })
            
        }
    }
    
    
}
