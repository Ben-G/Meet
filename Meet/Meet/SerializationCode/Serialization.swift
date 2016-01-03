//
//  Serialization.swift
//  Meet
//
//  Created by Benji Encz on 1/2/16.
//  Copyright © 2016 DigiTales. All rights reserved.
//

import SwiftFlow 

extension SearchTwitterScene.SetSelectedTwitterUser: StandardActionConvertible {

    static let type = "SearchTwitterScene.SetSelectedTwitterUser"

    init(_ standardAction: StandardAction) {
        self.twitterUser = decode(standardAction.payload!["twitterUser"]!)
    }

    func toStandardAction() -> StandardAction {
        let payload = ["twitterUser": encode(self.twitterUser)]

        return StandardAction(type: SearchTwitterScene.SetSelectedTwitterUser.type, payload: payload, isTypedAction: true)
    }
    
}

extension CreateContactFromEmail: StandardActionConvertible {

    init(_ action: StandardAction) {
        self.email = decode(action.payload!["email"]!)
    }

    func toStandardAction() -> StandardAction {
        let payload = ["email": encode(self.email)]

        return StandardAction(type: CreateContactFromEmail.type, payload: payload, isTypedAction: true)
    }
}

extension CreateContactWithTwitterUser: StandardActionConvertible {

    init(_ action: StandardAction) {
        self.twitterUser = decode(action.payload!["twitterUser"]!)
    }

    func toStandardAction() -> StandardAction {
        let payload = ["twitterUser": encode(self.twitterUser)]

        return StandardAction(type: CreateContactWithTwitterUser.type,
            payload: payload,
            isTypedAction: true)
    }
}

extension DeleteContact: StandardActionConvertible {

    init(_ action: StandardAction) {
        self.contactID = decode(action.payload!["contactID"]!)
    }

    func toStandardAction() -> StandardAction {
        let payload = ["contactID": encode(self.contactID)]

        return StandardAction(type: CreateContactWithTwitterUser.type,
            payload: payload,
            isTypedAction: true)
    }
    
}

