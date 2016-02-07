//
//  WorkoutViewController.swift
//  WorkoutTracker
//
//  Created by Ryan Atkins on 2/5/16.
//  Copyright © 2016 Ryan Atkins. All rights reserved.
//

import UIKit

class WorkoutViewController: UIViewController, UITextFieldDelegate, UINavigationControllerDelegate, UIScrollViewDelegate, UITextViewDelegate {
    // MARK: Properties
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var dateTextField: UITextField!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var textView: UITextView!
    
    let dateFormatter = NSDateFormatter()
    
    /*
        This value is either passed by `WorkoutTableViewController` in `prepareForSegue(_:sender:)`
        or constructed as part of adding a new workout.
    */
    var workout: Workout?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Handle the text field’s user input through delegate callbacks.
        nameTextField.delegate = self
        dateTextField.delegate = self
        textView.delegate = self
        
        scrollView.delegate = self
        dateFormatter.dateStyle = NSDateFormatterStyle.LongStyle
        
        // Set up views if editing an existing Workout.
        if let workout = workout {
            navigationItem.title = workout.name
            nameTextField.text   = workout.name
            dateTextField.text = dateFormatter.stringFromDate(workout.date)
            textView.text = workout.workoutDesc
        } else {
            dateTextField.text = dateFormatter.stringFromDate(NSDate())
        }
        
        // Enable the Save button only if the text field has a valid Workout name and date.
        checkValidWorkout()
    }
    
    func checkValidWorkout() {
        // Disable the Save button if the text field is empty.
        let nameText = nameTextField.text ?? ""
        let dateText = dateTextField.text ?? ""
        if !dateText.isEmpty && !nameText.isEmpty {
            saveButton.enabled = true
        }
    }
    
    // MARK: UITextFieldDelegate
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        // Hide the keyboard.
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        checkValidWorkout()
        if textField === nameTextField {
            navigationItem.title = textField.text
        }
    }

    func textFieldDidBeginEditing(textField: UITextField) {
        /*
        // Disable the Save button while editing.
        saveButton.enabled = false
        */
    }
    
    // MARK: datePickerView
    func handleDatePicker(sender: UIDatePicker) {
        dateFormatter.dateStyle = NSDateFormatterStyle.LongStyle
        dateTextField.text = dateFormatter.stringFromDate(sender.date)
    }
    
    func doneButton(sender: UIButton) {
        dateTextField.resignFirstResponder()
    }
    
    // MARK: Navigation
    
    @IBAction func cancel(sender: UIBarButtonItem) {
        // Depending on style of presentation (modal or push presentation), this view controller needs to be dismissed in two different ways.
        let isPresentingInAddWorkoutMode = presentingViewController is UINavigationController
        
        if isPresentingInAddWorkoutMode {
            dismissViewControllerAnimated(true, completion: nil)
        } else {
            navigationController!.popViewControllerAnimated(true)
        }
    }
    
    // This method lets you configure a view controller before it's presented.
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        dateFormatter.dateStyle = NSDateFormatterStyle.LongStyle
        
        if saveButton === sender {
            let name = nameTextField.text ?? ""
            let strDate = dateTextField.text ?? ""
            let date = dateFormatter.dateFromString(strDate)!
            let workoutDesc = textView.text
            
            // Set the workout to be passed to WorkoutListTableViewController after the unwind segue.
            workout = Workout(name: name, date: date, workoutDesc: workoutDesc)
        }
    }
    
    // MARK: Actions
    
    @IBAction func dateTextFieldDidBeginEditing(sender: UITextField) {
        dateFormatter.dateStyle = NSDateFormatterStyle.LongStyle
        
        // Display date picker instead of the keyboard for editing the dateTextField
        //Create the view
        let inputView = UIView(frame: CGRectMake(0, 0, self.view.frame.width, 230))
        
        let datePickerView  : UIDatePicker = UIDatePicker(frame: CGRectMake(0, 20, 0, 0))
        datePickerView.frame.origin.x = (inputView.frame.width - datePickerView.frame.width) / 2
        datePickerView.datePickerMode = UIDatePickerMode.Date
        
        // Set datePicker date to current date in text field
        let date = dateTextField.text ?? ""
        if !date.isEmpty {
            datePickerView.date = dateFormatter.dateFromString(date)!
        }
        
        
        // Add datePicker to UIView
        inputView.addSubview(datePickerView)
        
        let doneButton = UIButton(frame: CGRectMake(0, 0, 60, 40))
        doneButton.frame.origin.x = inputView.frame.width - doneButton.frame.width
        doneButton.setTitle("Done", forState: UIControlState.Normal)
        doneButton.setTitle("Done", forState: UIControlState.Highlighted)
        doneButton.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
        doneButton.setTitleColor(UIColor.grayColor(), forState: UIControlState.Highlighted)
        
        inputView.addSubview(doneButton) // add Button to UIView
        
        doneButton.addTarget(self, action: "doneButton:", forControlEvents: UIControlEvents.TouchUpInside) // set button click event
        
        sender.inputView = inputView
        datePickerView.addTarget(self, action: Selector("handleDatePicker:"), forControlEvents: UIControlEvents.ValueChanged)
        
        handleDatePicker(datePickerView) // Set the date on start.
    }
    
}

