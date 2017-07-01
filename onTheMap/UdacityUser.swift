//
//  UdacityUser.swift
//  onTheMap
//
//  Created by Drew Fleeman on 7/1/17.
//  Copyright © 2017 drew. All rights reserved.
//

struct UdacityUser {
    
    var id: String = ""
    var firstName: String = ""
    var lastName: String = ""
    
    var fullName: String {
        return "\(firstName) \(lastName)"
    }

    init(dictionary: [String : AnyObject]) {
        id = dictionary["id"] as! String
        firstName = dictionary["firstName"] as! String
        lastName = dictionary["lastName"] as! String
    }
}
