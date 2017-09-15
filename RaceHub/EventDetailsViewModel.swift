//
//  EventDetailsViewModel.swift
//  RaceHub
//
//  Created by Piotr Olejnik on 14.09.2017.
//  Copyright © 2017 gat. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

protocol EventDetailsViewModel {
    func fetchDetails()
    var imageUrl: Variable<String> { get set }
    var eventDescription: Variable<String> { get set }
    var name: Variable<String> { get set }
    var distances: Variable<String> { get set }
    var placeAndDate: Variable<String> { get set }
    var fetching: Variable<Bool> { get set }
}

class EventDetailsViewModelImpl: EventDetailsViewModel {
    
    private let service = EventServiceImpl()
    private let disposeBag = DisposeBag()
    private var eventId: Int
    private let dateProvider = DateProviderImpl()
    
    var eventDescription = Variable<String>("")
    var imageUrl = Variable<String>("")
    var name = Variable<String>("")
    var distances = Variable<String>("")
    var placeAndDate = Variable<String>("")
    var fetching = Variable<Bool>(false)
    
    init(eventId: Int) {
        self.eventId = eventId
        fetchDetails()
    }
    
    func fetchDetails() {
        fetching.value = true
        service.eventDetails(with: self.eventId).subscribe(onNext: { [unowned self] details in
            self.fetching.value = false
            self.eventDescription.value = details.desc
            self.imageUrl.value = details.image
            self.name.value = details.name
            let distanceArray = Array(details.distances).map({ $0.distanceString() })
            self.distances.value = distanceArray.joined(separator: " / ")
            self.placeAndDate.value = "\(details.city)\n\(self.dateProvider.parse(details.date))"
        }).addDisposableTo(self.disposeBag)
    }
    
}
