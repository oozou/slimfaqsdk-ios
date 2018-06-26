//
//  ViewController.swift
//  SlimFAQSDK
//
//  Created by freemansion on 06/25/2018.
//  Copyright (c) 2018 freemansion. All rights reserved.
//

import UIKit
import SlimFAQSDK
import ZFDragableModalTransition

class ViewController: UIViewController {
    
    enum FAQPresentationStyle: String {
        case `default`
        case custom
    }

    @IBOutlet weak var presentationValueLabel: UILabel!
    @IBOutlet weak var switchControl: UISwitch!
    var animator: ZFModalTransitionAnimator?
    
    private var presentationStyle: FAQPresentationStyle = .default {
        didSet {
            presentationValueLabel.text = presentationStyle.rawValue
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let clientId = "slimwiki"
        SlimFAQSDK.shared.set(clientId: clientId)
        switchControl.isOn = false
    }

    @IBAction func switchAction(_ sender: UISwitch) {
        if sender.isOn {
            presentationStyle = .custom
        } else {
            presentationStyle = .default
        }
    }
    
    @IBAction func faqButtonAction(_ sender: Any) {
        presentFAQScreen(style: presentationStyle)
    }
    
    private func presentFAQScreen(style: FAQPresentationStyle) {
        switch style {
        case .default:
            do {
                try SlimFAQSDK.shared.present(from: self, animated: true, completion: nil)
            } catch {
                print("an error occured: \(error.localizedDescription)")
            }
        case .custom:
            if let slimFAQViewController = SlimFAQSDK.shared.instantiateFAQViewController() {
                
                if let animator = ZFModalTransitionAnimator(modalViewController: slimFAQViewController) {
                    animator.isDragable = true
                    animator.bounces = true
                    animator.behindViewAlpha = 0.5
                    animator.behindViewScale = 0.5
                    animator.transitionDuration = 0.7
                    animator.direction = .right
                    self.animator = animator
                }
                
                slimFAQViewController.transitioningDelegate = self.animator
                present(slimFAQViewController, animated: true, completion: nil)
            }
        }
    }

}

