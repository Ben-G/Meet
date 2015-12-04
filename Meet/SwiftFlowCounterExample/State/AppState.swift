//
//  AppState.swift
//  Meet
//
//  Created by Benjamin Encz on 12/1/15.
//  Copyright © 2015 DigiTales. All rights reserved.
//

import Foundation
import SwiftFlow
import SwiftFlowRouter

struct AppState: StateType, HasNavigationState {
    var counter: Int = 0
    var navigationState = NavigationState()
}

extension AppState: Coding {

    init(dictionary: [String : AnyObject]) {
        counter = dictionary["counter"] as! Int
        navigationState = NavigationState(dictionary: dictionary["navigationState"] as! [String : AnyObject])
    }

    func dictionaryRepresentation() -> [String : AnyObject] {
        return ["counter": counter, "navigationState": navigationState.dictionaryRepresentation()]
    }

}