//
//  ReusableNib.swift
//  SlimFAQ-SDK
//
//  Created by Stan Baranouski on 6/20/18.
//  Copyright © 2018 Oozou Limited. All rights reserved.
//

import Foundation

protocol UIViewNibLoadable: class {
    static var nib: UINib { get }
}

extension UIViewNibLoadable where Self: UIView {
    static var nib: UINib {
        let className = String(describing: self)
        let bundle: Bundle = Bundle(for: self)
        return UINib(nibName: className, bundle: bundle)
    }
}

protocol UIViewIdentifiable: class {
    static var identifier: String { get }
}

extension UIViewIdentifiable where Self: UIView {
    static var identifier: String {
        return String(describing: self)
    }
}

typealias GenericReusableCell = UIViewNibLoadable & UIViewIdentifiable
