//
//  DrawerViewController.swift
//  RaceHub
//
//  Created by Piotr Olejnik on 07.09.2017.
//  Copyright © 2017 gat. All rights reserved.
//

import UIKit
import RxGesture
import RxSwift
import RxCocoa
import CoreLocation

class DrawerViewController: UIViewController {
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var moreLabel: UILabel!
    @IBOutlet weak var moreButton: UIButton!
    @IBOutlet weak var infoLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var logoImageView: UIImageView!
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var blurView: UIVisualEffectView!
    
    private let disposeBag = DisposeBag()
    private var event: Event? {
        didSet {
            eventViewModel = EventViewModelImpl(event: event!)
        }
    }
    private var eventViewModel: EventViewModel? {
        didSet {
            updateLabels()
        }
    }
    
    var currentLocation: CLLocation? {
        didSet {
            updateLabels()
        }
    }
    
    var closeAction: (() -> Void)?
    
    private struct Constants {
        static let cornerRadius = CGFloat(15.0)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        setupRx()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let id = segue.identifier else {
            return super.prepare(for: segue, sender: sender)
        }
        switch id {
        case Segues.toEventViewController:
            guard let event = event else {
                return
            }
            let destination = segue.destination as! EventDetailsViewController
            destination.eventId = event.id
            destination.eventName = event.name
        default:
            super.prepare(for: segue, sender: sender)
        }
    }
    
    private func setupRx() {
        closeButton.rx.tapGesture().when(.recognized).subscribe(onNext: { [unowned self] _ in
            self.closeAction?()
        }).disposed(by: disposeBag)
        moreButton.rx.tapGesture().when(.recognized).subscribe(onNext: { [unowned self] _ in
            self.performSegue(withIdentifier: Segues.toEventViewController, sender: self)
        }).disposed(by: disposeBag)
    }
    
    private func updateLabels() {
        guard let eventViewModel = eventViewModel else {
            titleLabel.text = ""
            infoLabel.text = ""
            return
        }
        titleLabel.text = eventViewModel.name()
        let distance = (currentLocation != nil) ? eventViewModel.distance(from: currentLocation!) : ""
        infoLabel.text = "\(eventViewModel.dateText())\n\(distance)"
    }
    
    private func setUI() {
        let blurEffect = UIBlurEffect(style: .extraLight)
        blurView.effect = blurEffect
        containerView.layer.cornerRadius = Constants.cornerRadius
        containerView.clipsToBounds = true
    }
    
    func update(location: CLLocation) {
        self.currentLocation = location
    }
    
    func display(_ event: Event) {
        self.event = event
    }
    
}
