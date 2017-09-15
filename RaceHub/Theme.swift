//
//  Theme.swift
//  RaceHub
//
//  Created by Piotr Olejnik on 29.08.2017.
//  Copyright © 2017 gat. All rights reserved.
//

import UIKit

protocol Theme {
    var navigationBarBackgroundImage: UIImage? { get }
    var navigationBarBackgroundColor: UIColor? { get }
    var navigationBarShadowImage: UIImage? { get }
    var navigationBarTintColor: UIColor? { get }
    var navigationBarButtonTintColor: UIColor? { get }
    var navigationBarTitleTextAttributes: [String: Any] { get }
    var navigationBarButtonTextAttributes: [String: Any]? { get }
    var tabBarTintColor: UIColor? { get }
    var tabBarShadowImage: UIImage? { get }
    var tabBarSelectionIndicatorImage: UIImage? { get }
    var tabBarTextAttributes: [String: Any]? { get }
    var tabSelectedBarTextAttributes: [String: Any]? { get }
}

extension Theme {
    var navigationBarBackgroundImage: UIImage? { return UIImage() }
    var navigationBarBackgroundColor: UIColor? { return ColorPalette.primaryDarkBlue }
    var navigationBarButtonTintColor: UIColor? { return UIColor.white }
    var navigationBarTintColor: UIColor? { return UIColor.white }
    var navigationBarShadowImage: UIImage? { return UIImage() }
    var navigationBarTitleTextAttributes: [String: Any] {
        return [NSForegroundColorAttributeName: UIColor.white]
    }
    var navigationBarButtonTextAttributes: [String: Any]? {
        return [NSForegroundColorAttributeName: UIColor.white, NSFontAttributeName: UIFont.boldSystemFont(ofSize: 15.0)]
    }
    var tabBarTintColor: UIColor? { return ColorPalette.primaryDarkBlue }
    var tabBarShadowImage: UIImage? { return UIImage() }
    var tabBarSelectionIndicatorImage: UIImage? { return UIImage() }
    var tabBarTextAttributes: [String: Any]? {
        return [NSForegroundColorAttributeName: ColorPalette.primaryText, NSFontAttributeName: UIFont(name: "Helvetica", size: 12.0)!]
    }
    var tabSelectedBarTextAttributes: [String: Any]? {
        return [NSForegroundColorAttributeName: ColorPalette.primaryDarkBlue, NSFontAttributeName: UIFont(name: "Helvetica", size: 12.0)!]
    }
}
