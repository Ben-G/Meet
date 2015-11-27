//
//  NavigationState.swift
//  Meet
//
//  Created by Benjamin Encz on 11/11/15.
//  Copyright © 2015 DigiTales. All rights reserved.
//

import UIKit

enum NavigationPresentationType {
    /// Uses the existing path between ViewControllers
    case Default
    case Custom(RouteTransition)
}

struct NavigationState {
    var currentViewController: UIViewController?
    var transitionToViewController: UIViewController?
    var presentationType: NavigationPresentationType?
}

protocol NavigationStateProtocol {
    var navigationState: NavigationState { get set }
}