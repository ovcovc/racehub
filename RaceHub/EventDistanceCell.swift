//
//  EventDistanceCell.swift
//  RaceHub
//
//  Created by Piotr Olejnik on 15.09.2017.
//  Copyright © 2017 gat. All rights reserved.
//

import UIKit

class EventDistanceCell: UITableViewCell {
    
    @IBOutlet weak var gradientView: UIView!
    @IBOutlet weak var bgImage: UIImageView!
    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var limitLabel: UILabel!
    @IBOutlet weak var attendButton: UIButton!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    
    private enum Constants {
        static let attendCornerRadius = CGFloat(12.5)
        static let mainViewCornerRadius = CGFloat(10.0)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        attendButton.layer.cornerRadius = Constants.attendCornerRadius
        attendButton.clipsToBounds = true
        bgView.layer.cornerRadius = Constants.mainViewCornerRadius
        bgView.clipsToBounds = true
        gradientView.layer.cornerRadius = Constants.mainViewCornerRadius
        gradientView.clipsToBounds = true
        bgImage.layer.cornerRadius = Constants.mainViewCornerRadius
        bgImage.clipsToBounds = true
        bgView.dropShadow()
    }
    
    
}
