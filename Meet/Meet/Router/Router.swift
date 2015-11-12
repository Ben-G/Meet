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
    let rootViewController: UIViewController
    
    override init() {
        let tabBarController = UITabBarController()
        let contactsViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("ContactsViewController")
        let addContactViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("AddContactViewController")
        
        tabBarController.viewControllers = [contactsViewController, addContactViewController]
        rootViewController = tabBarController
        
        super.init()
        
        mainStore.dispatch { self.navigationActionCreator.setCurrentViewController(contactsViewController) }
        tabBarController.delegate = self
    }
}

extension Router: UITabBarControllerDelegate {
    
    @objc func tabBarController(tabBarController: UITabBarController, didSelectViewController viewController: UIViewController) {
        mainStore.dispatch { self.navigationActionCreator.setCurrentViewController(viewController) }
    }
    
}

func transitionFrom(vc1: UIViewController, to vc2: UIViewController) -> RouteTransition {
  let transition = (vc1, vc2)
  
  switch transition {
  case is (ContactListViewController, AddContactViewController):
      return .TabBarSelect
  case is (AddContactViewController, ContactListViewController):
      return .TabBarSelect
  default:
      return .None
  }
}

enum RouteTransition {
  case Push
  case Pop
  case TabBarSelect
  case Modal
  case None
}