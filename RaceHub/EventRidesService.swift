//
//  EventRidesService.swift
//  RaceHub
//
//  Created by Piotr Olejnik on 05.11.2017.
//  Copyright © 2017 gat. All rights reserved.
//

import RxSwift

struct EventRidesService {
    
    func fetchRides(event: Int, page: Int) -> Observable<PaginatedList<Ride>> {
        return testData(page: page)
    }
    
    private func testData(page: Int) -> Observable<PaginatedList<Ride>> {
        return Observable<PaginatedList<Ride>>.create { observer in
            Utilities.delayWithSeconds(2.0, completion: {
                var testData = [Ride]()
                for _ in 0...10 {
                    let entry = Ride(from: "Początek", to: "Koniec", added: Date(), date: Date(), price: 100.4, dateReturn: Date(), user: "Rysio", userAvatar: nil, userId: 1)
                    testData.append(entry)
                }
                let paginatedData = PaginatedList(page: page, totalResults: 100, totalPages: 5, results: testData)
                print("fetched page \(page)")
                observer.onNext(paginatedData)
                observer.onCompleted()
            })
            return Disposables.create()
        }
    }
}
