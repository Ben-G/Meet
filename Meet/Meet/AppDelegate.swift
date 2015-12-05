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
    var rootRoutable: Routable!
    var swifter: SwifterWrapper.Type = SwifterWrapper.self

    func application(application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {

        let tabBarController = UITabBarController()
        let addContactViewController = UIStoryboard(name: "Main", bundle: nil)
            .instantiateViewControllerWithIdentifier("AddContactViewController")
        let contactsViewController = UIStoryboard(name: "Main", bundle: nil)
            .instantiateViewControllerWithIdentifier("ContactsViewController")

        tabBarController.viewControllers = [addContactViewController, contactsViewController]
        rootRoutable = RootRoutable()
        router = Router(store: mainStore, rootRoutable: rootRoutable)

//        mainStore.dispatch ( NavigationAction.SetNavigationState(addContactViewController) )

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

}