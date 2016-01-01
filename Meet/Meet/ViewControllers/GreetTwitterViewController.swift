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
    var store = mainStore

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)

        store.subscribe(self)
    }

    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)

        store.unsubscribe(self)
    }

}

extension GreetTwitterViewController: StoreSubscriber {

    func newState(state: AppState) {
        guard let selectedTwitterUser = state.routeSpecificState[routeSpecificKey(state.navigationState.route)] as? TwitterUser else { return }

        print(selectedTwitterUser.name)
    }

}