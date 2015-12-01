//
//  AppDelegateTests.swift
//  Meet
//
//  Created by Benjamin Encz on 11/22/15.
//  Copyright © 2015 DigiTales. All rights reserved.
//

import XCTest
import SwifteriOS
@testable import Meet

public class FakeSwifter: SwifterWrapper {

    static var handled: Bool = false

    public override class func handleOpenURL(url: NSURL) {
        handled = true
    }

}

class AppDelegateTests: XCTestCase {

    func testHandlesSwifterURL() {
        let appDelegate = AppDelegate()
        appDelegate.swifter = FakeSwifter.self

        appDelegate.application(UIApplication.sharedApplication(),
            openURL: NSURL(string: "swifter://")!, options: [:])

        XCTAssertTrue(FakeSwifter.handled)
    }

}
