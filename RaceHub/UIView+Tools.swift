//
//  UIView+Tools.swift
//  RaceHub
//
//  Created by Piotr Olejnik on 09.09.2017.
//  Copyright © 2017 gat. All rights reserved.
//

import UIKit

extension UIView {
    
    func dropShadow() {
        
        self.layer.masksToBounds =  false
        self.layer.shadowOpacity = 0.4
        self.layer.shadowRadius = 2
        self.layer.cornerRadius = 4
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOffset = CGSize(width: 0, height: 1)
        
    }
}
