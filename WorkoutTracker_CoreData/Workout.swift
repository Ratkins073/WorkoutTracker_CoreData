//
//  Workout.swift
//  WorkoutTracker
//
//  Created by Ryan Atkins on 2/5/16.
//  Copyright © 2016 Ryan Atkins. All rights reserved.
//

import UIKit
import CoreData

class Workout: NSManagedObject {
    // MARK: Properties
    
    @NSManaged var name: String
    @NSManaged var date: NSDate
    @NSManaged var workoutDesc: String
    
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
    
    class func createInManagedObjectContext(moc: NSManagedObjectContext, name: String, date: NSDate, workoutDesc: String) -> Workout {
        let newWorkout = NSEntityDescription.insertNewObjectForEntityForName("Workout", inManagedObjectContext: moc) as! Workout
        newWorkout.name = name
        newWorkout.date = date
        newWorkout.workoutDesc = workoutDesc
        
        return newWorkout
    }
}