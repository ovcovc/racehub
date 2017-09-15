//
//  FiltersViewController.swift
//  RaceHub
//
//  Created by Piotr Olejnik on 10.09.2017.
//  Copyright © 2017 gat. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class FilterViewController: UIViewController, Translatable {
    
    @IBOutlet weak var switchView: UIView!
    @IBOutlet weak var fromView: UIView!
    @IBOutlet weak var toView: UIView!
    
    @IBOutlet weak var toPicker: UIDatePicker!
    @IBOutlet weak var toLabel: UILabel!
    @IBOutlet weak var fromPicker: UIDatePicker!
    @IBOutlet weak var fromLabel: UILabel!
    @IBOutlet weak var multisportSwitch: UISwitch!
    @IBOutlet weak var multisportLabel: UILabel!
    @IBOutlet weak var bikeSwitch: UISwitch!
    @IBOutlet weak var bikeLabel: UILabel!
    @IBOutlet weak var runSwitch: UISwitch!
    @IBOutlet weak var runLabel: UILabel!
    @IBOutlet weak var navItem: UINavigationItem!
    
    private let disposeBag = DisposeBag()
    var filter: Variable<Filter>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        applyTranslations()
        setUI()
        setupRx()
    }
    
    private func setUI() {
        switchView.dropShadow()
        fromView.dropShadow()
        toView.dropShadow()
        runSwitch.setOn(filter.value.run, animated: false)
        bikeSwitch.setOn(filter.value.bike, animated: false)
        multisportSwitch.setOn(filter.value.multisport, animated: false)
        fromPicker.setDate(filter.value.from, animated: false)
        toPicker.setDate(filter.value.to, animated: false)
    }
    
    private func setupRx() {
        fromPicker.rx.date.subscribe(onNext: { [unowned self] date in
            guard date <= self.toPicker.date else {
                self.fromPicker.setDate(self.toPicker.date, animated: true)
                return
            }
        }).addDisposableTo(disposeBag)
        toPicker.rx.date.subscribe(onNext: { [unowned self] date in
            guard date >= self.fromPicker.date else {
                self.toPicker.setDate(self.fromPicker.date, animated: true)
                return
            }
        }).addDisposableTo(disposeBag)
    }
    
    func applyTranslations() {
        navItem.title = "filters_title_label".localized
        runLabel.text = "run_events".localized
        bikeLabel.text = "bike_events".localized
        multisportLabel.text = "multisport_events".localized
        fromLabel.text = "from_label".localized
        toLabel.text = "to_label".localized
    }

    // MARK: Action methods
    
    @IBAction func didTapSave(_ sender: Any) {
        filter.value = Filter(run: runSwitch.isOn, bike: bikeSwitch.isOn, multisport: multisportSwitch.isOn, from: fromPicker.date, to: toPicker.date)
        dismiss(animated: true)
    }
    
    @IBAction func didTapClose(_ sender: Any) {
        dismiss(animated: true)
    }
    
}
