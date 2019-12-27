//
//  OnboardingPageViewController.swift
//  Blue-Pail
//
//  Created by David Sadler on 6/18/19.
//  Copyright © 2019 David Sadler. All rights reserved.
//

import UIKit

class OnboardingPageViewController: UIPageViewController, UIPageViewControllerDataSource {
    
    // MARK: - PageViewController DataSource Methods
    
    // Sets up the viewController before reference (going backwards in the pageVC)
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        if viewController.isKind(of: GetStartedOnboardingViewController.self) {
            return getStepTwo()
        } else if viewController.isKind(of: NotificationOnboardingViewController.self) {
            return getStepOne()
        } else if viewController.isKind(of: SetupOnboardingViewController.self) {
            return getStepZero()
        } else {
            return nil
        }
    }
    
    // Sets up the viewController next reference (going forwards in the pageVC)
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        if viewController.isKind(of: WelcomeOnboardingViewController.self) {
            return getStepOne()
        } else if viewController.isKind(of: SetupOnboardingViewController.self) {
            return getStepTwo()
        } else if viewController.isKind(of: NotificationOnboardingViewController.self) {
            return getStepThree()
        } else {
            return nil
        }
    }
    
    // Sets up the amount of dots (pages) for the pageVC
    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        return 4
    }
    // Sets up the first page to display (index 0)
    func presentationIndex(for pageViewController: UIPageViewController) -> Int {
        return 0
    }
    
    // MARK: - View Lifecycle

    override func viewDidLoad() {
        
        // PageCollectionView Setup:
        // Setting the direction, dataSource protocol and background color to an off white
        setViewControllers([getStepZero()], direction: .forward, animated: false, completion: nil)
        dataSource = self
        view.backgroundColor = UIColor(red: 247/255, green: 250/255, blue: 250/255, alpha: 250/255)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        // PageControl Color Setup:
        for view in self.view.subviews{
            if view is UIPageControl{
                (view as! UIPageControl).currentPageIndicatorTintColor = .redOrange
                (view as! UIPageControl).pageIndicatorTintColor = .darkGrayBlue
            }
        }
    }
    
    // MARK: - Internal Methods:
    
    /// Instantiates the "Welcome" screen.
    func getStepZero() -> WelcomeOnboardingViewController {
        return storyboard!.instantiateViewController(withIdentifier: "WelcomeOnboardingViewController") as! WelcomeOnboardingViewController
    }
    
    /// Instantiates the "Simple Setup" screen.
    func getStepOne() -> SetupOnboardingViewController {
        return storyboard!.instantiateViewController(withIdentifier: "SetupOnboardingViewController") as! SetupOnboardingViewController
    }
    
    /// Instantiates the "Notification Description" screen.
    func getStepTwo() -> NotificationOnboardingViewController {
        return storyboard!.instantiateViewController(withIdentifier: "NotificationOnboardingViewController") as! NotificationOnboardingViewController
    }
    
    /// Instantiates the "Get Started" screen.
    func getStepThree() -> GetStartedOnboardingViewController {
        return storyboard!.instantiateViewController(withIdentifier: "GetStartedOnboardingViewController") as! GetStartedOnboardingViewController
    }
}
