//
//  EventLandingViewController.swift
//  RaceHub
//
//  Created by Piotr Olejnik on 13.09.2017.
//  Copyright © 2017 gat. All rights reserved.
//

import UIKit
import XLPagerTabStrip
import RxCocoa
import RxSwift
import Kingfisher
import PKHUD

class EventLandingViewController: UIViewController {
    
    @IBOutlet weak var shadowView: UIView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var distancesLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    private var viewModel: EventDetailsViewModel!
    private let disposeBag = DisposeBag()
    
    // MARK: Static convenience initializer
    
    static func initialize(with viewModel: EventDetailsViewModel) ->  EventLandingViewController{
        let viewController = UIStoryboard(name: "Events", bundle: nil).instantiateViewController(withIdentifier: "EventLandingViewController") as! EventLandingViewController
        viewController.viewModel = viewModel
        return viewController
    }
    
    // MARK: Lifecycle methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupRx()
    }
    
    private func setupRx() {
        viewModel.imageUrl.asObservable().subscribe(onNext: { [unowned self] url in
            self.imageView.kf.setImage(with: URL(string: url))
        }).addDisposableTo(disposeBag)
        viewModel.placeAndDate.asObservable().bind(to: dateLabel.rx.text).addDisposableTo(disposeBag)
        viewModel.distanceString.asObservable().bind(to: distancesLabel.rx.text).addDisposableTo(disposeBag)
        viewModel.eventDescription.asObservable().bind(to: descriptionLabel.rx.text).addDisposableTo(disposeBag)
        viewModel.name.asObservable().subscribe(onNext: { [unowned self] name in
            self.title = name
        }).addDisposableTo(disposeBag)
        viewModel.fetching.asObservable().bind { fetching in
            self.shadowView.isHidden = fetching
        }.addDisposableTo(disposeBag)
    }
}

extension EventLandingViewController: IndicatorInfoProvider {
    
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title: "information".localized)
    }
    
}
