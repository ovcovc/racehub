//
//  Translatable.swift
//  RaceHub
//
//  Created by Piotr Olejnik on 12.09.2017.
//  Copyright © 2017 gat. All rights reserved.
//

import UIKit

protocol Translatable: class {
    func applyTranslations()
}

extension Translatable where Self: UIViewController {
}
