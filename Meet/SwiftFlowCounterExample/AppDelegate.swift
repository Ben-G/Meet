//
//  AppDelegate.swift
//  SwiftFlowCounterExample
//
//  Created by Benjamin Encz on 12/1/15.
//  Copyright © 2015 DigiTales. All rights reserved.
//

import UIKit
import SwiftFlow

var mainStore = MainStore(reducer: CounterReducer(), appState: AppState())

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        return true
    }

}

