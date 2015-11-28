//
//  NavigationState.swift
//  Meet
//
//  Created by Benjamin Encz on 11/11/15.
//  Copyright © 2015 DigiTales. All rights reserved.
//

import UIKit
import ReactiveCocoa
import SwiftFlow
import SwiftFlowReactiveCocoaExtensions

enum NavigationPresentationType {
    /// Uses the existing path between ViewControllers
    case Default
    case Custom(RouteTransition)
}

public struct NavigationState: AppStateProtocol {
    var currentViewController: UIViewController?
    var transitionToViewController: UIViewController?
    var presentationType: NavigationPresentationType?
    
    public init() {}
}

public protocol NavigationStateProtocol: AppStateProtocol {
    var navigationState: NavigationState { get set }
}

protocol NavigationStore {
    typealias ActionCreator = (state: NavigationStateProtocol, store: Self) -> NavigationActions?
    typealias AsyncActionCreator = (state: NavigationStateProtocol, store: Self) -> Signal<ActionCreator,NoError>?
    
    typealias ActionCreatorProvider = () -> ActionCreator
    typealias AsyncActionCreatorProvider = () -> AsyncActionCreator
    
    
    func subscribe(subscriber: AnyStoreSubscriber<NavigationStateProtocol>)
    func dispatch(actionCreatorProvider: AsyncActionCreatorProvider) -> Signal<NavigationStateProtocol, NoError>
    
    func dispatch(actionCreatorProvider: ActionCreatorProvider) -> Signal<NavigationStateProtocol, NoError>
    
    var state: NavigationStateProtocol { get set }
}