//
//  ViewController.swift
//  SlimFAQSDK
//
//  Created by freemansion on 06/25/2018.
//  Copyright (c) 2018 freemansion. All rights reserved.
//

import UIKit
import SlimFAQSDK

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let clientID = "slimwiki"
        SlimFAQSDK.shared.set(clientID: clientID)
    }

    @IBAction func faqButtonAction(_ sender: Any) {
        do {
            try SlimFAQSDK.shared.present(from: self, animated: true, completion: nil)
        } catch {
            print("an error occured: \(error.localizedDescription)")
        }
    }

}

