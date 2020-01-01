//
//  CalendarDateSelectionViewController.swift
//  Blue-Pail
//
//  Created by David Sadler on 12/30/19.
//  Copyright © 2019 David Sadler. All rights reserved.
//

import UIKit
import FSCalendar
protocol CalendarDateSelectionDelegate {
    func updateDates(selectedKey key: String, dateAndInterval: (Date, Int))
}

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
        } else if secondSelectedDate == nil && firstDateWasSelected {
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
    
    var delegate: CalendarDateSelectionDelegate?
    var firstSelectedDate: Date?
    var secondSelectedDate: Date?
    var firstDateWasSelected = false
    var reminderKey: String?
    
    // MARK: - Outlets
    
    @IBOutlet weak var doneButton: UIButton!
    @IBOutlet weak var tipLabel: UILabel!
    @IBOutlet weak var nextDateLabel: UILabel!
    @IBOutlet weak var currentIntervalLabel: UILabel!
    @IBOutlet weak var calendar: FSCalendar!
    
    // MARK: - Actions
    
    @IBAction func doneButtonPressed(_ sender: Any) {
        guard let calendarDelegate = delegate, let key = reminderKey, let dateOne = firstSelectedDate, let dateTwo = secondSelectedDate else { return }
        if let intervalDays = DayHelper.shared.amountOfDaysBetweenInteger(previousDate: dateOne, futureDate: dateTwo) {
            calendarDelegate.updateDates(selectedKey: key, dateAndInterval: (dateOne,intervalDays))
            self.dismiss(animated: true, completion: nil)
                   
        }
       
    }
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCalendarDelegation()
        if let key = reminderKey {
            if key == Keys.waterNotification {
                tipLabel.text?.append(" to water.")
            } else {
                tipLabel.text?.append(" to fertilize.")
                doneButton.backgroundColor = #colorLiteral(red: 0.1960784346, green: 0.3411764801, blue: 0.1019607857, alpha: 1)
            }
        }
    }
    
    // MARK: - Internal Methods
    
    private func setupNextReminderDateLabel() {
        if let firstDate = firstSelectedDate {
            nextDateLabel.text = firstDate.dayMonthYearValue()
            tipLabel.text = "2. Select another date in the future to determine the frequency."
            firstDateWasSelected = true
        }
    }
    
    private func setupIntervalLabel() {
        if let dateOne = firstSelectedDate, let dateTwo = secondSelectedDate {
            currentIntervalLabel.text = DayHelper.shared.determineReadableIntervalBetweenDates(dateOne: dateOne, dateTwo: dateTwo)
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
        present(futureDateAlert, animated: true, completion: nil)
        calendar.deselect(date)
    }
    
}
