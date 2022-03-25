//
//  NoNetworkViewController.swift
//  BJJHQ
//
//  Created by Asad Mehmood on 25/03/2022.
//  Copyright © 2022 Shopify Inc. All rights reserved.
//

import UIKit

class NoNetworkViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    @IBAction func tryAgainButtonAction(_ sender: UIButton) {
        if Reachability.isConnectedToNetwork() {
            self.navigationController?.popViewController(animated: true)
        }
    }
}
