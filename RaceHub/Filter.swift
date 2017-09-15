//
//  Filter.swift
//  RaceHub
//
//  Created by Piotr Olejnik on 10.09.2017.
//  Copyright © 2017 gat. All rights reserved.
//

import Foundation

class Filter {
    
    var run: Bool
    var bike: Bool
    var multisport: Bool
    var from: Date
    var to: Date
    
    init() {
        run = true
        bike = true
        multisport = true
        from = Date()
        let calendar = Calendar.current
        to = calendar.date(byAdding: .month, value: 2, to: Date())!
    }
    
    init(run: Bool, bike: Bool, multisport: Bool, from: Date, to: Date) {
        self.run = run
        self.bike = bike
        self.multisport = multisport
        self.from = from
        self.to = to
    }
    
    func selectedTypes() -> [EventType] {
        var sports = [EventType]()
        if run {
            sports.append(.run)
        }
        if bike {
            sports.append(.bike)
        }
        if multisport {
            sports.append(.multisport)
        }
        return sports
    }
    
}
