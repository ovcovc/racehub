//
//  MapViewController.swift
//  RaceHub
//
//  Created by Piotr Olejnik on 29.08.2017.
//  Copyright © 2017 gat. All rights reserved.
//

import UIKit
import GoogleMaps
import RxSwift
import RxCocoa
import RxGesture

class MapViewController: UIViewController {
    
    @IBOutlet weak var mapView: GMSMapView!
    @IBOutlet weak var drawerView: UIView!
    @IBOutlet weak var bottomDrawerConstraint: NSLayoutConstraint!
    
    private let viewModel = MapViewModelImpl()
    private let disposeBag = DisposeBag()
    private let imageProvider = CommonImageProvider()
    private var drawnMarkers = [EventMarker]()
    private var drawerViewController: DrawerViewController!
    private var filter = Variable<Filter>(Filter())
    
    private struct Constants {
        static let locationObserverKey = "myLocation"
        static let accuracyThreshold = 1001.0
        static let minZoom: Float = 6.0
        static let maxZoom: Float = 16.0
        static let defaultZoom: Float = 8.0
        static let searchZoom: Float = 10.0
        static let drawerAnimationDuration = 0.25
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        setupMapView()
        setupRx()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let segueId = segue.identifier else {
            return super.prepare(for: segue, sender: sender)
        }
        switch segueId {
        case Segues.toSearchViewController:
            let searchViewController = segue.destination as! SearchViewController
            searchViewController.delegate = self
        case Segues.toDrawerViewController:
            drawerViewController = segue.destination as! DrawerViewController
            drawerViewController.closeAction = {
                self.dismissDrawer()
            }
        case Segues.toFiltersViewController:
            let filterViewController = segue.destination as! FilterViewController
            filterViewController.filter = filter
        default:
            super.prepare(for: segue, sender: sender)
        }
    }
    
    private func setUI() {
        let logo = UIImage(named: "LogoSmall")
        let imageView = UIImageView(image: logo)
        imageView.contentMode = .scaleAspectFit // set imageview's content mode
        self.navigationItem.titleView = imageView
        bottomDrawerConstraint.constant = -drawerView.bounds.height
        view.layoutIfNeeded()
    }
    
    private func setupMapView() {
        mapView.mapType = .terrain
        mapView.isMyLocationEnabled = true
        mapView.settings.compassButton = true
        mapView.settings.myLocationButton = true
        mapView.setMinZoom(Constants.minZoom, maxZoom: Constants.maxZoom)
    }
    
    private func setupRx() {
        filter.asObservable().subscribe(onNext: { [unowned self] filter in
            let location = CLLocation(latitude: self.mapView.camera.target.latitude, longitude: self.mapView.camera.target.longitude)
            self.findEvents(for: location, with: filter)
        }).addDisposableTo(disposeBag)
        mapView.rx.idleAtLocation.subscribe(onNext: { [unowned self] location in
            self.findEvents(for: location, with: self.filter.value)
        }).addDisposableTo(disposeBag)
        mapView.rx.observe(CLLocation.self, Constants.locationObserverKey).filter({ $0 != nil}).filter({ $0!.horizontalAccuracy < Constants.accuracyThreshold }).take(1).subscribe(onNext: { [unowned self] location in
            guard let location = location else {
                return
            }
            self.move(to: location)
            self.drawerViewController.update(location: location)
        }).addDisposableTo(disposeBag)
        viewModel.events.asObservable().bind(onNext: { [unowned self] events in
            self.generateMarkers(from: events)
        }).addDisposableTo(disposeBag)
        drawerView.rx.swipeGesture(.down).when(.recognized).subscribe(onNext: { [unowned self] _ in
            self.dismissDrawer()
        }).disposed(by: disposeBag)
        mapView.rx.didTapMarker.subscribe(onNext: { [unowned self] marker in
            guard let marker = marker as? EventMarker else {
                return
            }
            self.showInformation(for: marker.event)
            self.openDrawer()
        }).addDisposableTo(disposeBag)
    }
    
    // MARK: Searching methods 
    
    func findEvents(for location: CLLocation, with filter: Filter) {
        let radius = self.mapView.getRadius()
        self.viewModel.events(within: radius, from: location, with: filter.selectedTypes(), from: filter.from, to: filter.to)
    }
    
    // MARK: Marker handling methods
    
    private func generateMarkers(from events: [Event]) {
        events.forEach { event in
            if !drawnMarkers.map({ $0.event.id }).contains(event.id) {
                let marker = EventMarker(event: event, imageProvider: imageProvider)
                marker.map = self.mapView
                drawnMarkers.append(marker)
            }
        }
        var indices = [Int]()
        for (index, marker) in drawnMarkers.enumerated() {
            if !events.map({ $0.id }).contains(marker.event.id) {
                marker.map = nil
                indices.append(index)
            }
        }
        for index in indices.sorted(by: { $0 > $1 }) {
            drawnMarkers.remove(at: index)
        }
    }
    
    // MARK: Drawer handling methods
    
    private func populateDrawer(with event: Event) {
        drawerViewController.display(event)
    }
    
    private func openDrawer() {
        animate({
            bottomDrawerConstraint.constant = 0
        }, withDuration: Constants.drawerAnimationDuration)
    }
    
    private func dismissDrawer() {
        animate({ 
            bottomDrawerConstraint.constant = -drawerView.bounds.height
        }, withDuration: Constants.drawerAnimationDuration)
    }
    
    private func animate(_ action: () -> Void, withDuration duration: Double) {
        action()
        UIView.animate(withDuration: duration) {
            self.view.layoutIfNeeded()
        }
    }
    
    fileprivate func showInformation(for event: Event, search: Bool = false) {
        openDrawer()
        populateDrawer(with: event)
        if search {
            move(to: event.location, zoom: Constants.searchZoom)
        }
    }
    
    // MARK: Actions methods
    
    @IBAction func filterTapped(_ sender: Any) {
        performSegue(withIdentifier: Segues.toFiltersViewController, sender: nil)

    }
    
    @IBAction func searchTapped(_ sender: Any) {
        performSegue(withIdentifier: Segues.toSearchViewController, sender: nil)
    }
    
    // MARK: Location handling methods
    
    func move(to location: CLLocation, zoom: Float = Constants.defaultZoom) {
        mapView.camera = GMSCameraPosition.camera(withTarget: location.coordinate, zoom: zoom)
    }

}

extension MapViewController: SearchDelegate {
    
    func didFind(_ event: Event) {
        showInformation(for: event, search: true)
    }
    
}

