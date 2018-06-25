//
//  Bundle.swift
//  SlimFAQ-SDK
//
//  Created by Stan Baranouski on 6/21/18.
//  Copyright © 2018 Oozou Limited. All rights reserved.
//

import Foundation

extension Bundle {
    internal static var sdkVersion: String {
        guard let version = slimFAQSDKBundle.infoDictionary?["CFBundleShortVersionString"] as? String else {
            return ""
        }
        return version
    }
    
    internal class var slimFAQSDKBundle: Bundle {
        return Bundle(for: SlimFAQSDK.self)
    }
}
