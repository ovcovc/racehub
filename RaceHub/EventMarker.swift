//
//  EventMarker.swift
//  RaceHub
//
//  Created by Piotr Olejnik on 07.09.2017.
//  Copyright © 2017 gat. All rights reserved.
//

import Foundation
import GoogleMaps

class EventMarker: GMSMarker {
    
    var event: Event
    
    init(event: Event, imageProvider: CommonImageProvider) {
        self.event = event
        super.init()
        self.position = CLLocationCoordinate2D(latitude: event.latitude, longitude: event.longitude)
        switch event.type {
        case .bike:
            self.icon = imageProvider.bikeIcon
        case .run:
            self.icon = imageProvider.runIcon
        case .multisport:
            self.icon = imageProvider.multisportIcon
        }
        
    }
    
}
