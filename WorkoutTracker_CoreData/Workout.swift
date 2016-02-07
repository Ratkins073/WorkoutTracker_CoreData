//
//  Workout.swift
//  WorkoutTracker
//
//  Created by Ryan Atkins on 2/5/16.
//  Copyright © 2016 Ryan Atkins. All rights reserved.
//

import UIKit

class Workout: NSObject, NSCoding {
    // MARK: Properties
    
    var name: String
    var date: NSDate
    var workoutDesc: String
    
    // MARK: Archiving Paths
    
    static let DocumentsDirectory = NSFileManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.URLByAppendingPathComponent("workouts")
    
    // MARK: Types
    
    struct PropertyKey {
        static let nameKey = "name"
        static let dateKey = "date"
        static let workoutDescKey = "workoutDesc"
    }
    
    // MARK: Comparisons
    
    func lessThan (a: Workout) -> Bool {
        return self.date.compare(a.date) == NSComparisonResult.OrderedAscending
    }
    
    func greaterThan (a: Workout) -> Bool {
        return self.date.compare(a.date) == NSComparisonResult.OrderedDescending
    }
    
    func equalTo (a: Workout) ->Bool {
        return self.date.compare(a.date) == NSComparisonResult.OrderedSame
    }

    // MARK: Initialization
    
    init?(name: String, date: NSDate, workoutDesc: String) {
        // Initialize stored properties.
        self.name = name
        self.workoutDesc = workoutDesc
        self.date = date
        
        super.init()
        
        // Initialization should fail if there is no name or if the rating is negative.
        if name.isEmpty || workoutDesc.isEmpty {
            return nil
        }
    }
    
    // MARK: NSCoding
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(name, forKey: PropertyKey.nameKey)
        aCoder.encodeObject(date, forKey: PropertyKey.dateKey)
        aCoder.encodeObject(workoutDesc, forKey: PropertyKey.workoutDescKey)
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        let name = aDecoder.decodeObjectForKey(PropertyKey.nameKey) as! String
        
        let date = aDecoder.decodeObjectForKey(PropertyKey.dateKey) as! NSDate
        
        let workoutDesc = aDecoder.decodeObjectForKey(PropertyKey.workoutDescKey) as! String
        
        // Must call designated initializer.
        self.init(name: name, date: date, workoutDesc: workoutDesc)
    }
}