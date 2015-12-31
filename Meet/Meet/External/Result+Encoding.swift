//
//  Result+Encoding.swift
//  Meet
//
//  Created by Benji Encz on 12/31/15.
//  Copyright © 2015 DigiTales. All rights reserved.
//

import Foundation
import Result
import SwiftFlow

func encode<A: Coding, B: Coding>(x: Result<A, B>) -> [String : AnyObject] {
    switch x {
    case .Success(let t):
        return ["success": t.dictionaryRepresentation()]
    case .Failure(let e):
        return ["error": e.dictionaryRepresentation()]
    }
}

func encode<A: Coding, B: Coding>(x: Result<[A], B>) -> [String : AnyObject] {
    switch x {
    case .Success(let t):
        return ["success": t.map { $0.dictionaryRepresentation() }]
    case .Failure(let e):
        return ["error": e.dictionaryRepresentation()]
    }
}

func decode<A: Coding, B: Coding>(dictionary: [String : AnyObject]) -> Result<[A], B> {
    if let success = dictionary["success"] as? [AnyObject] {
        return .Success( success.map { A(dictionary: $0 as! [String : AnyObject]) } )
    } else if let failure = dictionary["failure"] as? [String : AnyObject] {
        return .Failure(B(dictionary: failure))
    } else {
        abort()
    }
}

func decode<A: Coding, B: Coding>(dictionary: [String : AnyObject]) -> Result<A, B> {
    if let success = dictionary["success"] as? [String : AnyObject] {
        return .Success(A(dictionary: success))
    } else if let failure = dictionary["failure"] as? [String : AnyObject] {
        return .Failure(B(dictionary: failure))
    } else {
        abort()
    }
}