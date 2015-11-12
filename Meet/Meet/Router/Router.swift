//
//  Router.swift
//  Meet
//
//  Created by Benjamin Encz on 11/11/15.
//  Copyright © 2015 DigiTales. All rights reserved.
//

import UIKit

class Router: NSObject {
    var navigationActionCreator = NavigationActionCreator()
    var store: Store
    
    let rootViewController: UITabBarController
    
    init(store: Store) {
        self.store = store
        let tabBarController = UITabBarController()
        let contactsViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("ContactsViewController")
        let addContactViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("AddContactViewController")
        
        tabBarController.viewControllers = [contactsViewController, addContactViewController]
        rootViewController = tabBarController
        
        super.init()
        
        mainStore.dispatch { self.navigationActionCreator.setCurrentViewController(contactsViewController) }
        tabBarController.delegate = self
        self.store.subscribe(self)
    }
}

extension Router: UITabBarControllerDelegate {
    
    func tabBarController(tabBarController: UITabBarController, shouldSelectViewController viewController: UIViewController) -> Bool {
        mainStore.dispatch { self.navigationActionCreator.navigateToViewController(viewController) }
        
        return false
    }
    
}

extension Router: StoreSubscriber {
    
    func newState(state: AppState) {
        if let fromViewController = state.navigationState.currentViewController,
            toViewController = state.navigationState.transitionToViewController {
                let transition = transitionFrom(fromViewController, to: toViewController)
                switch transition {
                case .TabBarSelect:
                    rootViewController.selectedViewController = toViewController
                    mainStore.dispatch { self.navigationActionCreator.navigateToViewControllerCompleted(toViewController) }
                case .Modal:
                    fromViewController.presentViewController(toViewController, animated: true, completion: nil)
                    mainStore.dispatch { self.navigationActionCreator.navigateToViewControllerCompleted(toViewController) }
                default: break
                }
        }
    }
    
}

func transitionFrom(vc1: UIViewController, to vc2: UIViewController) -> RouteTransition {
//    let transition = (vc1, vc2)
    
    if (vc1 is ContactListViewController) && (vc2 is AddContactViewController) {
        return .TabBarSelect
    }
    
    if (vc1 is AddContactViewController) && (vc2 is ContactListViewController) {
        return .TabBarSelect
    }
    
    if (vc1 is AddContactViewController) && (vc2 is SearchTwitterViewController) {
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

enum RouteTransition {
  case Push
  case Pop
  case TabBarSelect
  case Modal
  case None
}