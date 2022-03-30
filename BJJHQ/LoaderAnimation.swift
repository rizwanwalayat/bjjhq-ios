//
//  LoaderAnimation.swift
//  CarrierApp
//
//  Created by Phaedra Solutions  on 27/08/2021.
//  Copyright © 2021 codesrbit. All rights reserved.
//

import Foundation
import Lottie

class LoaderAnimation: NSObject {
    
    static var shared = LoaderAnimation()
    private var animationView: AnimationView?
    private var superView: UIView
    
    private override init() {
        
        superView = UIView(frame: CGRect(x: 0, y: 0, width: kApplicationWindow?.frame.width ?? 0.0, height: kApplicationWindow?.frame.height ?? 0.0))
        
        animationView = .init(name: "loader")
        animationView!.frame = superView.bounds
        animationView!.contentMode = .scaleAspectFit
        animationView!.loopMode = .loop
        
        superView.tag = 9000
        superView.backgroundColor = UIColor.black.withAlphaComponent(0.8)
        superView.addSubview(animationView!)
        
        super.init()
        
    }
    
    func playAnimation() {
        DispatchQueue.main.async {
            self.animationView!.play()
            kApplicationWindow?.addSubview(self.superView)

        }
    }
    
    func stopAnimation(){
        
        DispatchQueue.main.async {
            self.animationView!.stop()
            
            if let activityView = kApplicationWindow?.viewWithTag(9000) {
                activityView.removeFromSuperview()
            }
            
        }
    }
}
