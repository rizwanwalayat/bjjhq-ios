//
//  desigview.swift
//  Interactive Wall
//
//  Created by Umer Khalid on 22/10/2018.
//  Copyright © 2018 Nomi Malik. All rights reserved.
//


import UIKit

class CustomView: UIView {
    
    var shadowLayer: CAShapeLayer!
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if shadowLayer == nil {
            shadowLayer = CAShapeLayer()
            shadowLayer.path = UIBezierPath(roundedRect: bounds, cornerRadius: 0).cgPath
            shadowLayer.fillColor = UIColor.white.cgColor//UIColor(red: 166/255, green: 229/255, blue: 244/255, alpha: 1.0).cgColor
            
            shadowLayer.shadowColor = UIColor.darkGray.cgColor
            shadowLayer.shadowPath = shadowLayer.path
            shadowLayer.shadowOffset = CGSize(width: 2.0, height: 2.0)
            shadowLayer.shadowOpacity = 0.8
            shadowLayer.shadowRadius = 10
            
            layer.insertSublayer(shadowLayer, at: 0)
            //layer.insertSublayer(shadowLayer, below: nil) // also works
        }
    }
}

@IBDesignable
class CcardView: UIView {
    
    @IBInspectable var cornerRadius: CGFloat = 2
    
    @IBInspectable var SshadowOffsetWidth: Int = 0
    @IBInspectable var SshadowOffsetHeight: Int = 3
    @IBInspectable var shadowColor: UIColor? = UIColor.black
    @IBInspectable var SshadowOpacity: Float = 0.5
    
    
    override func layoutSubviews() {
        layer.cornerRadius = cornerRadius
        let SshadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: cornerRadius)
        
        layer.masksToBounds = false
        layer.shadowColor = shadowColor?.cgColor
        layer.shadowOffset = CGSize(width: SshadowOffsetWidth, height: SshadowOffsetHeight);
        layer.shadowOpacity = SshadowOpacity
        layer.shadowPath = SshadowPath.cgPath
    }
    
}


