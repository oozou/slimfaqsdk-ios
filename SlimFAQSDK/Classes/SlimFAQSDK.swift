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
    
    private var clientId: String?
    private var presentedViewController: UIViewController?
    
    public func set(clientId: String) {
        self.clientId = clientId
    }
    
    /**
     Presents SlimFAQ navigation controller instance with modal presentation style ".overCurrentContext".
    */
    public func present(from viewController: UIViewController, animated: Bool = true, completion: (()->Void)?) throws {
        if let clientId = clientId, !clientId.isEmpty {
            presentedViewController = SlimFAQContentsViewController.present(from: viewController,
                                                                            clientId: clientId,
                                                                            animated: animated,
                                                                            completion: completion)
        } else {
            throw SlimFAQSDKError.missingClientId
        }
    }
    
    /**
     Returns SlimFAQ navigation controller instance in order to provide more flexibility over custom transition.
     */
    public func instantiateFAQViewController() -> UIViewController? {
        if let clientId = clientId, !clientId.isEmpty {
            return SlimFAQContentsViewController.instantiate(with: clientId)
        } else {
            return nil
        }
    }
    
}
