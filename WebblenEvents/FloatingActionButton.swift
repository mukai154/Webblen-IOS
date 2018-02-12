//
//  FloatingActionButton.swift
//  WebblenEvents
//
//  Created by Mukai Selekwa on 10/31/17.
//  Copyright © 2018 Webblen. All rights reserved.
//

import UIKit

class FloatingActionButton: UIButtonX {

    override func beginTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
        
        UIView.animate(withDuration: 0.7, animations: {
            if self.transform == .identity {
                self.transform = CGAffineTransform(rotationAngle: 135 * (.pi / 180))
                    }
            else {
                self.transform = .identity
            }
            })
        return super.beginTracking(touch, with: event)
    }

}
