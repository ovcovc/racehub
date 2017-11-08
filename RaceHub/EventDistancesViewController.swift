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
    
    @IBOutlet weak var tableView: UITableView!
    private var viewModel: EventDetailsViewModel!
    private let disposeBag = DisposeBag()
    
    private enum Constants {
        static let cellIdentifier = "runCell"
        static let storyboardId = "Events"
    }
    
    // MARK: Static convenience initializer
    
    static func initialize(with viewModel: EventDetailsViewModel) ->  EventDistancesViewController{
        let viewController = UIStoryboard(name: Constants.storyboardId, bundle: nil).instantiateViewController(withIdentifier: String(describing: EventDistancesViewController.self)) as! EventDistancesViewController
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
        viewModel.distanceArray.asObservable().bind(to: tableView.rx.items(cellIdentifier: Constants.cellIdentifier, cellType: EventDistanceCell.self)) {
            row, distance, cell in
                let distanceViewModel = EventDistanceViewModelImpl(distance: distance)
                distanceViewModel.dateString.asObservable().bind(to: cell.dateLabel.rx.text).addDisposableTo(self.disposeBag)
                distanceViewModel.nameString.asObservable().bind(to: cell.nameLabel.rx.text).addDisposableTo(self.disposeBag)
                distanceViewModel.distanceString.asObservable().bind(to: cell.distanceLabel.rx.text).addDisposableTo(self.disposeBag)
                distanceViewModel.limitString.asObservable().bind(to: cell.limitLabel.rx.text).addDisposableTo(self.disposeBag)
            }.addDisposableTo(disposeBag)
    }
    
}

extension EventDistancesViewController: IndicatorInfoProvider {

    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title: "distances".localized)
    }
    
}
