//
//  GetStartedOnboardingViewController.swift
//  Blue-Pail
//
//  Created by David Sadler on 6/18/19.
//  Copyright © 2019 David Sadler. All rights reserved.
//

import UIKit

class GetStartedOnboardingViewController: UIViewController {
    
    // MARK: - ViewLifeCycle

    override func viewDidLoad() {
        super.viewDidLoad()
        ViewHelper.roundCornersOf(viewLayer: nextButton.layer, withRoundingCoefficient: 15.0)
    }
    
    // MARK: - Outlets
    
    @IBOutlet weak var nextButton: UIButton!
}
