//
//  AppDelegate.swift
//  Storefront
//
//  Created by Shopify.
//  Copyright (c) 2017 Shopify Inc. All rights reserved.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.
//

import UIKit
import IQKeyboardManagerSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var coordinator: MainCoordinator?
    // ----------------------------------
    //  MARK: - Application Launch -
    //
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        /* ----------------------------------------
         ** Initialize the cart controller and pre-
         ** load any cached cart items.
         */
        _ = CartController.shared
//        Thread.sleep(forTimeInterval: 0.5)
//                let navController = UINavigationController()
//                coordinator = MainCoordinator(navigationController: navController)
//                IQKeyboardManager.shared.enable = true
//                IQKeyboardManager.shared.shouldResignOnTouchOutside = true
//
//
//                //MARK: - UserState
//                if DataManager.shared.getUser() ?? false {
//
//                    coordinator?.homePage()
//
//                }
//                else {
//                    coordinator?.landedPage()
//                }
//
//                window = UIWindow(frame: UIScreen.main.bounds)
//                window?.rootViewController = navController
//                window?.makeKeyAndVisible()
//
        return true
    }
}

