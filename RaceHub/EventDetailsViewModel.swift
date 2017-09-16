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
    var distanceString: Variable<String> { get set }
    var placeAndDate: Variable<String> { get set }
    var dateString: Variable<String> { get set}
    var fetching: Variable<Bool> { get set }
    var distanceArray: Variable<[RaceDistance]> { get set }
}

class EventDetailsViewModelImpl: EventDetailsViewModel {
    
    private let service = EventServiceImpl()
    private let disposeBag = DisposeBag()
    private var eventId: Int
    private let dateProvider = DateProviderImpl()
    
    var eventDescription = Variable<String>("")
    var imageUrl = Variable<String>("")
    var name = Variable<String>("")
    var distanceString = Variable<String>("")
    var placeAndDate = Variable<String>("")
    var fetching = Variable<Bool>(false)
    var distanceArray = Variable<[RaceDistance]>([])
    var dateString = Variable<String>("")
    
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
            self.distanceArray.value = Array(details.distances)
            let distanceArray = Array(details.distances).map({ $0.distanceString() })
            self.distanceString.value = distanceArray.joined(separator: " / ")
            self.dateString.value = self.dateProvider.parse(details.date)
            self.placeAndDate.value = "\(details.city)\n\(self.dateProvider.parse(details.date))"
        }).addDisposableTo(self.disposeBag)
    }
    
}
