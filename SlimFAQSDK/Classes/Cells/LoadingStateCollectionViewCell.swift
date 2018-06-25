//
//  LoadingStateCollectionViewCell.swift
//  SlimFAQ-SDK
//
//  Created by Stan Baranouski on 6/20/18.
//  Copyright © 2018 Oozou Limited. All rights reserved.
//

import UIKit

class LoadingStateCollectionViewCell: UICollectionViewCell {

    @IBOutlet private weak var title: UILabel!
    @IBOutlet private weak var activityIndicator: UIActivityIndicatorView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        activityIndicator.hidesWhenStopped = true
    }
    
    func configure(with viewModel: LoadingStateViewModel) {
        title.text = viewModel.title
        activityIndicator.startAnimating()
    }

}

extension LoadingStateCollectionViewCell: GenericReusableCell {}

extension LoadingStateCollectionViewCell {
    static func size(for viewModel: LoadingStateViewModel, boundingSize: CGSize) -> CGSize {
        return boundingSize
    }
}

