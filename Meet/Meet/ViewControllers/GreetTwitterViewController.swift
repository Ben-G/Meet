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

class GreetTwitterViewController: UIViewController, Routable {

    @IBOutlet var twitterLabel: UILabel!

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
        let routeSpecificData = state.routeSpecificState[routeSpecificKey(state.navigationState.route)]!
        let selectedTwitterUser: TwitterUser = decode(routeSpecificData)

        twitterLabel.text = selectedTwitterUser.name
    }

}