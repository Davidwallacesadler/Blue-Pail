//
//  CalendarDateSelectionViewController.swift
//  Blue-Pail
//
//  Created by David Sadler on 12/30/19.
//  Copyright © 2019 David Sadler. All rights reserved.
//

import UIKit
import FSCalendar

class CalendarDateSelectionViewController: UIViewController, FSCalendarDelegate, FSCalendarDataSource {
    
    // MARK: - Calendar Delegation
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        let timeSinceNow = date.timeIntervalSinceNow
        if timeSinceNow < 0 {
            displayFutureDateAlert(withSelectedDate: date)
            return
        }
        if firstSelectedDate == nil {
            firstSelectedDate = date
            setupNextReminderDateLabel()
        }
        if secondSelectedDate == nil && firstDateWasSelected {
            secondSelectedDate = date
            setupIntervalLabel()
        }
    }
    
    func calendar(_ calendar: FSCalendar, didDeselect date: Date, at monthPosition: FSCalendarMonthPosition) {
        if let firstDate = firstSelectedDate, let secondDate = secondSelectedDate {
            if date == firstDate {
                firstSelectedDate = secondDate
                secondSelectedDate = nil
            }
            if date == secondDate {
                secondSelectedDate = nil
            }
        }
    }
    
    // MARK: - Properties
    
    var firstSelectedDate: Date?
    var secondSelectedDate: Date?
    var firstDateWasSelected = false
    
    // MARK: - Outlets
    
    @IBOutlet weak var doneButton: UIButton!
    @IBOutlet weak var tipLabel: UILabel!
    @IBOutlet weak var nextDateLabel: UILabel!
    @IBOutlet weak var currentIntervalLabel: UILabel!
    @IBOutlet weak var calendar: FSCalendar!
    
    // MARK: - Actions
    
    @IBAction func doneButtonPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCalendarDelegation()
    }
    
    // MARK: - Internal Methods
    
    private func setupNextReminderDateLabel() {
        if let firstDate = firstSelectedDate {
            nextDateLabel.text = firstDate.stringValue()
            tipLabel.text = "2. Select another date in the future to determine the frequency of fertilizing."
        }
    }
    
    private func setupIntervalLabel() {
        if let dateOne = firstSelectedDate, let dateTwo = secondSelectedDate {
            nextDateLabel.text = determineFertilizerInterval(dateOne: dateOne, dateTwo: dateTwo)
            tipLabel.text = "3. Hit Done when you're ready."
        }
    }
    
    private func setupCalendarDelegation() {
        calendar.delegate = self
        calendar.dataSource = self
        calendar.allowsMultipleSelection = true
    }
    
    private func displayFutureDateAlert(withSelectedDate date: Date) {
        let futureDateAlert = UIAlertController(title: "Date is in the Past", message: "Please select a day that is tomorrow at the earliest.", preferredStyle: .alert)
        futureDateAlert.addAction(UIAlertAction(title: "Okay", style: .cancel, handler: nil))
        calendar.deselect(date)
    }
    
    private func determineFertilizerInterval(dateOne: Date, dateTwo: Date) -> String {
        var secondsFromNowTillEnd = dateTwo.timeIntervalSince(dateOne)
        let secondsInADay = 86400.0
        var intervalDays = 1
        while secondsFromNowTillEnd > secondsInADay {
            intervalDays += 1
            secondsFromNowTillEnd -= secondsInADay
        }
        var intervalWeeks = 0
        while intervalDays >= 7 {
            intervalWeeks += 1
            intervalDays -= 7
        }
        var text = "Interval: "
        if intervalWeeks != 0 {
            if intervalWeeks == 1 {
                text.append("1 week ")
            } else {
                text.append("\(intervalWeeks) weeks ")
            }
        }
        if intervalDays != 0 {
            if intervalDays == 1 {
                text.append("1 day")
            } else {
                text.append("\(intervalDays) days")
            }
        }
        return text
    }
}
