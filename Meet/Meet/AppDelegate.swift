//
//  AppDelegate.swift
//  Meet
//
//  Created by Benjamin Encz on 11/10/15.
//  Copyright © 2015 DigiTales. All rights reserved.
//

import UIKit
import SwifteriOS
import SwiftFlow
import SwiftFlowRouter
import SwiftFlowReactiveCocoaExtensions
import SwiftFlowPersistenceNSCoding

let mainStore =
MainStoreReactiveCocoa(reducer: MainReducer([NavigationReducer(), DataMutationReducer(),
    TwitterAPIReducer(), LocationServiceReducer()]), appState: AppState())

var persistenceAdapter = PersistenceAdapter<DataState, AppState>()

public class SwifterWrapper {

    public class func handleOpenURL(url: NSURL) {
        Swifter.handleOpenURL(url)
    }

}

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    var router: Router!
    var rootViewController: Routable!
    var swifter: SwifterWrapper.Type = SwifterWrapper.self

    func application(application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {

        let tabBarController = UITabBarController()
        let addContactViewController = UIStoryboard(name: "Main", bundle: nil)
            .instantiateViewControllerWithIdentifier("AddContactViewController")
        let contactsViewController = UIStoryboard(name: "Main", bundle: nil)
            .instantiateViewControllerWithIdentifier("ContactsViewController")

        tabBarController.viewControllers = [addContactViewController, contactsViewController]
        rootViewController = tabBarController
        router = Router(store: mainStore, rootRoutable: RootRoutable(routable: rootViewController))

        mainStore.dispatch { state, store in

            if let state = state as? HasNavigationState where
                state.navigationState.route == [] {
                    return SetRouteAction(["TabBarViewController", AddContactViewController.identifier])
            } else {
                return nil
            }
        }


        window = UIWindow(frame: UIScreen.mainScreen().bounds)
        window?.rootViewController = tabBarController
        window?.makeKeyAndVisible()

        mainStore.subscribe(self)
        persistenceAdapter.store = mainStore

        return true
    }

    func application(app: UIApplication, openURL url: NSURL,
        options: [String : AnyObject]) -> Bool {

        print(url)
        if url.absoluteString.containsString("swifter://") {
            swifter.handleOpenURL(url)
            return true
        }

        return false
    }
}

extension AppDelegate: StoreSubscriber {

    func newState(maybeState: StateType) {
        guard let state = maybeState as? AppState else { return }

        print(state)
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
    
}

extension UITabBarController: Routable {

    public func changeRouteSegment(fromSegment: RouteElementIdentifier,
        to: RouteElementIdentifier,
        completionHandler: RoutingCompletionHandler) -> Routable {
            if (to == AddContactViewController.identifier) {
                selectedIndex = 0
                completionHandler()
                return viewControllers![0] as! Routable
            } else if (to == ContactListViewController.identifier) {
                selectedIndex = 1
                completionHandler()
                return viewControllers![1] as! Routable
            }

            abort()
    }

    public func pushRouteSegment(identifier: RouteElementIdentifier,
        completionHandler: RoutingCompletionHandler)
        -> Routable {
            if (identifier == AddContactViewController.identifier) {
                selectedIndex = 0
                completionHandler()
                return viewControllers![0] as! Routable
            } else if (identifier == ContactListViewController.identifier) {
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

extension AppDelegate: UITabBarControllerDelegate {

    func tabBarController(tabBarController: UITabBarController,
        shouldSelectViewController viewController: UIViewController) -> Bool {

            if viewController is AddContactViewController {
                mainStore.dispatch(
                    SetRouteAction(["TabBarViewController", AddContactViewController.identifier])
                )
            } else if viewController is ContactListViewController {
                mainStore.dispatch(
                    SetRouteAction(["TabBarViewController", ContactListViewController.identifier])
                )
            }
            
            return false
    }
    
}