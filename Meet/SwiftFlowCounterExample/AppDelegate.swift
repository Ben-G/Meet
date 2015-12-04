//
//  AppDelegate.swift
//  SwiftFlowCounterExample
//
//  Created by Benjamin Encz on 12/1/15.
//  Copyright © 2015 DigiTales. All rights reserved.
//

import UIKit
import SwiftFlow
import SwiftFlowRecorder
import SwiftFlowRouter

var mainStore = RecordingMainStore(reducer: MainReducer([CounterReducer(), NavigationReducer()]),
    appState: AppState(), recording: "recording.json")

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var router: Router!
    var window: UIWindow?

    var rootViewController: Routable!
    var counterViewController: UIViewController!
    var statsViewController: UIViewController!

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        let tabBarController = UITabBarController()
        counterViewController = UIStoryboard(name: "Main", bundle: nil)
            .instantiateViewControllerWithIdentifier("CounterViewController")
        statsViewController = UIStoryboard(name: "Main", bundle: nil)
            .instantiateViewControllerWithIdentifier("StatsViewController")

        tabBarController.viewControllers = [counterViewController, statsViewController]
        tabBarController.delegate = self
        rootViewController = tabBarController

        router = Router(store: mainStore, rootRoutable: RootRoutable(routable: rootViewController))

        mainStore.dispatch { state, store in

            if let state = state as? HasNavigationState where
                state.navigationState.route == [] {
                    return Action (
                        type: ActionSetRoute,
                        payload: ["route": ["TabBarViewController", StatsViewController.identifier,
                            InfoViewController.identifier]]
                    )
            } else {
                return nil
            }
        }


        window = UIWindow(frame: UIScreen.mainScreen().bounds)
        window?.rootViewController = tabBarController
        window?.makeKeyAndVisible()

        mainStore.window = window

        return true
    }

}

class RootRoutable: Routable {

    var routable: Routable

    init(routable: Routable) {
        self.routable = routable
    }

    func pushRouteSegment(routeElementIdentifier: RouteElementIdentifier,
        completionHandler: RoutingCompletionHandler) -> Routable {
            completionHandler()
            return routable
    }

    func popRouteSegment(routeElementIdentifier: RouteElementIdentifier,
        completionHandler: RoutingCompletionHandler) {
            completionHandler()
    }

    func changeRouteSegment(from: RouteElementIdentifier, to: RouteElementIdentifier,
        completionHandler: RoutingCompletionHandler) -> Routable {
            abort()
    }

}

extension AppDelegate: UITabBarControllerDelegate {

    func tabBarController(tabBarController: UITabBarController, shouldSelectViewController viewController: UIViewController) -> Bool {

        if viewController is CounterViewController {
            mainStore.dispatch(
                Action(
                    type: ActionSetRoute,
                    payload: ["route": ["TabBarViewController", CounterViewController.identifier]]
                )
            )
        } else if viewController is StatsViewController {
            mainStore.dispatch(
                Action(
                    type: ActionSetRoute,
                    payload: ["route": ["TabBarViewController", StatsViewController.identifier]]
                )
            )
        }
        
        return false
    }

}

extension UITabBarController: Routable {

    public func changeRouteSegment(fromSegment: RouteElementIdentifier,
        to: RouteElementIdentifier,
        completionHandler: RoutingCompletionHandler) -> Routable {
            if (to == CounterViewController.identifier) {
                selectedIndex = 0
                completionHandler()
                return viewControllers![0] as! Routable
            } else if (to == StatsViewController.identifier) {
                selectedIndex = 1
                completionHandler()
                return viewControllers![1] as! Routable
            }

            abort()
    }

    public func pushRouteSegment(identifier: RouteElementIdentifier,
        completionHandler: RoutingCompletionHandler)
        -> Routable {
            if (identifier == CounterViewController.identifier) {
                selectedIndex = 0
                completionHandler()
                return viewControllers![0] as! Routable
            } else if (identifier == StatsViewController.identifier) {
                selectedIndex = 1
                completionHandler()
                return viewControllers![1] as! Routable
            }

            abort()
    }

    public func popRouteSegment(viewControllerIdentifier: RouteElementIdentifier,
        completionHandler: RoutingCompletionHandler) {
        // would need to unset root view controller here
            completionHandler()
    }

}
