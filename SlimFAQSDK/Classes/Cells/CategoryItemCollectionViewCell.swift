//
//  CategoryItemCollectionViewCell.swift
//  SlimFAQ-SDK
//
//  Created by Stan Baranouski on 6/20/18.
//  Copyright © 2018 Oozou Limited. All rights reserved.
//

import UIKit

class CategoryItemCollectionViewCell: UICollectionViewCell {

    @IBOutlet private weak var title: UILabel!
    @IBOutlet private weak var disclosureImageView: UIImageView!
    
    @IBOutlet private weak var separatorLineHeightConstraint: NSLayoutConstraint!
    override func awakeFromNib() {
        super.awakeFromNib()
        disclosureImageView.image = UIImage.slimFAQSDKBundle(imageNamed: "arrowRight")?.withRenderingMode(.alwaysTemplate)
        disclosureImageView.tintColor = UIColor.black.withAlphaComponent(0.75)
        separatorLineHeightConstraint.constant = 0.5
        setNeedsLayout()
        layoutIfNeeded()
    }

    func configure(with viewModel: CategoryItemViewModel) {
        title.text = viewModel.title
    }
    
    func configure(with viewModel: QuestionItemViewModel) {
        title.text = viewModel.title
    }
    
}

extension CategoryItemCollectionViewCell: GenericReusableCell {}

extension CategoryItemCollectionViewCell {
    
    private enum Constants {
        static let minimumCellHeight: CGFloat = 50
        static let titleInsets = UIEdgeInsets(top: 15, left: 15, bottom: 14, right: 40)
        static var titleLabelFont: UIFont {
            let descriptor = UIFontDescriptor.preferredFontDescriptor(withTextStyle: UIFontTextStyle.headline)
            return UIFont.systemFont(ofSize: descriptor.pointSize, weight: UIFont.Weight.medium)
        }
    }
    
    static func size(for viewModel: CategoryItemViewModel, boundingWidth: CGFloat) -> CGSize {
        return size(for: viewModel.title, boundingWidth: boundingWidth)
    }
    
    static func size(for viewModel: QuestionItemViewModel, boundingWidth: CGFloat) -> CGSize {
        return size(for: viewModel.title, boundingWidth: boundingWidth)
    }
    
    static func size(for title: String, boundingWidth: CGFloat) -> CGSize {
        let insets = Constants.titleInsets
        let font = Constants.titleLabelFont
        
        let titleWidth = boundingWidth - (insets.left + insets.right)
        let titleHeight = title.heightWithConstrainedWidth(width: titleWidth, font: font)
        let totalHeight = ceil(max(Constants.minimumCellHeight, (insets.top + ceil(titleHeight) + insets.bottom)))
        
        return CGSize(width: boundingWidth, height: totalHeight)
    }
    
}
