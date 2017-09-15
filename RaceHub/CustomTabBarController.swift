//
//  CustomTabBarController.swift
//  RaceHub
//
//  Created by Piotr Olejnik on 12.09.2017.
//  Copyright © 2017 gat. All rights reserved.
//

import UIKit

class CustomTabBarController: UITabBarController, Translatable {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        selectedIndex = 2
    }
    
    func applyTranslations() {
        tabBar.items?[0].title = "feed_icon".localized
        tabBar.items?[1].title = "my_events_icon".localized
        tabBar.items?[2].title = "map_icon".localized
        tabBar.items?[3].title = "profile_icon".localized
        tabBar.items?[4].title = "more_icon".localized
    }
    
}
