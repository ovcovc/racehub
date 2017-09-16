//
//  EventDistanceViewModel.swift
//  RaceHub
//
//  Created by Piotr Olejnik on 16.09.2017.
//  Copyright © 2017 gat. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

protocol EventDistanceViewModel {
    var distanceString: Variable<String> { get set }
    var dateString: Variable<String> { get set }
    var limitString: Variable<String> { get set }
    var nameString: Variable<String> { get set }
}

class EventDistanceViewModelImpl: EventDistanceViewModel {
    
    var distanceString = Variable<String>("")
    var dateString = Variable<String>("")
    var limitString = Variable<String>("")
    var nameString = Variable<String>("")
    private let distance: RaceDistance
    private let dateProvider = DateProviderImpl()
    
    init(distance: RaceDistance) {
        self.distance = distance
        distanceString.value = distance.distanceString()
        dateString.value =  dateProvider.parse(distance.startDate)
        nameString.value = distance.name
        limitString.value = "\("time_limit".localized): \(distance.limitString())"
    }
    
}
