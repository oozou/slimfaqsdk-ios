//
//  JSONPathExtensionAddable.swift
//  SlimFAQ-SDK
//
//  Created by Stan Baranouski on 6/20/18.
//  Copyright © 2018 Oozou Limited. All rights reserved.
//

import Foundation

public protocol JSONPathExtensionAddable {
    var url: URL { get }
}

extension JSONPathExtensionAddable {
    public var jsonURL: URL { return url.appendingPathExtension("json") }
}
