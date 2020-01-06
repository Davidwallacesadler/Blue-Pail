//
//  FertilizerHistoryViewController.swift
//  Blue-Pail
//
//  Created by David Sadler on 1/5/20.
//  Copyright © 2020 David Sadler. All rights reserved.
//

import UIKit
import FSCalendar

class FertilizerHistoryViewController: UIViewController, FSCalendarDataSource, FSCalendarDelegate {
    
    // MARK: - Calendar Datasource
    #warning("make selection color clear -- if the user selects a day maybe display a popup with the time at which the fertilzing was done.")
    
     func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, fillDefaultColorFor date: Date) -> UIColor? {
        //set dates with events to Green
        let dateString = date.dayMonthYearValue()
        if self.fertilizerHistory.contains(dateString){
            return UIColor.green
        }
        return nil
    }
    
    func calendar(_ calendar: FSCalendar, willDisplay cell: FSCalendarCell, for date: Date, at monthPosition: FSCalendarMonthPosition) {
        if fertilizerHistory.contains(date.dayMonthYearValue()) {
            cell.preferredBorderDefaultColor = .green
            cell.configureAppearance()
        }
    }
    
    // MARK: - Internal Properties

    var plant: Plant?
    var fertilizerHistory: [String] {
        get {
            guard let plant = plant else { return [] }
            guard let historyArray = plant.fertilzerHistory?.array as? [FertilizerHistory] else { return [] }
            return historyArray.compactMap { (historyPoint) -> String? in
                guard let date = historyPoint.occurenceDate else { return nil }
                return date.dayMonthYearValue()
            }
        }
    }
    
    // MARK: - Outlets

    @IBOutlet weak var calendar: FSCalendar!
    @IBOutlet weak var doneButtonHandle: UIButton!
    
    // MARK: - Actions
    
    @IBAction func doneButtonHandlePressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCalendarDatasource()
        //updateDataSource()
        ViewHelper.roundCornersOf(viewLayer: doneButtonHandle.layer, withRoundingCoefficient: 4.0)
        calendar.allowsSelection = false
    }
    
    // MARK: - Internal Methods
    
    private func updateDataSource() {
        for point in fertilizerHistory {
            calendar.select(point)
        }
        calendar.reloadData()
    }
    
    private func setupCalendarDatasource() {
        calendar.dataSource = self
        calendar.delegate = self
    }
}
