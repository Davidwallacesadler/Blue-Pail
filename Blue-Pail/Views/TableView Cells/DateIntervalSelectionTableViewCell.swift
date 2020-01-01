//
//  DateIntervalSelectionTableViewCell.swift
//  Blue-Pail
//
//  Created by David Sadler on 12/30/19.
//  Copyright © 2019 David Sadler. All rights reserved.
//

import UIKit

protocol IntervalSelectionCellDelegate {
    func segueToUpdateCalendar(givenCellKey: String)
}

class DateIntervalSelectionTableViewCell: UITableViewCell {
    
    // MARK: - Internal Properties
    
    var cellKey: String?
    var datePickerTag: Int = 0 {
        didSet {
            updatePickerTag()
        }
    }
    var delegate: IntervalSelectionCellDelegate?
    var selectedInterval: Int?
    var nextReminderDate: Date? {
        didSet {
            moveSetupButtonToTopRightCornerOfCell()
        }
    }
    
    // MARK: - Outlets
    
    @IBOutlet weak var nextLabel: UILabel!
    @IBOutlet weak var setupRemindersButton: UIButton!
    @IBOutlet weak var selectATimeLabel: UILabel!
    @IBOutlet weak var reminderTimeDatePicker: UIDatePicker!
    @IBOutlet weak var nextReminderLabel: UILabel!
    @IBOutlet weak var currentIntervalLabel: UILabel!
    
    
    // MARK: - Actions
    
    @IBAction func setupRemindersButtonPressed(_ sender: Any) {
        guard let selectionDelegate = delegate, let key = cellKey else { return }
        selectionDelegate.segueToUpdateCalendar(givenCellKey: key)
    }
    
    // MARK: - Methods
    
    func updatePickerTag() {
        reminderTimeDatePicker.tag = datePickerTag
    }
    
    func moveSetupButtonToTopRightCornerOfCell() {
        if nextReminderDate != nil {
            setupRemindersButton.removeFromSuperview()
            addSubview(setupRemindersButton)
            setupRemindersButton.setTitle(" Update Reminders", for: .normal)
            setupRemindersButton.bounds = CGRect(x: frame.width - 150.0, y: 150.0, width: 100.0, height: 100.0)
            nextReminderLabel.text = nextReminderDate!.stringValue()
            currentIntervalLabel.text = DayHelper.shared.translateDayIntToWeeks(givenAmountOfDays: selectedInterval!)
        }
    }
    
    // MARK: - View Lifecycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        if selectedInterval != nil && nextReminderDate != nil {
            moveSetupButtonToTopRightCornerOfCell()
        }
        ViewHelper.roundCornersOf(viewLayer: setupRemindersButton.layer, withRoundingCoefficient: 5.0)
    }
}
