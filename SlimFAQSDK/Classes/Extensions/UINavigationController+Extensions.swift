//
//  UINavigationController+Extensions.swift
//  SlimFAQ-SDK
//
//  Created by Stan Baranouski on 6/21/18.
//  Copyright © 2018 Oozou Limited. All rights reserved.
//

import Foundation

extension UINavigationController {
    
    func push(_ viewController: UIViewController, animated: Bool = true, completion:(()->Void)?) {
        CATransaction.begin()
        CATransaction.setCompletionBlock {
            completion?()
        }
        pushViewController(viewController, animated: animated)
        CATransaction.commit()
    }
    
}
