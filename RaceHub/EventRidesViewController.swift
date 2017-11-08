//
//  EventRidesViewController.swift
//  RaceHub
//
//  Created by Piotr Olejnik on 13.09.2017.
//  Copyright © 2017 gat. All rights reserved.
//

import UIKit
import XLPagerTabStrip
import RxSwift

class EventRidesViewController: UIViewController, Translatable {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var emptyStateView: UIStackView!
    @IBOutlet weak var emptyBodyLabel: UILabel!
    @IBOutlet weak var emptyTitleLabel: UILabel!
    
    private var eventId: Int!
    private var loadNextPageTrigger: Observable<Void>?
    private var refreshTrigger: Observable<Void>?
    private let disposeBag = DisposeBag()
    private let refreshControl = UIRefreshControl()
    private var viewModel: EventRidesViewModel?
    
    private enum Constants {
        static let storyboardId = "Events"
        static let cellIdentifier = "rideCell"
    }
    
    // MARK: Static convenience initializer
    
    static func initialize(with id: Int) ->  EventRidesViewController{
        let viewController = UIStoryboard(name: Constants.storyboardId, bundle: nil).instantiateViewController(withIdentifier: String(describing: EventRidesViewController.self)) as! EventRidesViewController
        viewController.eventId = id
        return viewController
    }
    
    // MARK: Lifecycle methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUI()
        applyTranslations()
        initializeTriggers()
        guard let refreshTrigger = refreshTrigger, let loadNextPageTrigger = loadNextPageTrigger else {
            return
        }
        viewModel = EventRidesViewModel(id: eventId, refreshTrigger: refreshTrigger, nextPageTrigger: loadNextPageTrigger)
        setupRx()
    }
    
    // MARK: Customization methods
    
    private func setUI() {
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 100
    }
    
    // MARK: Customization methods
    
    private func setupRx() {
        viewModel?.rides.asObservable().bind(to: tableView.rx.items(cellIdentifier: Constants.cellIdentifier, cellType: EventRideCell.self)) {
            row, ride, cell in
            cell.ride.value = ride
        }.addDisposableTo(disposeBag)
        
        viewModel?.fetching.asObservable().bind(onNext: { [unowned self] fetching in
            if fetching {
                UIApplication.shared.isNetworkActivityIndicatorVisible = true
            } else {
                self.refreshControl.endRefreshing()
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
            }
        }).addDisposableTo(disposeBag)
        
        viewModel?.rides.asObservable().map { return !$0.isEmpty }.bind(onNext: { [unowned self] in
            self.tableView.isHidden = !$0
            self.emptyStateView.isHidden = $0
        }).addDisposableTo(disposeBag)
    }
    
    private func initializeTriggers() {
        if #available(iOS 10.0, *) {
            tableView.refreshControl = refreshControl
        } else {
            tableView.addSubview(refreshControl)
        }
        refreshTrigger = refreshControl.rx.controlEvent(.valueChanged).asObservable()
        loadNextPageTrigger = tableView.rx.contentOffset.debounce(0.3, scheduler: MainScheduler.instance).flatMap({ offset in
            return self.tableView.isNearBottomEdge() ? Observable.just() : Observable.empty()
        })
    }
    
    func applyTranslations() {
        emptyBodyLabel.text = "no_rides_body".localized
        emptyTitleLabel.text = "no_rides".localized
    }
}

extension EventRidesViewController: IndicatorInfoProvider {
    
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title: "commute_title".localized)
    }
    
}
