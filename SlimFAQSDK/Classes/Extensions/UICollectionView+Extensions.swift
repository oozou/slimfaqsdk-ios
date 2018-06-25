//
//  UICollectionView+Extensions.swift
//  SlimFAQ-SDK
//
//  Created by Stan Baranouski on 6/20/18.
//  Copyright © 2018 Oozou Limited. All rights reserved.
//

import Foundation

extension UICollectionView {
    
    func registerCell<T: UICollectionViewCell>(_: T.Type) where T: GenericReusableCell {
        self.register(T.nib, forCellWithReuseIdentifier: T.identifier)
    }
    
    func dequeueReusableCell<T>(cellType: T.Type, forIndexPath indexPath: IndexPath) -> T where T: GenericReusableCell {
        guard let cell = dequeueReusableCell(withReuseIdentifier: T.identifier, for: indexPath) as? T else {
            fatalError("Couldn't dequeue cell with identifier \(T.identifier)")
        }
        return cell
    }
    
}
