//
//  LocationServiceActionCreator.swift
//  Meet
//
//  Created by Benjamin Encz on 11/29/15.
//  Copyright © 2015 DigiTales. All rights reserved.
//

import Foundation
import SwiftFlow

var locationService: LocationService?

struct LocationServiceActionCreator {
    
    mutating func retrieveLocation() -> ActionCreator {
        return { state, store in
            if (locationService == nil) {
                locationService = LocationService()
            }
        
            return nil
        }
    }
    
}