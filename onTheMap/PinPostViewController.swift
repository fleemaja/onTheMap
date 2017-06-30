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
    
    @IBAction func dismissModal(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func pinPostButtonPressed(_ sender: UIButton) {
        let currentButtonTitle = pinPostButton.currentTitle!
        
        switch currentButtonTitle {
            case "Search": forwardGeocode()
            case "Submit": break
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
            
            self.success()
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
    
    func success() {
        showErrorAlert(message: "Success! Found coordinates for \(location)")
        
        questionLabel.text = "What link do you want to post?"
        answerField.text = ""
        answerField.placeholder = "Enter Link Here"
        pinPostButton.setTitle("Submit", for: .normal)
        
        pin(coordinate: self.coordinate!)
    }

}
