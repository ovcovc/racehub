//
//  EventDistancesViewController.swift
//  RaceHub
//
//  Created by Piotr Olejnik on 13.09.2017.
//  Copyright © 2017 gat. All rights reserved.
//

import UIKit
import XLPagerTabStrip
import RxCocoa
import RxSwift

class EventDistancesViewController: UIViewController {
    
    private var viewModel: EventDetailsViewModel!
    private let disposeBag = DisposeBag()
    
    // MARK: Static convenience initializer
    
    static func initialize(with viewModel: EventDetailsViewModel) ->  EventDistancesViewController{
        let viewController = UIStoryboard(name: "Events", bundle: nil).instantiateViewController(withIdentifier: "EventDistancesViewController") as! EventDistancesViewController
        viewController.viewModel = viewModel
        return viewController
    }

    // MARK: Lifecycle methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupRx()
    }
    
    // MARK: Customization methods
    
    func setupRx() {
        
    }
    
}

extension EventDistancesViewController: IndicatorInfoProvider {

    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title: "distances".localized)
    }
    
}
