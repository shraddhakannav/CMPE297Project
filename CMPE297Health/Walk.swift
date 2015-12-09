//
//  Walk.swift
//  CMPE297Health
//
//  Created by Shraddha Kannav on 12/9/15.
//  Copyright © 2015 Shraddha Kannav. All rights reserved.
//

import Foundation
import CoreData


import Foundation
import CoreData
import CoreLocation

class Walk: NSManagedObject {
    
    @NSManaged var distance: NSNumber
    @NSManaged var startTimestamp: NSDate
    @NSManaged var endTimestamp: NSDate
    @NSManaged var locations: Array<CLLocation>
    
    var duration: NSTimeInterval {
        get {
            return endTimestamp.timeIntervalSinceDate(startTimestamp)
        }
    }
    
    func addDistance(distance: Double) {
        self.distance = NSNumber(double: (self.distance.doubleValue + distance))
    }
    
    func addNewLocation(location: CLLocation) {
        locations.append(location)
    }
    
    override func awakeFromInsert() {
        super.awakeFromInsert()
        
        locations = [CLLocation]()
        startTimestamp = NSDate()
        distance = 0.0
    }
    
}
