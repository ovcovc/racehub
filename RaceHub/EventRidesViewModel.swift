//
//  EventRidesViewModel.swift
//  RaceHub
//
//  Created by Piotr Olejnik on 05.11.2017.
//  Copyright © 2017 gat. All rights reserved.
//

import RxSwift

class EventRidesViewModel {
    
    var rides = Variable<[Ride]>([])
    var fetching = Variable<Bool>(false)
    private let eventId: Int
    private let service: EventRidesService
    private var page = 1
    private var shouldPaginate = true
    private let disposeBag = DisposeBag()
    
    init(id: Int, refreshTrigger: Observable<Void>, nextPageTrigger: Observable<Void>) {
        self.eventId = id
        self.service = EventRidesService()
        refreshTrigger.subscribe(onNext: { [unowned self] _ in
            self.shouldPaginate = true
            self.page = 1
            self.fetchFeed(refresh: true)
        }).addDisposableTo(disposeBag)
        nextPageTrigger.subscribe(onNext: { [unowned self] _ in
            self.fetchFeed()
        }).addDisposableTo(disposeBag)
    }
    
    
    func search(for: String) {
        // TODO implement
    }
    
    private func fetchFeed(refresh: Bool = false) {
        fetching.value = true
        service.fetchRides(event: eventId, page: page).subscribe(onNext: { paginatedData in
            refresh ? self.rides.value = paginatedData.results : self.rides.value.append(contentsOf: paginatedData.results)
            if self.rides.value.count >= paginatedData.totalResults {
                self.shouldPaginate = false
            }
        }, onCompleted: {
            self.fetching.value = false
            self.page += 1
        }).addDisposableTo(disposeBag)
    }
    
}
