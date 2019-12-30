//
//  FertilizerHistoryController.swift
//  Blue-Pail
//
//  Created by David Sadler on 12/27/19.
//  Copyright © 2019 David Sadler. All rights reserved.
//

import Foundation
import CoreData

class FertilizerHistoryController {
    // MARK: - Shared instance
    
    static let shared = FertilizerHistoryController()
    
    // MARK: - CRUD Methods
    
    /// Creates a Fertilizer History point and adds it to the Fertilizer History collection of the Plant.
    func createFertilizerHistory(givenOccurenceDate date: Date, givenParentPlant plant: Plant) {
        let newFertilizerHistoryPoint = FertilizerHistory(occurenceDate: date)
        plant.addToFertilzerHistory(newFertilizerHistoryPoint)
    }
    
    /// Deletes a Fertilizer History point from the Plant's Fertilizer History Collection.
    func deleteFertilizerHistory(selectedOccurenceDate date: Date, givenParentPlant plant: Plant) {
        #warning("do a fetchrequest on the parent plants fertilizer history points - if date of the one == date of method, remove it from the collection")
        guard let fertilizerHistory = plant.fertilzerHistory?.array as? [FertilizerHistory] else { return }
        let pointsOnTargetDate = fertilizerHistory.filter { (historyPoint) -> Bool in
            historyPoint.occurenceDate! == date
        }
        for point in pointsOnTargetDate {
            plant.removeFromFertilzerHistory(point)
        }
    }
}
