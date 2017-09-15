//
//  SearchViewController.swift
//  RaceHub
//
//  Created by Piotr Olejnik on 04.09.2017.
//  Copyright © 2017 gat. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

protocol SearchDelegate: class {
    func didFind(_ event: Event)
}

class SearchViewController: UIViewController {
    
    @IBOutlet weak var resultsLabel: UILabel!
    @IBOutlet weak var tableHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    private let disposeBag = DisposeBag()
    private let viewModel = SearchViewModelImpl()
    var delegate: SearchDelegate?
    
    private struct Constants {
        static let cellIndentifier = "cell"
        static let cellHeight = CGFloat(44)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        bindRx()
    }

    private func setUI() {
        tableView.rowHeight = Constants.cellHeight
        tableHeightConstraint.constant = CGFloat(0)
        tableView.layoutIfNeeded()
        searchBar.backgroundImage = UIImage()
        self.resultsLabel.text = ""
    }
    
    private func bindRx() {
        closeButton.rx.tap.bind {
            self.dismiss(animated: true)
        }.addDisposableTo(disposeBag)
        
        searchBar.rx.text.orEmpty.debounce(0.5, scheduler: MainScheduler.instance).distinctUntilChanged().filter { !$0.isEmpty }.do(onNext: { _ in
            self.resultsLabel.text = "searching".localized
        }).subscribe(onNext: { [unowned self] query in
            self.viewModel.search(for: query).subscribe(onNext: { _ in }, onCompleted: {
                self.resultsLabel.text = ""
            }).addDisposableTo(self.disposeBag)
        }).addDisposableTo(disposeBag)
        
        viewModel.events.asObservable().bind(to: tableView.rx.items(cellIdentifier: Constants.cellIndentifier, cellType: UITableViewCell.self)) {
            _, event, cell in
            cell.textLabel?.text = event.name
            cell.detailTextLabel?.text = event.date.description
        }.addDisposableTo(disposeBag)
        
        viewModel.events.asObservable().bind(onNext: { [unowned self] events in
            self.tableHeightConstraint.constant = CGFloat(events.count) * Constants.cellHeight
            self.tableView.layoutIfNeeded()
        }).addDisposableTo(disposeBag)
        
        tableView.rx.modelSelected(Event.self).subscribe(onNext: { [unowned self] event in
            self.dismiss(animated: true)
            self.delegate?.didFind(event)
        }).addDisposableTo(disposeBag)
    }
    
}
