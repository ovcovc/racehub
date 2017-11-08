//
//  SearchViewModel.swift
//  RaceHub
//
//  Created by Piotr Olejnik on 04.09.2017.
//  Copyright © 2017 gat. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift

protocol SearchViewModel {
    func search(for query: String) -> Observable<Void>
    var events: Variable<[Event]> { get set }
}

class SearchViewModelImpl: SearchViewModel {
    
    private let service = EventServiceImpl()
    var events = Variable<[Event]>([])
    private let disposeBag = DisposeBag()
    
    func search(for query: String) -> Observable<Void> {
        return Observable<Void>.create { observer in
            if query.replacingOccurrences(of: " ", with: "").isEmpty {
                self.events.value = []
                observer.onNext()
                observer.onCompleted()
            } else {
                self.service.events(for: query).subscribe(onNext: { events in
                    self.events.value = events
                    observer.onNext()
                }, onCompleted: {
                    observer.onCompleted()
                }).addDisposableTo(self.disposeBag)
            }
            return Disposables.create()
        }
    }
    
}
