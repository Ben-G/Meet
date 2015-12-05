//
//  LocationServiceActionCreator.swift
//  Meet
//
//  Created by Benjamin Encz on 11/29/15.
//  Copyright © 2015 DigiTales. All rights reserved.
//

import Foundation
import SwiftFlow
import ReactiveCocoa

var locationService: LocationService?

struct LocationServiceActionCreator {

    mutating func retrieveLocation(askForAuthorization: Bool) -> ActionCreator {
        return { anyState, store in
            guard let state = anyState as? HasLocationServiceState else { return nil }

            if askForAuthorization == true ||
                state.locationServiceState.authorizationStatus == .AuthorizedWhenInUse {

                if locationService == nil {
                    store.dispatch ( SetLocationServiceBusy(true) )
                    locationService = LocationService()
                    locationService!.location.observe({ event in
                        switch event {
                        case .Next(let location):
                            store.dispatch ( self.setCurrentLocation(location) )
                            break
                        case .Failed(let error):
                            break
                        default:
                            break
                        }
                    })
                }
            }

            return nil
        }
    }

    func setCurrentLocation(location: Location) -> ActionCreator {
        return { state, store in
            store.dispatch( SetLocationServiceBusy(false) )
            return SetLocation(location)
        }
    }

}
