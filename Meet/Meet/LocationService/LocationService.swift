//
//  LocationService.swift
//  Meet
//
//  Created by Benjamin Encz on 11/29/15.
//  Copyright © 2015 DigiTales. All rights reserved.
//

import CoreLocation
import ReactiveCocoa

class LocationService: NSObject, CLLocationManagerDelegate {

    var locationManager: CLLocationManager
    let location: Signal<Location, LocationServiceError>
    private let observer: Observer<Location, LocationServiceError>
    
    override init() {
        let (signal, observer) = Signal<Location, LocationServiceError>.pipe()
        self.location = signal
        self.observer = observer
        locationManager = CLLocationManager()
        
        super.init()
        
        locationManager.delegate = self
        
        if (CLLocationManager.authorizationStatus() == .NotDetermined) {
            locationManager.requestWhenInUseAuthorization()
        } else if (CLLocationManager.authorizationStatus() == .AuthorizedWhenInUse) {
            locationManager.startUpdatingLocation()
        }
    }
    
    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        if (CLLocationManager.authorizationStatus() == .AuthorizedWhenInUse) {
            locationManager.startUpdatingLocation()
        } else if (CLLocationManager.authorizationStatus() == .Restricted || CLLocationManager.authorizationStatus() == .Denied) {
            observer.sendFailed(.LocationServiceUnauthorized)
        }
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            observer.sendNext(Location(geocodedAddress: "Stuttgart", coordinate: location.coordinate))
        }
    }
    
}