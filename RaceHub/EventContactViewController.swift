//
//  EventContactViewController.swift
//  RaceHub
//
//  Created by Piotr Olejnik on 13.09.2017.
//  Copyright © 2017 gat. All rights reserved.
//

import UIKit
import XLPagerTabStrip

class EventContactViewController: UIViewController, IndicatorInfoProvider {
    
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title: "Kontakt")
    }
    
}
