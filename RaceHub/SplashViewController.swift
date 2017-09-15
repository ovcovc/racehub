//
//  SplashViewController.swift
//  RaceHub
//
//  Created by Piotr Olejnik on 29.08.2017.
//  Copyright © 2017 gat. All rights reserved.
//

import UIKit

class SplashViewController: UIViewController {
    
    private struct Constants {
        static let loadingDuration = Double(exactly: 2)!
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        perform(after: Constants.loadingDuration) {
            self.performSegue(withIdentifier: Segues.toMapViewController, sender: self)
        }
    }
    
}
