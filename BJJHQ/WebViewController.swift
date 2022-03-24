//
//  WebViewController.swift
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
import WebKit

class WebViewController: BaseViewController, WKNavigationDelegate{
    
    let url: URL
    let accessToken: String?
    
    private let webView = WKWebView(frame: .zero)
    
    // ----------------------------------
    //  MARK: - Init -
    //
    init(url: URL, accessToken: String?) {
        self.url         = url
        self.accessToken = accessToken
        
        super.init(nibName: nil, bundle: nil)
        
        self.initialize()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
    func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
        print("Start loading")
    }

    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        webView.evaluateJavaScript("document.documentElement.outerHTML.toString()",
                                   completionHandler: { (html: Any?, error: Error?) in
            let stringHtml = html as? String
            let contains = stringHtml?.contains("Thank you \(DataManager.shared.getUser()!.user!.first_name)")
            if contains ?? false {
                DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                    self.coordinator?.homePage()
                }
            }
        })
    }
    
    private func initialize() {
        self.webView.navigationDelegate = self
        self.webView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(self.webView)
        
        NSLayoutConstraint.activate([
            self.webView.leftAnchor.constraint(equalTo: self.view.leftAnchor),
            self.webView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            self.webView.rightAnchor.constraint(equalTo: self.view.rightAnchor),
            self.webView.topAnchor.constraint(equalTo: self.view.topAnchor),
        ])
        
        self.load(url: self.url)
    }
    
    // ----------------------------------
    //  MARK: - Request -
    //
    private func load(url: URL) {
        var request = URLRequest(url: self.url)
        
        if let accessToken = self.accessToken {
            request.setValue(accessToken, forHTTPHeaderField: "X-Shopify-Customer-Access-Token")
        }
        
        self.webView.load(request)
    }
}
