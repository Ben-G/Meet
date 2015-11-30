//
//  LocationIndicatorView.swift
//  Meet
//
//  Created by Benjamin Encz on 11/29/15.
//  Copyright © 2015 DigiTales. All rights reserved.
//

import UIKit

class LocationIndicatorView: UIView {

    enum DisplayState {
        case LocationAuthorizationRequired
        case BusyLocating
        case Located(String)
    }

    @IBOutlet var mainLabel: UILabel!
    var contentView: UIView!

    var locationServiceRequestedCallback: (UIView -> Void)?

    var displayState: DisplayState = .LocationAuthorizationRequired {
        didSet {
            switch displayState {
            case .LocationAuthorizationRequired:
                mainLabel.text = "Tap here to enable location services! We'll keep track of where you met people."
            case .BusyLocating:
                mainLabel.text = "Finding your location...."
            case .Located(let locationString):
                mainLabel.text = locationString
            }
        }
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        contentView = NSBundle.mainBundle().loadNibNamed("LocationIndicatorView", owner: self, options: nil)[0] as! UIView
        contentView.frame = self.bounds
        self.addSubview(contentView)
    }

    //MARK: Touch Handling

    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        locationServiceRequestedCallback?(self)
    }

}