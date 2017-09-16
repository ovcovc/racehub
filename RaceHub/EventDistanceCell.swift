//
//  EventDistanceCell.swift
//  RaceHub
//
//  Created by Piotr Olejnik on 15.09.2017.
//  Copyright © 2017 gat. All rights reserved.
//

import UIKit

class EventDistanceCell: UITableViewCell {
    
    @IBOutlet weak var limitLabel: UILabel!
    @IBOutlet weak var attendButton: UIButton!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        attendButton.layer.cornerRadius = 12.5
        attendButton.clipsToBounds = true
    }
    
    
}
