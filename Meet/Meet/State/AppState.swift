//
//  AppState.swift
//  Meet
//
//  Created by Benjamin Encz on 11/11/15.
//  Copyright © 2015 DigiTales. All rights reserved.
//

import Foundation
import SwiftFlow
import SwiftFlowRouter
import SwiftFlowReactiveCocoaExtensions

/*
  1. Which View Controller did the tab bar select? // more general: navigation state?
*/

/*

  state = [
      NavigationState,
      TwitterSearchViewState,
      ContactListState,
      ContactDetailNoteState
  ]


*/

struct AppState: AppStateProtocol, NavigationStateProtocol {
    var navigationState = NavigationState()
    var dataState = DataState()
    var twitterAPIState = TwitterAPIState()
}