//
//  EventViewModel.swift
//  RaceHub
//
//  Created by Piotr Olejnik on 09.09.2017.
//  Copyright © 2017 gat. All rights reserved.
//

import Foundation
import CoreLocation
import RxCocoa
import RxSwift

protocol EventViewModel {
    var dateText: Variable<String> { get set }
    var name: Variable<String> { get set }
    var distanceString: Variable<String> { get set }
    func updateDistance(from location: CLLocation)
}

class EventViewModelImpl: EventViewModel {
    
    private let event: Event
    private let dateProvider: DateProvider = DateProviderImpl()
    
    var name = Variable<String>("")
    var dateText = Variable<String>("")
    var distanceString = Variable<String>("")
    
    init(event: Event) {
        self.event = event
        dateText.value = dateProvider.parse(event.date)
        name.value = event.name
    }
    
    func updateDistance(from location: CLLocation) {
        let distance = Int(event.location.distance(from: location) / 1000.0)
        distanceString.value = "distance_from_you".localized.format(parameters: distance)
    }

}
