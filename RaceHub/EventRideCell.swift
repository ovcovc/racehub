//
//  EventRideCell.swift
//  RaceHub
//
//  Created by Piotr Olejnik on 05.11.2017.
//  Copyright © 2017 gat. All rights reserved.
//

import UIKit
import RxSwift

class EventRideCell: UITableViewCell {
    
    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var addedLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var returnAtLabel: UILabel!
    @IBOutlet weak var departAtLabel: UILabel!
    @IBOutlet weak var reserveButton: UIButton!
    @IBOutlet weak var destinationLabel: UILabel!
    
    let ride = Variable<Ride?>(nil)
    private let disposeBag = DisposeBag()
    private let dateProvider = DateProviderImpl()
    
    private enum Constants {
        static let mainViewCornerRadius = CGFloat(10.0)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        bgView.layer.cornerRadius = Constants.mainViewCornerRadius
        bgView.clipsToBounds = true
        bgView.dropShadow()
        
        ride.asObservable().flatMap { ride -> Observable<Ride> in
                if let ride = ride {
                    return Observable.just(ride)
                }
                return Observable.empty()
            }
            .subscribe(
                onNext: { [unowned self] ride in
                    self.nameLabel.text = ride.user
                    self.addedLabel.text = self.dateProvider.parse(ride.added)
                    if let dateReturn = ride.dateReturn {
                        self.returnAtLabel.text = self.dateProvider.parse(dateReturn)
                        self.returnAtLabel.isHidden = false
                    } else {
                        self.returnAtLabel.isHidden = true
                    }
                    self.departAtLabel.text = self.dateProvider.parse(ride.date)
                    self.destinationLabel.text = ride.to
                }
            )
            .addDisposableTo(disposeBag)
        
        reserveButton.rx.tap
            .subscribe(
                onNext: { print("Reserve") }
            ).addDisposableTo(disposeBag)
    }
    
}
