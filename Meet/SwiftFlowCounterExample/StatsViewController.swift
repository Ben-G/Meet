//
//  StatsViewController.swift
//  Meet
//
//  Created by Benjamin Encz on 12/1/15.
//  Copyright © 2015 DigiTales. All rights reserved.
//

import UIKit
import SwiftFlow
import SwiftFlowRouter

class StatsViewController: UIViewController, RoutableViewController {

    static let identifier = "StatsViewController"

    var infoViewController: RoutableViewController!

    func pushRouteSegment(viewControllerIdentifier: ViewControllerIdentifier) -> RoutableViewController {
        infoViewController = UIStoryboard(name: "Main", bundle: nil)
            .instantiateViewControllerWithIdentifier("InfoViewController") as! RoutableViewController

        presentViewController(infoViewController as! UIViewController, animated: false, completion: nil)

        return infoViewController
    }

    func popRouteSegment(viewControllerIdentifier: ViewControllerIdentifier) {
        dismissViewControllerAnimated(false, completion: nil)
    }

    func changeRouteSegment(fromViewControllerIdentifier: ViewControllerIdentifier,
        toViewControllerIdentifier: ViewControllerIdentifier) -> RoutableViewController {
            abort()
    }

    @IBAction func pushButtonTapped(sender: UIButton) {
        mainStore.dispatch(
            Action (
                type: ActionSetRoute,
                payload: ["route": ["TabBarViewController", StatsViewController.identifier,
                    InfoViewController.identifier]]
            )
        )
    }

}