//
//  Location.swift
//  Meet
//
//  Created by Benjamin Encz on 11/29/15.
//  Copyright © 2015 DigiTales. All rights reserved.
//

import Foundation
import CoreLocation
import SwiftFlow

struct Location {
    let geocodedAddress: String
    let coordinate: CLLocationCoordinate2D
}

extension Location: Coding {

    init(dictionary: [String : AnyObject]) {
        geocodedAddress = dictionary["geocodedAddress"] as! String
        coordinate = CLLocationCoordinate2D(latitude: dictionary["latitude"] as! Double,
            longitude: dictionary["longitude"] as! Double)
    }

    func dictionaryRepresentation() -> [String : AnyObject] {
        return ["geocodedAddress": geocodedAddress, "latitude": coordinate.latitude,
            "longitude": coordinate.longitude]
    }

}
