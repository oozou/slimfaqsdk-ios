//
//  SlimFAQSDK.swift
//  SlimFAQ-SDK
//
//  Created by Stan Baranouski on 6/19/18.
//  Copyright © 2018 Oozou Limited. All rights reserved.
//

import Foundation

public final class SlimFAQSDK {
    
    public static let shared = SlimFAQSDK()
    private init() {}
    
    private var clientID: String?
    private var presentedViewController: UIViewController?
    
    public func set(clientID: String) {
        self.clientID = clientID
    }
    
    public func present(from viewController: UIViewController, animated: Bool = true, completion: (()->Void)?) throws {
        if let clientID = clientID {
            presentedViewController = SlimFAQContentsViewController.present(from: viewController,
                                                                            clientId: clientID,
                                                                            animated: animated,
                                                                            completion: completion)
        } else {
            throw SlimFAQSDKError.missingClientId
        }
    }
    
}
