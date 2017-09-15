//
//  Calendar+Tools.swift
//  RaceHub
//
//  Created by Piotr Olejnik on 09.09.2017.
//  Copyright © 2017 gat. All rights reserved.
//

import Foundation

private var utcDefaultCalendar: Calendar = {
    var calendar = Calendar(identifier: Calendar.Identifier.gregorian)
    calendar.timeZone = TimeZone(identifier: "UTC")!
    return calendar
}()

private var localDefaultCalendar: Calendar = {
    var localCalendar = Calendar(identifier: Calendar.Identifier.gregorian)
    localCalendar.timeZone = TimeZone.current
    return localCalendar
}()

extension Calendar {
    
    static func utcCalendar() -> Calendar {
        return utcDefaultCalendar
    }
    
    static func localCalendar() -> Calendar {
        return localDefaultCalendar
    }
    
    func dateComponents(from date: Date) -> DateComponents {
        let flags: NSCalendar.Unit = [.year, .month, .day]
        return (self as NSCalendar).components(flags, from: date)
    }
    
    func timeComponents(from date: Date) -> DateComponents {
        let flags: NSCalendar.Unit = [.hour, .minute, .second]
        return (self as NSCalendar).components(flags, from: date)
    }
    
    func dateAndTimeComponents(from date: Date) -> DateComponents {
        let flags: NSCalendar.Unit = [.year, .month, .day, .hour, .minute]
        
        return (self as NSCalendar).components(flags, from: date)
    }
}
