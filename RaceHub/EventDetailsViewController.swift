//
//  EventDetailsViewController.swift
//  RaceHub
//
//  Created by Piotr Olejnik on 12.09.2017.
//  Copyright © 2017 gat. All rights reserved.
//

import UIKit
import XLPagerTabStrip
import RxCocoa
import RxSwift
import RxGesture
import PKHUD

class EventDetailsViewController: ButtonBarPagerTabStripViewController, Translatable {
    
    var eventId: Int!
    var eventName = ""
    private var favBarButton: UIBarButtonItem!
    private var viewModel: EventDetailsViewModel!
    private let disposeBag = DisposeBag()
    
    // MARK: Lifecycle methods
    
    override func viewDidLoad() {
        viewModel = EventDetailsViewModelImpl(eventId: eventId)
        setButtonBarUI()
        super.viewDidLoad()
        setUI()
        setupRx()
    }
    
    // MARK: Customization methods
    
    private func setUI() {
        favBarButton = UIBarButtonItem(image: UIImage(named: "StarEmpty"), style: .plain, target: self, action: nil)
        navigationItem.rightBarButtonItems = [favBarButton]
        navigationItem.title = eventName
    }
    
    private func setupRx() {
        viewModel.fetching.asObservable().bind { fetching in
            fetching ? HUD.show(.progress) : HUD.hide()
        }.addDisposableTo(disposeBag)
    }
    
    private func setButtonBarUI() {
        settings.style.buttonBarBackgroundColor = ColorPalette.primaryLightBlue
        settings.style.buttonBarItemBackgroundColor = ColorPalette.primaryLightBlue
        settings.style.selectedBarBackgroundColor = ColorPalette.logoRed
        settings.style.buttonBarItemFont = .boldSystemFont(ofSize: 14)
        settings.style.selectedBarHeight = 2.0
        settings.style.buttonBarMinimumLineSpacing = 0
        settings.style.buttonBarItemTitleColor = UIColor.white
        settings.style.buttonBarItemsShouldFillAvailiableWidth = true
        settings.style.buttonBarLeftContentInset = 0
        settings.style.buttonBarRightContentInset = 0
        changeCurrentIndexProgressive = { (oldCell: ButtonBarViewCell?, newCell: ButtonBarViewCell?, progressPercentage: CGFloat, changeCurrentIndex: Bool, animated: Bool) -> Void in
            guard changeCurrentIndex == true else { return }
            oldCell?.label.textColor = .white
            newCell?.label.textColor = ColorPalette.logoRed
        }
    }
    
    func applyTranslations() { /* No content to translate */ }
    
    override func viewControllers(for pagerTabStripController: PagerTabStripViewController) -> [UIViewController] {
        let landing = EventLandingViewController.initialize(with: viewModel)
        let distances = EventDistancesViewController.initialize(with: viewModel)
        let feed = UIStoryboard(name: "Events", bundle: nil).instantiateViewController(withIdentifier: "EventFeedViewController")
        let rides = UIStoryboard(name: "Events", bundle: nil).instantiateViewController(withIdentifier: "EventRidesViewController")
        let contact = UIStoryboard(name: "Events", bundle: nil).instantiateViewController(withIdentifier: "EventContactViewController")
        return [landing, distances, feed, rides, contact]
    }
    
}
