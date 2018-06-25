//
//  Storyboard+Extensions.swift
//  SlimFAQ-SDK
//
//  Created by Stan Baranouski on 6/20/18.
//  Copyright © 2018 Oozou Limited. All rights reserved.
//

import Foundation

protocol StoryboardIdentifiable {
    static var storyboardIdentifier: String { get }
}

extension StoryboardIdentifiable where Self: UIViewController {
    static var storyboardIdentifier: String {
        return String(describing: self)
    }
}

extension UIStoryboard {
    
    func instantiate<T>(viewControllerType: T.Type) -> T where T: StoryboardIdentifiable {
        guard let viewController = self.instantiateViewController(withIdentifier: T.storyboardIdentifier) as? T else {
            fatalError("Couldn't instantiate view controller with identifier \(T.storyboardIdentifier)")
        }
        return viewController
    }
        
}

extension UIStoryboard {
    
    enum Storyboard: String {
        case Contents
        
        var filename: String {
            return rawValue
        }
    }
    
    convenience init(storyboard: Storyboard, bundle: Bundle? = nil) {
        let moduleBundle = bundle ?? Bundle(for: SlimFAQContentsViewController.self)
        self.init(name:storyboard.filename, bundle: moduleBundle)
    }
    
    class func storyboard(storyboard: Storyboard, bundle: Bundle? = nil) -> UIStoryboard {
        return UIStoryboard(name: storyboard.filename, bundle: bundle)
    }
    
}
