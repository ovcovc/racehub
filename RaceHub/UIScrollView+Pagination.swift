//
//  UIScrollView+Pagination.swift
//  RaceHub
//
//  Created by Piotr Olejnik on 18.09.2017.
//  Copyright © 2017 gat. All rights reserved.
//

import UIKit

extension UIScrollView {
    func  isNearBottomEdge(edgeOffset: CGFloat = 20.0) -> Bool {
        return self.contentOffset.y + self.frame.size.height + edgeOffset > self.contentSize.height
    }
}
