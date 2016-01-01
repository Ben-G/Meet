//
//  GreetTwitterViewController.swift
//  Meet
//
//  Created by Benji Encz on 12/31/15.
//  Copyright © 2015 DigiTales. All rights reserved.
//

import UIKit
import SwiftFlowRouter
import SwiftFlow

protocol GreetTwitterViewControllerState: HasRouteSpecificState, HasNavigationState {}

class GreetTwitterViewController: UIViewController, Routable {

    static let identifier = "GreetTwitterViewController"

}

extension GreetTwitterViewController: StoreSubscriber {

    func newState(state: GreetTwitterViewControllerState) {
        guard let selectedTwitterUser = state.routeSpecificState[routeSpecificKey(state.navigationState.route)] as? TwitterUser else { return }

        print(selectedTwitterUser.name)
    }

}