//
//  GMSMapView+Rx.swift
//  RaceHub
//
//  Created by Piotr Olejnik on 05.09.2017.
//  Copyright © 2017 gat. All rights reserved.
//

import Foundation
import GoogleMaps
import CoreLocation
import RxCocoa
import RxSwift

extension Reactive where Base: GMSMapView {
    
    private func castOrThrow<T>(resultType: T.Type, _ object: AnyObject) throws -> T {
        guard let returnValue = object as? T else {
            throw RxCocoaError.castingError(object: object, targetType: resultType)
        }
        return returnValue
    }
    
    public var delegate: DelegateProxy {
        return RxGMSMapViewDelegateProxy.proxyForObject(self.base)
    }
    
    public var didTapMarker: ControlEvent<GMSMarker> {
        let proxy = RxGMSMapViewDelegateProxy.proxyForObject(self.base)
        return proxy.didTapMarkerEvent
    }
    
    public var idleAtLocation: Observable<CLLocation> {
        let selector = #selector(GMSMapViewDelegate.mapView(_:idleAt:))
        let source = RxGMSMapViewDelegateProxy.proxyForObject(self.base).methodInvoked(selector)
            .map { a -> CLLocation in
                let position = a[1] as! GMSCameraPosition
                let location = CLLocation(latitude: position.target.latitude, longitude: position.target.longitude)
                return location
        }
        return source
    }
    
}
