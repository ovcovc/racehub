//
//  EventViewModel.swift
//  RaceHub
//
//  Created by Piotr Olejnik on 09.09.2017.
//  Copyright © 2017 gat. All rights reserved.
//

import Foundation
import CoreLocation

protocol EventViewModel {
    func name() -> String
    func dateText() -> String
    func distance(from currentLocation: CLLocation) -> String
}

class EventViewModelImpl: EventViewModel {
    
    private let event: Event
    private let dateProvider: DateProvider = DateProviderImpl()
    
    init(event: Event) {
        self.event = event
    }
    
    func name() -> String {
        return event.name
    }
    
    func dateText() -> String {
        return dateProvider.parse(event.date)
    }
    
    func distance(from currentLocation: CLLocation) -> String {
        let distance = Int(event.location.distance(from: currentLocation) / 1000.0)
        return "distance_from_you".localized.format(parameters: distance)
    }
    
}
