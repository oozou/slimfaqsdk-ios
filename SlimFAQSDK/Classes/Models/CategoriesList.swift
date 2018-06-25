//
//  CategoryList.swift
//  SlimFAQ-SDK
//
//  Created by Stan Baranouski on 6/20/18.
//  Copyright © 2018 Oozou Limited. All rights reserved.
//

import Foundation

public struct CategoriesList: Codable, JSONPathExtensionAddable {
    public let name: String
    public let url: URL
    public let categories: [Category]
}
