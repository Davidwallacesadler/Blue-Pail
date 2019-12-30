//
//  DateIntervalSelectionTableViewCell.swift
//  Blue-Pail
//
//  Created by David Sadler on 12/30/19.
//  Copyright © 2019 David Sadler. All rights reserved.
//

import UIKit

protocol IntervalSelectionCellDelegate {
    func segueToUpdateCalendar()
}

class DateIntervalSelectionTableViewCell: UITableViewCell {
    
    // MARK: - Internal Properties
    
    var delegate: IntervalSelectionCellDelegate?
    var selectedInterval: Int?
    var nextReminderDate: Date? {
        didSet {
            moveSetupButtonToTopRightCornerOfCell()
        }
    }
    
    // MARK: - Outlets
    
    @IBOutlet weak var setupRemindersButton: UIButton!
    @IBOutlet weak var selectATimeLabel: UILabel!
    @IBOutlet weak var reminderTimeDatePicker: UIDatePicker!
    @IBOutlet weak var nextReminderLabel: UILabel!
    @IBOutlet weak var currentIntervalLabel: UILabel!
    
    
    // MARK: - Actions
    
    @IBAction func setupRemindersButtonPressed(_ sender: Any) {
        guard let selectionDelegate = delegate else { return }
        selectionDelegate.segueToUpdateCalendar()
    }
    
    // MARK: - Methods
    
    func moveSetupButtonToTopRightCornerOfCell() {
        setupRemindersButton.frame = CGRect(x: frame.width - 100.0, y: 100.0, width: 100.0, height: 100.0)
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
