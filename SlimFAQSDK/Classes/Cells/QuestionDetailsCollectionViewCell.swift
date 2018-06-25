//
//  QuestionDetailsCollectionViewCell.swift
//  SlimFAQ-SDK
//
//  Created by Stan Baranouski on 6/21/18.
//  Copyright © 2018 Oozou Limited. All rights reserved.
//

import UIKit
import WebKit

class QuestionDetailsCollectionViewCell: UICollectionViewCell {
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var updatedAtLabel: UILabel!
    @IBOutlet private weak var webViewContainer: UIView!
    private lazy var webView: WKWebView = {
        let preferences = WKPreferences()
        preferences.javaScriptEnabled = false
        let configuration = WKWebViewConfiguration()
        configuration.preferences = preferences
        let webView = WKWebView(frame: webViewContainer.bounds, configuration: configuration)
        webView.translatesAutoresizingMaskIntoConstraints = false
        return webView
    }()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        configureWebView()
    }
    
    private func configureWebView() {
        webViewContainer.addSubview(webView)
        NSLayoutConstraint.activate([
            webView.topAnchor.constraint(equalTo: webViewContainer.topAnchor),
            webView.leadingAnchor.constraint(equalTo: webViewContainer.leadingAnchor),
            webView.bottomAnchor.constraint(equalTo:webViewContainer.bottomAnchor),
            webView.trailingAnchor.constraint(equalTo: webViewContainer.trailingAnchor)
            ])
    }
    
    func configure(with viewModel: QuestionDetailsViewModel) {
        titleLabel.text = viewModel.name
        updatedAtLabel.text = viewModel.updatedText        
        webView.loadHTMLString(viewModel.htmlContent, baseURL: nil)
    }

}

extension QuestionDetailsCollectionViewCell: GenericReusableCell {}

extension QuestionDetailsCollectionViewCell {
    
    static func size(for viewModel: QuestionDetailsViewModel, boundingSize: CGSize) -> CGSize {
        return boundingSize
    }
    
}
