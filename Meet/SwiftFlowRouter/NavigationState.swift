//
//  NavigationState.swift
//  Meet
//
//  Created by Benjamin Encz on 11/11/15.
//  Copyright © 2015 DigiTales. All rights reserved.
//

import UIKit

public enum NavigationPresentationType {
    /// Uses the existing path between ViewControllers
    case Default
    case Custom(RouteTransition)
}

public struct NavigationState {
    public init() {}

    public var currentViewController: String?
    public var transitionToViewController: String?
    public var presentationType: NavigationPresentationType?
}

public protocol HasNavigationState {
    var navigationState: NavigationState { get set }
}
