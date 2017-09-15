//
//  MapViewModel.swift
//  RaceHub
//
//  Created by Piotr Olejnik on 29.08.2017.
//  Copyright © 2017 gat. All rights reserved.
//

import Foundation
import CoreLocation
import RxCocoa
import RxSwift

protocol MapViewModel {
    func events(within radius: Double, from location: CLLocation, with types: [EventType], from: Date, to: Date)
}

class MapViewModelImpl: MapViewModel {
    
    private let service = EventServiceImpl()
    var events = Variable<[Event]>([])
    private let disposeBag = DisposeBag()
    
    func events(within radius: Double, from location: CLLocation, with types: [EventType], from: Date, to: Date) {
        service.events(within: radius, from: location, with: types, from: from, to: to).subscribe(onNext: { events in
            self.events.value = events
        }).addDisposableTo(disposeBag)
    }

}
