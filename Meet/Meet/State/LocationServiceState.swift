//
//  LocationServiceState.swift
//  Meet
//
//  Created by Benjamin Encz on 11/29/15.
//  Copyright © 2015 DigiTales. All rights reserved.
//

import Foundation
import CoreLocation
import Result

enum LocationServiceError: ErrorType {
    case LocationServiceUnauthorized
}

struct LocationServiceState {
    var authorizationStatus = CLLocationManager.authorizationStatus()
    var busyLocating: Bool = false
    var currentLocation: Result<Location, LocationServiceError>?
}

protocol HasLocationServiceState {
    var locationServiceState: LocationServiceState { get set }
}