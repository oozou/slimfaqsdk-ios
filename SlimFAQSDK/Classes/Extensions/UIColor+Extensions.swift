//
//  UIColor+Extensions.swift
//  SlimFAQ-SDK
//
//  Created by Stan Baranouski on 6/21/18.
//  Copyright © 2018 Oozou Limited. All rights reserved.
//

import Foundation

extension UIColor {
    
    internal class var systemBlue: UIColor {
        return UIButton(type: .system).tintColor
    }
    
}
