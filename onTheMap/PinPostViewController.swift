//
//  PinPostViewController.swift
//  onTheMap
//
//  Created by Drew Fleeman on 6/28/17.
//  Copyright © 2017 drew. All rights reserved.
//

import UIKit
import MapKit

class PinPostViewController: UIViewController {
    
    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var answerField: UITextField!
    @IBOutlet weak var pinPostButton: UIButton!
    @IBOutlet weak var mapView: MKMapView!
    
    var location: String = ""
    var coordinate: CLLocationCoordinate2D?
    
    var user: UdacityUser? {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.user
    }
    
    @IBAction func dismissModal(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func pinPostButtonPressed(_ sender: UIButton) {
        let currentButtonTitle = pinPostButton.currentTitle!
        
        switch currentButtonTitle {
            case "Search": forwardGeocode()
            case "Submit": postPin()
            default: break
        }
    }
    
    func forwardGeocode() {
        
        guard let location = answerField.text, location != "" else {
            showErrorAlert(message: "Please enter a location to find on the map")
            return
        }
        
        CLGeocoder().geocodeAddressString(location) { (placemark, error) in
            
            guard error == nil else {
                self.showErrorAlert(message: "Could not find location")
                return
            }
            
            self.location = location
            self.coordinate = placemark!.first!.location!.coordinate
            
            self.foundLocationSuccess()
        }
        
    }
    
    /*
     * Create "pin" on the map with coordinates (preview the mark on map)
     */
    private func pin(coordinate: CLLocationCoordinate2D) {
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinate
        annotation.title = location
        
        let region = MKCoordinateRegionMake(coordinate, MKCoordinateSpanMake(0.01, 0.01))
        
        DispatchQueue.main.async(execute: {
            self.mapView.addAnnotation(annotation)
            self.mapView.setRegion(region, animated: true)
            self.mapView.regionThatFits(region)
        })
    }
    
    func foundLocationSuccess() {
        
        questionLabel.text = "What link do you want to post?"
        answerField.text = ""
        answerField.placeholder = "Enter Link Here"
        pinPostButton.setTitle("Submit", for: .normal)
        
        pin(coordinate: self.coordinate!)
        
    }
    
    func postPin() {
        
        guard let link = answerField.text, link != "" else {
            showErrorAlert(message: "Please enter a link to submit")
            return
        }
        
        let request = NSMutableURLRequest(url: URL(string: "https://parse.udacity.com/parse/classes/StudentLocation")!)
        request.httpMethod = "POST"
        request.addValue("QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr", forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue("QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY", forHTTPHeaderField: "X-Parse-REST-API-Key")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = "{\"uniqueKey\": \"\(user!.id)\", \"firstName\": \"\(user!.firstName)\", \"lastName\": \"\(user!.lastName)\",\"mapString\": \"\(self.location)\", \"mediaURL\": \"\(link)\",\"latitude\": \(Double(self.coordinate!.latitude)), \"longitude\": \(Double(self.coordinate!.longitude))}".data(using: String.Encoding.utf8)
        let session = URLSession.shared
        let task = session.dataTask(with: request as URLRequest) { data, response, error in
            if error != nil { // Handle error…
                return
            }
            
            DispatchQueue.main.async(execute: {
                self.dismiss(animated: true, completion: nil)
            })
        }
        task.resume()
    }

}
