//
//  MapViewController.swift
//  onTheMap
//
//  Created by Drew Fleeman on 6/26/17.
//  Copyright © 2017 drew. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController {

    @IBOutlet weak var mapView: MKMapView!
    
    
    @IBAction func refreshMap(_ sender: UIBarButtonItem) {
        mapView.removeAnnotations(mapView.annotations)
        fetchStudents()
    }
    
    var students: [StudentInformation]! {
        return Model.shared.students
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        mapView.removeAnnotations(mapView.annotations)
        fetchStudents()
    }
    
    func refresh() {
        self.addAnnotations()
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
    
    
    private func addAnnotations() {
        var annotations = [MKPointAnnotation]()
        
        for student in students {
            
            let lat = CLLocationDegrees(student.latitude)
            let long = CLLocationDegrees(student.longitude)
            
            let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
            
            let first = student.firstName
            let last = student.lastName
            let mediaURL = student.mediaUrl
            
            let annotation = MKPointAnnotation()
            annotation.coordinate = coordinate
            annotation.title = "\(first) \(last)"
            annotation.subtitle = mediaURL
            
            annotations.append(annotation)
        }
        
        self.mapView.addAnnotations(annotations)
    }

}

extension MapViewController: MKMapViewDelegate {
    
    // MARK: - MKMapViewDelegate
    
    // Here we create a view with a "right callout accessory view". You might choose to look into other
    // decoration alternatives. Notice the similarity between this method and the cellForRowAtIndexPath
    // method in TableViewDataSource.
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        let reuseId = "pin"
        
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView
        
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView!.canShowCallout = true
            pinView!.pinTintColor = .red
            pinView!.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        }
        else {
            pinView!.annotation = annotation
        }
        
        return pinView
    }
    
    
    // This delegate method is implemented to respond to taps. It opens the system browser
    // to the URL specified in the annotationViews subtitle property.
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if control == view.rightCalloutAccessoryView {
            let app = UIApplication.shared
            if let toOpen = view.annotation?.subtitle! {
                if toOpen != "" {
                    app.open(URL(string: toOpen)! as URL)
                }
            }
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
