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
    var initialState: StateType
    var computedStates: [StateType] = []
    var actionsToReplay: Int?
    let recordingPath: String?

    var loadedActions: [Action] = [] {
        didSet {
            stateHistoryView?.statesCount = loadedActions.count
        }
    }

    var stateHistoryView: StateHistoryView?

    public var window: UIWindow? {
        didSet {
            if let window = window {
                let windowSize = window.bounds.size
                stateHistoryView = StateHistoryView(frame: CGRect(x: 0, y: 0,
                    width: windowSize.width, height: 100))
                window.addSubview(stateHistoryView!)
                window.bringSubviewToFront(stateHistoryView!)

                stateHistoryView?.cellSelectionCallback = { [unowned self] selection in
                    self.replayToState(self.loadedActions, state: selection)
                }

                stateHistoryView?.statesCount = loadedActions.count
            }
        }
    }

    public init(reducer: AnyReducer, appState: StateType, recording: String? = nil) {
        initialState = appState
        recordingPath = recording

        super.init(reducer: reducer, appState: appState)

        if let recording = recording {
            loadedActions = loadActions(recording)
            self.replayToState(loadedActions, state: loadedActions.count)
        }
    }

    func dispatchRecorded(action: Action, callback: DispatchCallback?) {
        super.dispatch(action, callback: callback)

        recordAction(action)
    }

    public override func dispatch(action: Action, callback: DispatchCallback?) {
        if let actionsToReplay = actionsToReplay where actionsToReplay > 0 {
            // ignore actions that are dispatched during replay
            return
        }

        super.dispatch(action, callback: callback)

        recordAction(action)
        loadedActions.append(action)
    }

    func recordAction(action: Action) {
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

        let actionsArray: [Action] = jsonArray.map {
            return Action(dictionary: $0["action"] as! NSDictionary)!
        }

        return actionsArray
    }

    private func replayToState(actions: [Action], state: Int) {
        print("Rewind to \(state)...")
        appState = initialState
        recordedActions = []
        actionsToReplay = state

        for i in 0..<state {
            dispatchRecorded(actions[i]) { newState in
                self.actionsToReplay = self.actionsToReplay! - 1
                self.computedStates.append(newState)
            }
        }
    }

}