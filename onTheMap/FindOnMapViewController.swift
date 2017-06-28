//
//  FindOnMapViewController.swift
//  onTheMap
//
//  Created by Drew Fleeman on 6/28/17.
//  Copyright © 2017 drew. All rights reserved.
//

import UIKit
import MapKit

class FindOnMapViewController: UIViewController {
    
    var location: String = ""
    var coordinate: CLLocationCoordinate2D?
    
    @IBOutlet weak var locationTextField: UITextField!

    @IBAction func dismissModal(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func forwardGeocode(_ sender: UIButton) {
        
        guard let location = locationTextField.text, location != "" else {
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
            
            self.showErrorAlert(message: "Success! Found coordinates for \(location)")
        }
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
