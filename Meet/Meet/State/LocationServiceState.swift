//
//  LocationServiceState.swift
//  Meet
//
//  Created by Benjamin Encz on 11/29/15.
//  Copyright © 2015 DigiTales. All rights reserved.
//

import Foundation
import Result

enum LocationServiceError: ErrorType {
    case LocationServiceUnauthorized
}

struct LocationServiceState {
    var locationServiceAuthorized: Bool
    var busyLocating: Bool
    var currentLocation: Result<Location, LocationServiceError>
}

protocol HasLocationServiceState {
    var locationServiceState: LocationServiceState { get set }
}