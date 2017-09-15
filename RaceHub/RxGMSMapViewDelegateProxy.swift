//
//  RxGMSMapViewDelegateProxy.swift
//  RaceHub
//
//  Created by Piotr Olejnik on 05.09.2017.
//  Copyright © 2017 gat. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import GoogleMaps

class RxGMSMapViewDelegateProxy: DelegateProxy, GMSMapViewDelegate, DelegateProxyType {
    
    private let didTapMarkerSubject = PublishSubject<GMSMarker>()
    let didTapMarkerEvent: ControlEvent<GMSMarker>
    
    required init(parentObject: AnyObject) {
        didTapMarkerEvent = ControlEvent(events: didTapMarkerSubject)
        
        super.init(parentObject: parentObject)
    }
    
    static func currentDelegateFor(_ object: AnyObject) -> AnyObject? {
        let mapView = object as! GMSMapView
        return mapView.delegate
    }
    
    static func setCurrentDelegate(_ delegate: AnyObject?, toObject object: AnyObject) {
        let mapView = object as! GMSMapView
        mapView.delegate = delegate as? GMSMapViewDelegate
    }
    
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        didTapMarkerSubject.on(.next(marker))
        return self._forwardToDelegate?.mapView?(mapView, didTap: marker) ?? false
    }
    
}

