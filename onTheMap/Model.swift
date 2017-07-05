//
//  Model.swift
//  onTheMap
//
//  Created by Drew Fleeman on 7/5/17.
//  Copyright © 2017 drew. All rights reserved.
//

import Foundation

class Model {
    
    var students = [StudentInformation]()
    var user: UdacityUser?
    
    /*
     * Return the singleton instance of Model
     */
    class var shared: Model {
        struct Static {
            static let instance: Model = Model()
        }
        return Static.instance
    }
    
}
