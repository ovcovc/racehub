//
//  String+Truncate.swift
//  RaceHub
//
//  Created by Piotr Olejnik on 19.09.2017.
//  Copyright © 2017 gat. All rights reserved.
//

import Foundation

extension String {
    /**
     Truncates the string to the specified length number of characters and appends an optional trailing string if longer.
     
     - Parameter length: A `String`.
     - Parameter trailing: A `String` that will be appended after the truncation.
     
     - Returns: A `String` object.
     */
    func truncate(length: Int, trailing: String = "…") -> String {
        if self.characters.count > length {
            return String(self.characters.prefix(length)) + trailing
        } else {
            return self
        }
    }
    
}
