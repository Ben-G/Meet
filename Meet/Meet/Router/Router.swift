//
//  Router.swift
//  Meet
//
//  Created by Benjamin Encz on 11/11/15.
//  Copyright © 2015 DigiTales. All rights reserved.
//

import UIKit

struct Router {
    let rootViewController: UIViewController
    
    init() {
        let tabBarViewController = UITabBarController()
        let contactsViewController = UIViewController()
        let addContactViewController = UIViewController()
        
        tabBarViewController.viewControllers = [contactsViewController, addContactViewController]
        rootViewController = tabBarViewController
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