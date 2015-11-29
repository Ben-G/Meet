//
//  NetworkErrorView.swift
//  Meet
//
//  Created by Benjamin Encz on 11/29/15.
//  Copyright © 2015 DigiTales. All rights reserved.
//

import UIKit

class NetworkErrorView: UIView {
    
    var retryFunction: (() -> Void)?
    
    @IBAction func retryButtonTapped(sender: AnyObject) {
        retryFunction?()
    }
    
}