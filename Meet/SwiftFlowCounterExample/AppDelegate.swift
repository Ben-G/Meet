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

    var rootViewController: RoutableViewController!
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

        router = Router(store: mainStore, rootViewControllerProvider: provideRootViewController)

        mainStore.dispatch { state, store in

            if let state = state as? HasNavigationState where
                state.navigationState.route == [] {
                    return Action (
                        type: ActionSetRoute,
                        payload: ["route": ["TabBarViewController", CounterViewController.identifier]]
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

    func provideRootViewController() -> RoutableViewController {
        return rootViewController
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

extension UITabBarController: RoutableViewController {

    public func changeRouteSegment(fromViewControllerIdentifier: ViewControllerIdentifier,
        toViewControllerIdentifier: ViewControllerIdentifier) -> RoutableViewController {
            if (toViewControllerIdentifier == CounterViewController.identifier) {
                selectedIndex = 0
                return viewControllers![0] as! RoutableViewController
            } else if (toViewControllerIdentifier == StatsViewController.identifier) {
                selectedIndex = 1
                return viewControllers![1] as! RoutableViewController
            }

            abort()
    }

    public func pushRouteSegment(viewControllerIdentifier: ViewControllerIdentifier)
        -> RoutableViewController {
            if (viewControllerIdentifier == CounterViewController.identifier) {
                selectedIndex = 0
                return viewControllers![0] as! RoutableViewController
            } else if (viewControllerIdentifier == StatsViewController.identifier) {
                selectedIndex = 1
                return viewControllers![1] as! RoutableViewController
            }

            abort()
    }

    public func popRouteSegment(viewControllerIdentifier: ViewControllerIdentifier) {
        // would need to unset root view controller here
    }

}
