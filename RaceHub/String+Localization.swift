//
//  String+Localization.swift
//  RaceHub
//
//  Created by Piotr Olejnik on 09.09.2017.
//  Copyright © 2017 gat. All rights reserved.
//

import Foundation

extension String {
    var localized: String {
        return NSLocalizedString(self, tableName: nil, bundle: Bundle.main, value: "", comment: "")
    }
    
    func format(parameters: CVarArg...) -> String {
        return String(format: self, arguments: parameters)
    }
    
}
