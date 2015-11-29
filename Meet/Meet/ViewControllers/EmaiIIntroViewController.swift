//
//  EmaiIIntroViewController.swift
//  Meet
//
//  Created by Benjamin Encz on 11/17/15.
//  Copyright © 2015 DigiTales. All rights reserved.
//

import UIKit
import MessageUI
import SwiftFlowRouter

var mailComposerViewController: MFMailComposeViewController?

class EmailIntroViewController: UIViewController {

    var store = mainStore
    
    @IBAction func emailIntroButtonTapped(sender: AnyObject) {
        mailComposerViewController = MFMailComposeViewController()
        mailComposerViewController?.mailComposeDelegate = self
    
        store.dispatch( NavigationAction.PresentViewController(mailComposerViewController!) )
    }
    
    @IBAction func cancelButtonTapped(sender: AnyObject) {
        store.dispatch( NavigationAction.DismissViewController(presentingViewController: self.presentingViewController!) )
    }
    
}

extension EmailIntroViewController: MFMailComposeViewControllerDelegate, UINavigationControllerDelegate {
 
    func mailComposeController(controller: MFMailComposeViewController, didFinishWithResult result: MFMailComposeResult, error: NSError?) {
        
        if (result == MFMailComposeResultCancelled) {
            store.dispatch(
                NavigationAction.DismissViewController(presentingViewController: self)
            )
        } else if (result == MFMailComposeResultSent) {
            store.dispatch( DataMutationAction.CreateContactFromEmail("Benjamin.Encz@gmail.com") )
            store.dispatch(
                NavigationAction.DismissViewController(presentingViewController: self)
            )
        }
    }
    
}