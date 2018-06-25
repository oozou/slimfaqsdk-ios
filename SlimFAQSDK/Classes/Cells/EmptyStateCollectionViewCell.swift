//
//  EmptyStateCollectionViewCell.swift
//  SlimFAQ-SDK
//
//  Created by Stan Baranouski on 6/20/18.
//  Copyright © 2018 Oozou Limited. All rights reserved.
//

import UIKit

class EmptyStateCollectionViewCell: UICollectionViewCell {

    @IBOutlet private weak var title: UILabel!
    @IBOutlet private weak var imageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configure(with viewModel: EmptyStateViewModel) {
        title.text = viewModel.title
        imageView.image = viewModel.image
    }

}

extension EmptyStateCollectionViewCell: GenericReusableCell {}

extension EmptyStateCollectionViewCell {
    static func size(for viewModel: EmptyStateViewModel, boundingSize: CGSize) -> CGSize {
        return boundingSize
    }
}
