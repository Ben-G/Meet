//
//  NavigationAction.swift
//  Meet
//
//  Created by Benjamin Encz on 11/27/15.
//  Copyright © 2015 DigiTales. All rights reserved.
//

import Foundation
import SwiftFlow
import SwiftFlowReactiveCocoaExtensions

public enum NavigationAction: ActionType {
    case NavigateTo(UIViewController)
    case CompleteNavigationTo(UIViewController)
    case SetNavigationState(UIViewController)
    case PresentViewController(UIViewController)
    case DismissViewController(presentingViewController: UIViewController)
}