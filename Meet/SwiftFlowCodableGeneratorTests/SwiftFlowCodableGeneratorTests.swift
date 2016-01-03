//
//  SwiftFlowCodableGeneratorTests.swift
//  SwiftFlowCodableGeneratorTests
//
//  Created by Benjamin Encz on 12/9/15.
//  Copyright © 2015 DigiTales. All rights reserved.
//

import XCTest
import SourceKittenFramework
import SwiftFlowCodableGenerator

class SwiftFlowCodableGeneratorTests: XCTestCase {

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testExtraction() {
        let testBundle = NSBundle(forClass: self.dynamicType)
        let fileURL = testBundle.URLForResource("SetUserSearchText", withExtension: "swiftsourcefile")
        let fileURLString = fileURL!.path!
        let file = File(path: fileURLString)
        let convertibleTypes = generateActionConvertible(file!)

        XCTAssertEqual(convertibleTypes.count, 2)
        XCTAssertEqual(convertibleTypes[0].typeName, "SetUserSearchText")
    }

    func testCodeGeneration() {
        let testBundle = NSBundle(forClass: self.dynamicType)
        let fileURL = testBundle.URLForResource("SetUserSearchText", withExtension: "swiftsourcefile")
        let fileURLString = fileURL!.path!
        let file = File(path: fileURLString)
        let convertibleTypes = generateActionConvertible(file!)

        let code = generateActionConvertibleImplementation(convertibleTypes)
        print(code)
        writeGeneratedCodeToFile(code)
    }

}
