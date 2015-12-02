//
//  NavigationAction.swift
//  Meet
//
//  Created by Benjamin Encz on 11/27/15.
//  Copyright © 2015 DigiTales. All rights reserved.
//

import Foundation
import SwiftFlow

public enum NavigationAction {
    case NavigateTo(UIViewController)
    case CompleteNavigationTo(UIViewController)
    case SetNavigationState(UIViewController)
    case PresentViewController(UIViewController)
    case DismissViewController(presentingViewController: UIViewController)
}

public let ActionNavigateTo = "SWIFT_FLOW_ROUTER_NAVIGATE_TO"
public let ActionCompleteNavigationTo = "SWIFT_FLOW_ROUTER_COMPLETE_NAVIGATION_TO"
public let ActionSetNavigationState = "SWIFT_FLOW_ROUTER_SET_NAVIGATION_STATE"
public let ActionPresentViewController = "SWIFT_FLOW_ROUTER_PRESENT_VIEWCONTROLLER"
public let ActionDismissViewController = "SWIFT_FLOW_ROUTER_DISMISS_VIEWCONTROLLER"

public protocol Routable {
    static var identifier: String { get }
}

public extension Routable {
    var _identifier: String {
        get {
            return Self.identifier
        }
    }
}

func navigateTo<T: UIViewController where T:Routable>(viewController: T.Type) -> Action {
    let payload = ActionNavigateToPayload(targetViewController: viewController.identifier)

    return Action(type: ActionNavigateTo, payload: payload.dictionaryRepresentation())
}

struct ActionNavigateToPayload: Coding {
    let targetViewControllerIdentifier: String

    init(targetViewController: String) {
        self.targetViewControllerIdentifier = targetViewController
    }

    init?(dictionary: NSDictionary) {
        guard let targetViewControllerIdentifier = dictionary["targetViewController"] as? String
            else { return nil }

        self.targetViewControllerIdentifier = targetViewControllerIdentifier
    }

    func dictionaryRepresentation() -> NSDictionary {
        return ["targetViewController": targetViewControllerIdentifier]
    }
}