//
//  TwitterAPIActionCreator.swift
//  Meet
//
//  Created by Benjamin Encz on 11/20/15.
//  Copyright © 2015 DigiTales. All rights reserved.
//

import Foundation
import SwifteriOS
import ReactiveCocoa
import SwiftFlow

struct TwitterAPIActionCreator {

    var twitterClient = TwitterClient.self

    func authenticateUser() -> AsyncActionCreator {
        return { maybeState, store, callback in

            guard let state = maybeState as? AppState else { return }
            if let swifter = state.twitterAPIState.swifter {
                callback(self.setTwitterClient(swifter))
            } else {
                self.twitterClient.login().start { event in
                    switch event {
                    case let .Next(swifter):
                        callback(self.setTwitterClient(swifter))
                    default:
                        print("oh")
                    }
                }
            }
        }
    }

    func searchUsers(searchTerm: String) -> ActionCreator {
        return { state, store in

            // Don't hit Twitter API with empty query string
            if searchTerm == "" {
                let emptyList: [TwitterUser] = []
                store.dispatch( SetUserSearchResult(.Success(emptyList)) )
                return nil
            }

            self.twitterClient.findUsers(searchTerm).start { event in
                switch event {
                case let .Next(users):
                    store.dispatch( SetUserSearchResult(.Success(users)) )
                case let .Failed(error):
                    store.dispatch( SetUserSearchResult(.Failure(error)) )
                default:
                    break
                }
            }

            return nil
        }
    }

    func setTwitterClient(swifter: Swifter) -> ActionCreator {
        return { _ in
            return SetTwitterClient(swifter)
        }
    }

}
