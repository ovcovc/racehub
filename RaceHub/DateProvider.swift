//
//  DateProvider.swift
//  RaceHub
//
//  Created by Piotr Olejnik on 09.09.2017.
//  Copyright © 2017 gat. All rights reserved.
//

import Foundation

protocol DateProvider {
    func now() -> Date
    func localCalendar() -> Calendar
    func parse(_ string: String?) -> Date
    func parse(_ date: Date) -> String
}

class DateProviderImpl: DateProvider {
    
    private struct Constants {
        static let utcTimezone = "Z"
    }
    
    //@formatter:off
    private let dateFormatters = [
        DateFormatterFactory.sharedInstance.ISOTimeAndDateFormatter,
        DateFormatterFactory.sharedInstance.ISOTimeAndDateFormatterT,
        DateFormatterFactory.sharedInstance.fullTimeFormatter
    ]
    //@formatter:on
    
    func now() -> Date {
        return Date()
    }
    
    func localCalendar() -> Calendar {
        return Calendar.localCalendar()
    }
    
    func parse(_ string: String?) -> Date {
        guard let string = string else {
            print("Can't parse a nil date string")
            return Date()
        }
        
        let dateString = string.hasSuffix(Constants.utcTimezone) ? string.substring(to: string.index(before: string.endIndex)) : string
        for dateFormatter in dateFormatters {
            if let aDate = dateFormatter.date(from: dateString) {
                return aDate
            }
        }
        
        print("String \"\(string)\" passed to a date parser is not a valid date")
        return Date() // as we have to return something (let's not crash the app on production)
    }
    
    func parse(_ date: Date) -> String {
        return DateFormatterFactory.sharedInstance.defaultEventDateFormatter.string(from: date)
    }
}
