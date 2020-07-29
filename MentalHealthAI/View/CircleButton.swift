//
//  CircleButton.swift
//  MentalHealthAI
//
//  Created by Parikshat Sawant on 7/7/20.
//  Copyright © 2020 Sawant,Inc. All rights reserved.
//

import UIKit

@IBDesignable
class CircleButton: UIButton {

    @IBInspectable var cornerRadius: CGFloat = 30.0 {
        didSet {
            layer.cornerRadius = cornerRadius
        }
    }
    
    override func prepareForInterfaceBuilder() {
        layer.cornerRadius = cornerRadius
    }

}
