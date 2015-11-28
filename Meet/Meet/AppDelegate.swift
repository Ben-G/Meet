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
import SwiftFlowReactiveCocoaExtensions
import SwiftFlowRouter

let mainStore = MainStore<AppState>(reducer: AnyReducer(MainReducer<AppState>()))
var persistenceAdapter = PersistenceAdapter()
let router = Router(store: mainStore)

public class SwifterWrapper {
    
    public class func handleOpenURL(url: NSURL) {
        Swifter.handleOpenURL(url)
    }
    
}

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
  var window: UIWindow?

  var swifter: SwifterWrapper.Type = SwifterWrapper.self
    
  func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {

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
    
    func newState(state: AppState) {
        print(state)
    }
    
}

