//
//  EventFeedViewController.swift
//  RaceHub
//
//  Created by Piotr Olejnik on 13.09.2017.
//  Copyright © 2017 gat. All rights reserved.
//

import UIKit
import XLPagerTabStrip
import RxCocoa
import RxSwift
import PKHUD

class EventFeedViewController: UIViewController {
    
    private enum Constants {
        static let storyboardId = "Events"
        static let cellIdentifier = "feedCell"
    }
    
    @IBOutlet weak var tableView: UITableView!

    private var viewModel: EventFeedViewModelImpl!
    private var loadNextPageTrigger: Observable<Void>!
    private var refreshTrigger: Observable<Void>!
    private var eventId: Int!
    private let disposeBag = DisposeBag()
    private let refreshControl = UIRefreshControl()
    
    // MARK: Static convenience initializer
    
    static func initialize(with id: Int) ->  EventFeedViewController{
        let viewController = UIStoryboard(name: Constants.storyboardId, bundle: nil).instantiateViewController(withIdentifier: String(describing: EventFeedViewController.self)) as! EventFeedViewController
        viewController.eventId = id
        return viewController
    }
    
    // MARK: Lifecycle methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        initializeTriggers()
        viewModel = EventFeedViewModelImpl(id: eventId, refreshTrigger: refreshTrigger, nextPageTrigger: loadNextPageTrigger)
        setupRx()
    }
    
    // MARK: Customization methods
    
    private func setUI() {
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 100
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
    
    private func setupRx() {
        viewModel.feed.asObservable().bind(to: tableView.rx.items(cellIdentifier: Constants.cellIdentifier, cellType: EventFeedCell.self)) {
            row, feedEntry, cell in
            let entryViewModel = FeedEntryViewModel(entry: feedEntry)
            cell.set(title: entryViewModel.title.asObservable(), date: entryViewModel.date.asObservable(), content: entryViewModel.content.asObservable(), unread: entryViewModel.unread.asObservable(), imageName: entryViewModel.iconName.asObservable(), videoUrl: entryViewModel.videoUrl.asObservable(), imageUrl: entryViewModel.imageUrl.asObservable(), contentUrl: entryViewModel.contentUrl.asObservable())
        }.addDisposableTo(disposeBag)
        viewModel.fetching.asObservable().bind(onNext: { [unowned self] fetching in
            if fetching {
                UIApplication.shared.isNetworkActivityIndicatorVisible = true
            } else {
                self.refreshControl.endRefreshing()
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
            }
        }).addDisposableTo(disposeBag)
    }
    
}

extension EventFeedViewController: IndicatorInfoProvider {
    
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title: "news".localized)
    }
    
}
