//
//  Event.swift
//  RaceHub
//
//  Created by Piotr Olejnik on 29.08.2017.
//  Copyright © 2017 gat. All rights reserved.
//

import Foundation
import RealmSwift
import CoreLocation

@objc enum EventType: Int {
    case run
    case bike
    case multisport
}

class Event: Object {
    
    dynamic var id = -1
    dynamic var name = ""
    dynamic var date = Date()
    dynamic var latitude = 0.0
    dynamic var longitude = 0.0
    dynamic var type = EventType.run
    dynamic var updatedAt = Date()
    
    var location: CLLocation {
        return CLLocation(latitude: self.latitude, longitude: self.longitude)
    }
    
    func distance(from location: CLLocation) -> Double {
        return self.location.distance(from: location)
    }
    
}

class EventDetails: Object {
    dynamic var id = -1
    dynamic var eventId = -1
    dynamic var image = ""
    dynamic var city = ""
    dynamic var name = ""
    dynamic var desc = ""
    dynamic var date = Date()
    dynamic var updatedAt = Date()
    var distances = List<RaceDistance>()
}

// ALL DISTANCES IN METERS
class RaceDistance: Object {
    dynamic var desc = ""
    dynamic var id = -1
    dynamic var name = ""
    dynamic var startDate = Date()
    dynamic var distance = -1.0
    dynamic var hourLimit = -1.0
    dynamic var rules = ""
    
    func distanceString() -> String {
        return distance < 1000 ? "\(distance)m" : "\(Int(distance/1000))km"
    }
    
    func limitString() -> String {
        let hourAndMinutes = hoursToHoursMinutes(hours: hourLimit)
        if hourAndMinutes.0 == 0 {
            return "\(hourAndMinutes.1)\("minutes_short".localized)"
        } else if hourAndMinutes.1 == 0 {
            return "\(hourAndMinutes.0)\("hours_short".localized)"
        } else {
            return "\(hourAndMinutes.0)\("hours_short".localized) \(hourAndMinutes.1)\("minutes_short".localized)"
        }
    }
    
    private func hoursToHoursMinutes(hours : Double) -> (Int, Int) {
        return (Int(hours), Int(hours.truncatingRemainder(dividingBy: 1.0) * 60))
    }
    
    
}
