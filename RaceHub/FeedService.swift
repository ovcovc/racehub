//
//  FeedService.swift
//  RaceHub
//
//  Created by Piotr Olejnik on 19.09.2017.
//  Copyright © 2017 gat. All rights reserved.
//

import RxSwift
import RxCocoa

protocol FeedService {
    func fetchFeed(event: Int, page: Int) -> Observable<PaginatedList<FeedEntry>>
    func fetchSubscribedFeed(page: Int) -> Observable<PaginatedList<FeedEntry>> 
}

struct FeedServiceImpl: FeedService {

    func fetchFeed(event: Int, page: Int) -> Observable<PaginatedList<FeedEntry>> {
        return testData(page: page)
    }
    
    func fetchSubscribedFeed(page: Int) -> Observable<PaginatedList<FeedEntry>> {
        return testData(page: page)
    }
    
    private func testData(page: Int) -> Observable<PaginatedList<FeedEntry>> {
        return Observable<PaginatedList<FeedEntry>>.create { observer in
            Utilities.delayWithSeconds(2.0, completion: {
                var testData = [FeedEntry]()
                for _ in 0...10 {
                    let entry = FeedEntry()
                    entry.content = Utilities.randomString(length: Utilities.randRange(lower: 100, upper: 600))
                    entry.imageUrl = "https://greatist.com/sites/default/files/running_2.jpg"
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
