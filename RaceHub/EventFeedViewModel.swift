//
//  EventFeedViewModel.swift
//  RaceHub
//
//  Created by Piotr Olejnik on 16.09.2017.
//  Copyright © 2017 gat. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift

protocol EventFeedViewModel {
    var feed: Variable<[FeedEntry]> { get set }
    var fetching: Variable<Bool> { get set }
    func fetchFeed(refresh: Bool)
}

class EventFeedViewModelImpl: EventFeedViewModel {
    
    var feed = Variable<[FeedEntry]>([])
    var fetching = Variable<Bool>(false)
    private let id: Int
    private let disposeBag = DisposeBag()
    private let service: FeedService
    private var page = 1
    private var shouldPaginate = true
    
    init(id: Int, refreshTrigger: Observable<Void>, nextPageTrigger: Observable<Void>) {
        self.id = id
        self.service = FeedServiceImpl()
        refreshTrigger.subscribe(onNext: { _ in
            self.shouldPaginate = true
            self.page = 1
            self.fetchFeed(refresh: true)
        }).addDisposableTo(disposeBag)
        nextPageTrigger.subscribe(onNext: { _ in
            self.fetchFeed()
        }).addDisposableTo(disposeBag)
    }
    
    func fetchFeed(refresh: Bool = false) {
        fetching.value = true
        service.fetchFeed(event: id, page: page).subscribe(onNext: { paginatedData in
            refresh ? self.feed.value = paginatedData.results : self.feed.value.append(contentsOf: paginatedData.results)
            if self.feed.value.count >= paginatedData.totalResults {
                self.shouldPaginate = false
            }
        }, onCompleted: {
            self.fetching.value = false
            self.page += 1
        }).addDisposableTo(disposeBag)
    }
    
}
