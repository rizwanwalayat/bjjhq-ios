//
//  AuthorizationAppleIDButton.swift
//  Karwan-e-Najia
//
//  Created by Asad Mehmood on 22/03/2022.
//  Copyright © 2022 karwan-e-najia. All rights reserved.
//

import UIKit
import AuthenticationServices

@IBDesignable
class AuthorizationAppleIDButton: UIButton {
    
    private var authorizationButton: ASAuthorizationAppleIDButton!
    
    @IBInspectable
    var authButtonType: Int = ASAuthorizationAppleIDButton.ButtonType.default.rawValue
    
    @IBInspectable
    var authButtonStyle: Int = ASAuthorizationAppleIDButton.Style.black.rawValue
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override public func draw(_ rect: CGRect) {
        super.draw(rect)

        // Create ASAuthorizationAppleIDButton
        let type = ASAuthorizationAppleIDButton.ButtonType.init(rawValue: authButtonType) ?? .default
        let style = ASAuthorizationAppleIDButton.Style.init(rawValue: authButtonStyle) ?? .black
        authorizationButton = ASAuthorizationAppleIDButton(authorizationButtonType: type,
                                                           authorizationButtonStyle: style)

        // Set selector for touch up inside event so that can forward the event to MyAuthorizationAppleIDButton
        authorizationButton.addTarget(self, action: #selector(authorizationAppleIDButtonTapped(_:)), for: .touchUpInside)

        // Show authorizationButton
        addSubview(authorizationButton)

        // Use autolayout to make authorizationButton follow the MyAuthorizationAppleIDButton's dimension
        authorizationButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            authorizationButton.topAnchor.constraint(equalTo: self.topAnchor, constant: 0.0),
            authorizationButton.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 0.0),
            authorizationButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 0.0),
            authorizationButton.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0.0),
        ])
    }
    
    @objc func authorizationAppleIDButtonTapped(_ sender: Any) {
        // Forward the touch up inside event to MyAuthorizationAppleIDButton
        sendActions(for: .touchUpInside)
    }
}
