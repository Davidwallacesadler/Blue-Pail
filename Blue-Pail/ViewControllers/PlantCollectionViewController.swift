//
//  PlantCollectionViewController.swift
//  Blue-Pail
//
//  Created by David Sadler on 5/7/19.
//  Copyright © 2019 David Sadler. All rights reserved.
//

import UIKit

private let reuseIdentifier = "plantCell"

class PlantCollectionViewController: UICollectionViewController, PopupDelegate {

    
    // MARK: - Delegate Methods
    
    
    func editPlant() {
        // Want to pass selected plant to the detailViewController --
        // 1. Call collectionView didSelectItemAtIndexPath - get selected plant
        // Segue to detailViewController
        print("Edit Button Pressed")
    }
    
    func waterPlant() {
        // Grab plant at indexpath.row
        // Want to call PlantController.shared.WaterPlant(selectedPlant)
        print("Water Button Pressed")
        guard let targetPlant = selectedPlant else { return }
        if targetPlant.isWatered == false {
            // Water the plant and schedule the next notification:
            PlantController.shared.waterPlant(plant: targetPlant)
            targetPlant.needsWateredFireDate = DayHelper.futrueDateFrom(givenNumberOfDays: Int(targetPlant.dayToNextWater))
            PlantController.shared.scheduleUserNotifications(for: targetPlant)
        }
        // Pop the child view controller in the PlantPopupViewController
    }
    
    
    // MARK: - Properties
    
    var selectedPlant: Plant?
    
    // MARK: - View LifeCycle

    override func viewDidLoad() {
        super.viewDidLoad()
        self.collectionView.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.collectionView.reloadData()
    }

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return PlantController.shared.plants.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as? PlantCollectionViewCell else {
            print("ERROR: The collectionViewCell is not an instance of PlantCollectionViewCell!")
            return UICollectionViewCell()
        }
        // Grab the selcted plant:
        let selectedPlant = PlantController.shared.plants[indexPath.row]
        // Initialize the String that will populate the label for the nextDayToBeWatered:
        var daysToNextWater = String()
        // Check if the selectedPlant has a fireDate (it always should!):
        if let fireDate = selectedPlant.needsWateredFireDate {
            // Check if the current date is less than the notificationFireDate OR if the current date is in the same day as the fireDate:
            if Date() <= fireDate || DayHelper.twoDatesAreOnTheSameDay(dateOne: Date(), dateTwo: fireDate){
                // If so, get the amount of days until that day to display it:
                daysToNextWater = DayHelper.daysUntil(fireDate: fireDate)
                cell.waterNotificationStatusImageView.image = UIImage(named: "notTimeToWaterPlantIcon")
            } else {
                // The current date is greater than the fireDate, and its the next day or greater:
                // If not, get the notificationFireDate to display on the cell:
                daysToNextWater = DayHelper.formatMonthAndDay(givenDate: fireDate)
                cell.waterNotificationStatusImageView.image = UIImage(named: "waterPlantIcon")
            }
        }
        PlantController.shared.checkIfDry(plant: selectedPlant)
        let selectedPlantTagColor = ColorHelper.colorFrom(colorNumber: selectedPlant.tag?.colorNumber ?? Double(Int.random(in: 1...6)))
        let plantWateredStateColor = PlantController.shared.colorBasedOnWateredState(plant: selectedPlant)
        
        // Update the cell elements
        cell.plantNameLabel.text = selectedPlant.name
        cell.tagTitleLabel.text = selectedPlant.tag?.title
        cell.tagTitleLabel.textColor = selectedPlantTagColor
        cell.plantImageView.image = selectedPlant.photo
        cell.tagColorView.backgroundColor = selectedPlantTagColor
        cell.waterNotificationStatusLabel.text = daysToNextWater
        cell.backgroundColor = plantWateredStateColor
        
        cell.plantNameIconImageView.image = UIImage(named: "plantNameIcon")
        cell.tagNameIconImageView.image = UIImage(named: "tagNameIcon")
    
        
        return cell
    }

    // MARK: UICollectionViewDelegate

    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let plant = PlantController.shared.plants[indexPath.row]
        selectedPlant = plant
        // Want to Add child view and display it
        guard let popupController = storyboard?.instantiateViewController(withIdentifier: "popupViewController") else { return }
        self.addChild(popupController)
        self.view.addSubview(popupController.view)
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }


    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
    
    }

}

// MARK: Delegate Flow Layout

extension PlantCollectionViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        // TODO: - Make this depended on the view rather than just being hard coded
        return CGSize(width: 150, height: 200)
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using [segue destinationViewController].
     // Pass the selected object to the new view controller.
     }
     */
}
