//
//  WorkoutTableViewController.swift
//  WorkoutTracker
//
//  Created by Ryan Atkins on 2/5/16.
//  Copyright © 2016 Ryan Atkins. All rights reserved.
//

import UIKit

class WorkoutTableViewController: UITableViewController {
    // MARK: Properties
    
    var workouts = [Workout]()
    let dateFormatter = NSDateFormatter()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Use the edit button item provided by the table view controller.
        navigationItem.leftBarButtonItem = editButtonItem()
        
        // Load any saved workouts, otherwise load sample data.
        if let savedWorkouts = loadWorkouts() {
            workouts += savedWorkouts
        } else {
            // Load the sample data.
            loadSampleWorkouts()
        }
    }
    
    func sortWorkoutsByDate() {
        workouts.sortInPlace { $0.lessThan($1) }
    }
    
    func loadSampleWorkouts() {
        dateFormatter.dateFormat = "MM-dd-yyyy"
        
        let date1 = dateFormatter.dateFromString("02-05-2016")!
        let desc1 = "3 Rounds for time\n9-7-5\nMuscle-ups\nSquat Snatch 135 lbs."
        let workout1 = Workout(name: "Amanda", date: date1, workoutDesc: desc1)!
        
        let date2 = dateFormatter.dateFromString("02-05-2016")!
        let desc2 = "5 Rounds for time\n20 Pull-ups\n30 Push-ups\n40 Sit-ups\n50 Squats\n3 minute rest between rounds"
        let workout2 = Workout(name: "Barbara", date: date2, workoutDesc: desc2)!
        
        let date3 = dateFormatter.dateFromString("02-05-2016")!
        let desc3 = "3 Rounds for time\n21-15-9\nThruster 95 lbs.\nPull-ups"
        let workout3 = Workout(name: "Fran", date: date3, workoutDesc: desc3)!
        
        workouts += [workout1, workout2, workout3]
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return workouts.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        sortWorkoutsByDate()
        // Table view cells are reused and should be dequeued using a cell identifier.
        let cellIdentifier = "WorkoutTableViewCell"
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! WorkoutTableViewCell
        
        dateFormatter.dateStyle = NSDateFormatterStyle.LongStyle
        
        // Fetches the appropriate workout for the data source layout.
        let workout = workouts[indexPath.row]
        
        cell.nameLabel.text = workout.name
        cell.dateLabel.text = dateFormatter.stringFromDate(workout.date)
        
        return cell
    }

    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    

    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            workouts.removeAtIndex(indexPath.row)
            saveWorkouts()
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }


    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "ShowDetail" {
            let workoutDetailViewController = segue.destinationViewController as! WorkoutViewController
            
            // Get the cell that generated this segue.
            if let selectedWorkoutCell = sender as? WorkoutTableViewCell {
                let indexPath = tableView.indexPathForCell(selectedWorkoutCell)!
                let selectedWorkout = workouts[indexPath.row]
                workoutDetailViewController.workout = selectedWorkout
            }
        }
    }
    

    @IBAction func unwindToWorkoutList(sender: UIStoryboardSegue) {
        if let sourceViewController = sender.sourceViewController as? WorkoutViewController, workout = sourceViewController.workout {
            if let selectedIndexPath = tableView.indexPathForSelectedRow {
                // Update an existing workout.
                workouts[selectedIndexPath.row] = workout
                let workoutPreSort = workout
                sortWorkoutsByDate()
                if workouts[selectedIndexPath.row] === workoutPreSort {
                    tableView.reloadRowsAtIndexPaths([selectedIndexPath], withRowAnimation: .None)
                } else {
                    tableView.reloadData()
                }
            } else {
                // Add a new workout.
                let newIndexPath = NSIndexPath(forRow: workouts.count, inSection: 0)
                workouts.append(workout)
                tableView.insertRowsAtIndexPaths([newIndexPath], withRowAnimation: .Bottom)
                let workoutPreSort = workout
                sortWorkoutsByDate()
                if workouts[newIndexPath.row] !== workoutPreSort {
                    tableView.reloadData()
                }
            }
            // Save the workouts.
            saveWorkouts()
        }
    }
    
    // MARK: NSCoding
    
    func saveWorkouts() {
        let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(workouts, toFile: Workout.ArchiveURL.path!)
        if !isSuccessfulSave {
            print("Failed to save workouts...")
        }
    }
    
    func loadWorkouts() -> [Workout]? {
        return NSKeyedUnarchiver.unarchiveObjectWithFile(Workout.ArchiveURL.path!) as? [Workout]
    }
}
