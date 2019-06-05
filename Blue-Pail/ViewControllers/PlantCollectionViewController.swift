//
//  PlantCollectionViewController.swift
//  Blue-Pail
//
//  Created by David Sadler on 5/7/19.
//  Copyright © 2019 David Sadler. All rights reserved.
//

import UIKit

private let reuseIdentifier = "plantCell"

class PlantCollectionViewController: UICollectionViewController, PopupDelegate, UIPickerViewDelegate, UIPickerViewDataSource {
    
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return filterTitles.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return filterTitles[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let selectedTagTitle = filterTitles[row]
        plantCollection = []
        if selectedTagTitle == "All" {
            plantCollection = getAllPlants()
        } else {
            let selectedTag = TagController.shared.getSelectedTag(givenTagTitle: selectedTagTitle)
            guard let tagPlants = selectedTag.plants?.array as? [Plant] else { return }
            for plant in tagPlants {
                plantCollection.append(plant)
            }
        }
        self.collectionView.reloadData()
        dismissFilter()
    }
    
    
    // MARK: - PopupDelegate Methods
    
    func editPlant() {
        performSegue(withIdentifier: "toEditPlant", sender: self)
    }
    
    func waterPlant() {
        guard let targetPlant = selectedPlant, let targetIndex = collectionView.indexPathsForSelectedItems else { return }
        if targetPlant.isWatered == false {
            PlantController.shared.waterPlant(plant: targetPlant)
        }
        // TODO: - Want to just reload a single item not the whole collectionVieqw
        self.collectionView.reloadItems(at: targetIndex)
       // self.collectionView.reloadData()
    }
    
    // MARK: - Stored Properties
    
    var tempInput: UITextField?
    var plantCollection: [Plant] = []
    var selectedPlant: Plant?
    
    // MARK: - Computed Properties
    
    var filterTitles: [String] {
        var titles = ["All"]
        let tagCollection = TagController.shared.tags
        for tag in tagCollection {
            guard let tagTitle = tag.title else { return titles }
            titles.append(tagTitle)
        }
        return titles
    }
    
    // MARK: - View LifeCycle

    // TODO: - Have the collectionView Refresh when the app is re-opened from the background
    override func viewDidLoad() {
        super.viewDidLoad()
        plantCollection = getAllPlants()
        self.collectionView.reloadData()
        self.tagFilterPickerView.delegate = self
        self.tagFilterPickerView.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.collectionView.reloadData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.collectionView.reloadData()
    }
    
    // MARK: - Outlets
    
    @IBOutlet var tagFilterPickerView: UIPickerView!
    
    // MARK: - Actions
    
    @IBAction func filterButtonPressed(_ sender: Any) {
        if tagFilterPickerView.superview != nil {
            return
        }
        // Using an 'invisible' textField here so I can use it as an input view for the tagFilter:
        let temporaryInput = UITextField(frame:CGRect.zero)
        temporaryInput.inputView = self.tagFilterPickerView
        self.view.addSubview(temporaryInput)
        temporaryInput.becomeFirstResponder()
        tempInput = temporaryInput
    }
    
    // MARK: CollectionView DataSource Methods

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return plantCollection.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as? PlantCollectionViewCell else {
            print("ERROR: The collectionViewCell is not an instance of PlantCollectionViewCell!")
            return UICollectionViewCell()
        }
        let selectedPlant = plantCollection[indexPath.row]
        var daysToNextWater = String()
        if let fireDate = selectedPlant.needsWateredFireDate {
            if Date() <= fireDate || DayHelper.twoDatesAreOnTheSameDay(dateOne: Date(), dateTwo: fireDate) {
                daysToNextWater = DayHelper.daysUntil(fireDate: fireDate)
                if daysToNextWater == "Today" {
                     cell.waterNotificationStatusImageView.image = UIImage(named: "waterPlantIcon")
                     let fireTime = fireDate.timeStringValue()
                     daysToNextWater.append("(\(fireTime))")
                } else {
                     cell.waterNotificationStatusImageView.image = UIImage(named: "notTimeToWaterPlantIcon")
                }
            } else {
                daysToNextWater = DayHelper.formatMonthAndDay(givenDate: fireDate)
                cell.waterNotificationStatusImageView.image = UIImage(named: "waterPlantIcon")
            }
        }
        // Cell Setup:
        PlantController.shared.checkIfDry(plant: selectedPlant)
        let selectedPlantTagColor = ColorHelper.colorFrom(colorNumber: selectedPlant.tag?.colorNumber ?? Double(Int.random(in: 1...6)))
        let plantWateredStateColor = PlantController.shared.colorBasedOnWateredState(plant: selectedPlant)
        cell.plantNameLabel.text = selectedPlant.name
        cell.tagTitleLabel.text = selectedPlant.tag?.title
        cell.tagTitleLabel.textColor = selectedPlantTagColor
        cell.plantImageView.image = selectedPlant.photo
        cell.plantImageView.contentMode = .scaleAspectFill
        cell.tagColorView.backgroundColor = selectedPlantTagColor
        cell.waterNotificationStatusLabel.text = daysToNextWater
        cell.backgroundColor = plantWateredStateColor
        cell.plantNameIconImageView.image = UIImage(named: "plantNameIcon")
        cell.tagNameIconImageView.image = UIImage(named: "tagNameIcon")
        return cell
    }

    // MARK: CollectionView Delegate Methods

    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let plant = plantCollection[indexPath.row]
        selectedPlant = plant
        let plantPopupViewController = PlantPopupViewController(nibName: "PlantPopupViewController", bundle: nil)
        plantPopupViewController.delegate = self
        self.addChild(plantPopupViewController)
        plantPopupViewController.view.frame = self.view.frame
        self.view.addSubview(plantPopupViewController.view)
        plantPopupViewController.didMove(toParent: self)
        plantPopupViewController.plantNameLabel.text = plant.name
    }
    
    // MARK: - Internal Methods
    
    /// Returns an array that is populated with every Plant object.
    func getAllPlants() -> [Plant] {
        var collection = [Plant]()
        let allTags = TagController.shared.tags
        for tag in allTags {
            guard let tagPlants = tag.plants?.array as? [Plant] else { return []}
            for plant in tagPlants {
                collection.append(plant)
            }
        }
        return collection
    }
    
    /// Removes the tagPickerView from it's superview, and resigns the first responder for the tempInput.
    private func dismissFilter() {
        tagFilterPickerView.removeFromSuperview()
        tempInput?.resignFirstResponder()
    }
    
}

// MARK: - Delegate Flow Layout Extension

extension PlantCollectionViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        // TODO: - Make this depended on the view rather than just being hard coded
        return CGSize(width: 150, height: 200)
    }
    
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toEditPlant" {
            guard let detailVC = segue.destination as? PlantDetailTableViewController else { return }
            detailVC.plant = selectedPlant
            detailVC.navigationItem.title = selectedPlant?.name
            }
        }
}
