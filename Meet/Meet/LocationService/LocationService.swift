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
    let location: MutableProperty<Location?> = MutableProperty(nil)
    
    override init() {
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
        }
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print(locations)
    }
    
}