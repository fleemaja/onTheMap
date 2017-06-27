//
//  Student.swift
//  onTheMap
//
//  Created by Drew Fleeman on 6/26/17.
//  Copyright © 2017 drew. All rights reserved.
//

import Foundation

struct Student {
    
    let firstName: String
    let lastName: String
    let longitude: Double
    let latitude: Double
    let mediaUrl: String
    let mapString: String
    let objectId: String
    let uniqueKey: String
    
    var fullName: String {
        return "\(firstName) \(lastName)"
    }
    
    init(dictionary: [String : AnyObject]) {
        firstName = dictionary["firstName"] as? String ?? ""
        lastName = dictionary["lastName"] as? String ?? ""
        longitude = dictionary["longitude"] as? Double ?? 0.0
        latitude = dictionary["latitude"] as? Double ?? 0.0
        mediaUrl = dictionary["mediaURL"] as? String ?? ""
        mapString = dictionary["mapString"] as? String ?? ""
        objectId = dictionary["objectId"] as? String ?? ""
        uniqueKey = dictionary["uniqueKey"] as? String ?? ""
    }
}
