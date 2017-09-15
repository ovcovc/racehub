//
//  ThemeManager.swift
//  RaceHub
//
//  Created by Piotr Olejnik on 29.08.2017.
//  Copyright © 2017 gat. All rights reserved.
//

import UIKit

class ThemeManager {
    
    static func applyRegularTheme() {
        apply(RegularTheme())
    }
    
    private static func apply(_ theme: Theme) {
        UINavigationBar.appearance().isTranslucent = true
        UINavigationBar.appearance().setBackgroundImage(nil, for: .default)
        UINavigationBar.appearance().barTintColor = theme.navigationBarBackgroundColor
        UINavigationBar.appearance().tintColor = theme.navigationBarTintColor
        UINavigationBar.appearance().shadowImage = theme.navigationBarShadowImage
        UIBarButtonItem.appearance(whenContainedInInstancesOf: [UINavigationBar.self]).tintColor = theme.navigationBarButtonTintColor
        UINavigationBar.appearance().titleTextAttributes = theme.navigationBarTitleTextAttributes
        UIBarButtonItem.appearance().setTitleTextAttributes(theme.navigationBarButtonTextAttributes, for: .normal)
        UITabBar.appearance().selectionIndicatorImage = theme.tabBarSelectionIndicatorImage
        UITabBar.appearance().tintColor = theme.tabBarTintColor
        UITabBar.appearance().shadowImage = theme.tabBarShadowImage
        UITabBarItem.appearance().setTitleTextAttributes(theme.tabBarTextAttributes, for: .normal)
        UITabBarItem.appearance().setTitleTextAttributes(theme.tabSelectedBarTextAttributes, for: .selected)
    }
    
}
