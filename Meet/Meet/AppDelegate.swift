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

let mainStore = MainStoreReactiveCocoa(reducer: MainReducer([NavigationReducer(), DataMutationReducer(), TwitterAPIReducer()]), appState: AppState())
var persistenceAdapter = PersistenceAdapter()

public class SwifterWrapper {
    
    public class func handleOpenURL(url: NSURL) {
        Swifter.handleOpenURL(url)
    }
    
}

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
  var window: UIWindow?

   var router: Router!
    var navigationActionCreator = NavigationActionCreator()
    
  var swifter: SwifterWrapper.Type = SwifterWrapper.self
    
  func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
    
    let tabBarController = UITabBarController()
    let addContactViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("AddContactViewController")
    let contactsViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("ContactsViewController")
    
    tabBarController.viewControllers = [addContactViewController, contactsViewController]
    
    router = Router(store: mainStore, rootViewController: tabBarController, transitionProvider: transitionFrom)
    mainStore.dispatch { self.navigationActionCreator.setCurrentViewController(addContactViewController) }

    window = UIWindow(frame: UIScreen.mainScreen().bounds)
    window?.rootViewController = router.rootViewController
    window?.makeKeyAndVisible()
    
    mainStore.subscribe(self)
    persistenceAdapter.store = mainStore
    
    return true
  }
    
    func application(app: UIApplication, openURL url: NSURL, options: [String : AnyObject]) -> Bool {
        print(url)
        if (url.absoluteString.containsString("swifter://")) {
            swifter.handleOpenURL(url)
            return true
        }
        
        return false
    }
}

extension AppDelegate: StoreSubscriber {
    
    func newState(maybeState: AppStateProtocol) {
        guard let state = maybeState as? AppState else { return }

        print(state)
    }
    
}

func transitionFrom(vc1: UIViewController, to vc2: UIViewController) -> RouteTransition {
    let transition = (vc1, vc2)

    if (vc1 is ContactListViewController) && (vc2 is AddContactViewController) {
        return .TabBarSelect
    }

    if (vc1 is AddContactViewController) && (vc2 is ContactListViewController) {
        return .TabBarSelect
    }

    if (vc1 is AddContactViewController) && (vc2 is SearchTwitterViewController) {
        return .Modal
    }

    if (vc1 is AddContactViewController) && (vc2 is EmailIntroViewController) {
        return .Modal
    }
    
    return .None
    
    //      switch transition {
    //      case is (ContactListViewController, AddContactViewController):
    //          return .TabBarSelect
    //      case is (AddContactViewController, ContactListViewController):
    //          return .TabBarSelect
    //      default:
    //          return .None
    //      }
}

