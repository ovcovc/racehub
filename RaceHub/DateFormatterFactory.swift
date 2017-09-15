//
//  DateFormatterFactory.swift
//  RaceHub
//
//  Created by Piotr Olejnik on 09.09.2017.
//  Copyright © 2017 gat. All rights reserved.
//

import Foundation

enum DateFormatterLocale {
    case current
    case en
}

enum DateFormatterTimeZone {
    case local
    case utc
}

enum DateFormatterTemplate: String {
    // date
    case defaultDate = "dd/MM/yyyy"
    case noYearDate = "dd.MM."
    case midStyleDate = "EEEE, MMM d"
    case midStyleWithYearDate = "E, MMM d yyyy"
    
    // time
    case localTime = "j:mm"
    case defaultTime = "HH:mm"
    case defaultWithSecondsTime = "HH:mm:ss"
    case weekday = "EEEE"
    
    // date and time
    case fullMonthDateTime = "MMMM dd, j:mm"
    case isoTDateTime = "yyyy-MM-dd'T'HH:mm:ss"
    case isoDateTime = "yyyy-MM-dd HH:mm:ss"
    case isoNoSecondsDateTime = "yyyy-MM-dd HH:mm"
    
    // event
    case dateTimeAndDayNoYear = "EEEE, d MMM, HH:mm"
    case dateTimeAndDayYear = "EEEE, d MMM yyyy, HH:mm"
}

extension DateFormatter {
    convenience init(dateStyle: DateFormatter.Style, timeStyle: DateFormatter.Style, locale: DateFormatterLocale, timeZone: DateFormatterTimeZone) {
        self.init()
        self.dateStyle = dateStyle
        self.timeStyle = timeStyle
        setup(locale: locale, timeZone: timeZone)
    }
    
    convenience init(dateFormat: DateFormatterTemplate, locale: DateFormatterLocale, timeZone: DateFormatterTimeZone) {
        self.init()
        setup(locale: locale, timeZone: timeZone)
        self.dateFormat = dateFormat.rawValue
    }
    
    convenience init(template: DateFormatterTemplate, locale: DateFormatterLocale, timeZone: DateFormatterTimeZone) {
        self.init()
        setup(locale: locale, timeZone: timeZone)
        dateFormat = DateFormatter.dateFormat(fromTemplate: template.rawValue, options: 0, locale: self.locale)
    }
    
    private func setup(locale: DateFormatterLocale, timeZone: DateFormatterTimeZone) {
        switch locale {
        case .current: self.locale = .current
        case .en: self.locale = Locale(identifier: "en_US_POSIX")
        }
        switch timeZone {
        case .local:
            self.timeZone = .current
            calendar = Calendar.localCalendar()
        case .utc:
            self.timeZone = TimeZone(identifier: "UTC")
            calendar = Calendar.utcCalendar()
        }
    }
}

@objc
class DateFormatterFactory: NSObject {
    
    static let sharedInstance: DateFormatterFactory = DateFormatterFactory()
    
    lazy var defaultDateFormatter: DateFormatter = {
        return DateFormatter(template: .defaultDate, locale: .current, timeZone: .utc)
    }()
    
    lazy var localDefaultDateFormatter: DateFormatter = {
        return DateFormatter(template: .defaultDate, locale: .current, timeZone: .local)
    }()
    
    lazy var localTimeAndDateFormatter: DateFormatter = {
        return DateFormatter(template: .fullMonthDateTime, locale: .current, timeZone: .local)
    }()
    
    lazy var localDateWithoutYearMidStyleFormatter: DateFormatter = {
        return DateFormatter(template: .midStyleDate, locale: .current, timeZone: .utc)
    }()
    
    lazy var localDateWithYearMidStyleFormatter: DateFormatter = {
        return DateFormatter(template: .midStyleWithYearDate, locale: .current, timeZone: .utc)
    }()
    
    lazy var shortStyleTimeFormatter: DateFormatter = {
        return DateFormatter(dateStyle: .none, timeStyle: .short, locale: .current, timeZone: .utc)
    }()
    
    lazy var localShortStyleTimeFormatter: DateFormatter = {
        return DateFormatter(dateStyle: .none, timeStyle: .short, locale: .current, timeZone: .local)
    }()
    
    lazy var mediumRelativeDateFormatter: DateFormatter = {
        let formatter = DateFormatter(dateStyle: .medium, timeStyle: .none, locale: .current, timeZone: .utc)
        formatter.doesRelativeDateFormatting = true
        return formatter
    }()
    
    lazy var localMediumRelativeDateFormatter: DateFormatter = {
        let formatter = DateFormatter(dateStyle: .medium, timeStyle: .none, locale: .current, timeZone: .local)
        formatter.doesRelativeDateFormatting = true
        return formatter
    }()
    
    lazy var dayOfWeekFormatter: DateFormatter = {
        return DateFormatter(template: .weekday, locale: .current, timeZone: .utc)
    }()
    
    lazy var localDayOfWeekFormatter: DateFormatter = {
        return DateFormatter(template: .weekday, locale: .current, timeZone: .local)
    }()
    
    lazy var defaultAMPMTimeFormatter: DateFormatter = {
        return DateFormatter(template: .localTime, locale: .current, timeZone: .utc)
    }()
    
    lazy var shortDateFormatter: DateFormatter = {
        return DateFormatter(dateFormat: .noYearDate, locale: .current, timeZone: .utc)
    }()
    
    lazy var defaultTimeFormatter: DateFormatter = {
        return DateFormatter(dateFormat: .defaultTime, locale: .en, timeZone: .utc)
    }()
    
    lazy var fullTimeFormatter: DateFormatter = {
        return DateFormatter(dateFormat: .defaultWithSecondsTime, locale: .en, timeZone: .utc)
    }()
    
    lazy var ISOTimeAndDateFormatterT: DateFormatter = {
        return DateFormatter(dateFormat: .isoTDateTime, locale: .en, timeZone: .utc)
    }()
    
    lazy var ISOTimeAndDateFormatter: DateFormatter = {
        return DateFormatter(dateFormat: .isoDateTime, locale: .en, timeZone: .utc)
    }()
    
    lazy var ISOTimeAndDateFormatterNoSeconds: DateFormatter = {
        return DateFormatter(dateFormat: .isoNoSecondsDateTime, locale: .en, timeZone: .utc)
    }()
    
    lazy var defaultEventDateFormatter: DateFormatter = {
        return DateFormatter(dateFormat: .dateTimeAndDayNoYear, locale: .current, timeZone: .local)
    }()
    
    private override init() {
    }
}
