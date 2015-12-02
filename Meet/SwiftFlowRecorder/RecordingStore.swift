//
//  RecordingStore.swift
//  Meet
//
//  Created by Benjamin Encz on 12/1/15.
//  Copyright © 2015 DigiTales. All rights reserved.
//

import Foundation
import SwiftFlow
import SwiftFlowPersistenceNSCoding

public class RecordingMainStore: MainStore {

    typealias RecordedActions = [[String : AnyObject]]

    var recordedActions: RecordedActions = []

    public init(reducer: AnyReducer, appState: StateType, recording: String? = nil) {
        super.init(reducer: reducer, appState: appState)

        if let recording = recording {
            let actions = loadActions(recording)
            actions.forEach {
                dispatch($0)
            }
        }
    }

    public override func dispatch(action: Action, callback: DispatchCallback?) {
        super.dispatch(action, callback: callback)

        let recordedAction: [String : AnyObject] = [
            "timestamp": NSDate.timeIntervalSinceReferenceDate(),
            "action": action.dictionaryRepresentation()
        ]

        recordedActions.append(recordedAction)
        storeActions(recordedActions)
    }

    lazy var recordingDirectory: NSURL? = {
        let timestamp = Int(NSDate.timeIntervalSinceReferenceDate())

        let documentDirectoryURL = try? NSFileManager.defaultManager()
            .URLForDirectory(.DocumentDirectory, inDomain:
                .UserDomainMask, appropriateForURL: nil, create: true)

//        let path = documentDirectoryURL?
//            .URLByAppendingPathComponent("recording_\(timestamp).json")
        let path = documentDirectoryURL?
                    .URLByAppendingPathComponent("recording.json")

        print("Recording to path: \(path)")
        return path
    }()

    lazy var documentsDirectory: NSURL? = {
        let documentDirectoryURL = try? NSFileManager.defaultManager()
            .URLForDirectory(.DocumentDirectory, inDomain:
            .UserDomainMask, appropriateForURL: nil, create: true)

        return documentDirectoryURL
    }()

    private func storeActions(actions: RecordedActions) {
        let data = try! NSJSONSerialization.dataWithJSONObject(actions, options: .PrettyPrinted)

        if let path = recordingDirectory {
            do {
                try data.writeToURL(path, atomically: true)
            } catch {
                /* error handling here */
            }
        }
    }

    private func loadActions(recording: String) -> [Action] {
        guard let recordingPath = documentsDirectory?.URLByAppendingPathComponent(recording) else {
            return []
        }
        guard let data = NSData(contentsOfURL: recordingPath) else { return [] }

        let jsonArray = try! NSJSONSerialization.JSONObjectWithData(data,
            options: NSJSONReadingOptions(rawValue: 0)) as! Array<AnyObject>
        print(jsonArray)

        let actionsArray: [Action] = jsonArray.map {
            return Action(dictionary: $0["action"] as! NSDictionary)!
        }

        return actionsArray
    }

}