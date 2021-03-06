//
//  SplashViewController.swift
//  inQibla
//
//  Created by HaiDer's Macbook Pro on 06/01/2022.
//

import UIKit
import Lottie

class SplashViewController: BaseViewController {
    
    
    //MARK: - Variables
    
    private var animationView: AnimationView?
    
    
    //MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        startAnimatedView()
    }
    
    
    //MARK: - Functions
    
    func startAnimatedView() {
        animationView = .init(name: "loader")
        animationView?.backgroundColor = .clear
        animationView!.frame = CGRect(x: 0, y: 0, width: 200, height: 500)
        animationView!.contentMode = .center
        animationView!.loopMode = .loop
        animationView!.animationSpeed = 1
        
        animationView?.play(completion: { complete in
            if complete {
                if DataManager.shared.getUser() != nil {
                    self.coordinator?.homePage()
                }
                else {
                    self.coordinator?.landingPage()
                }
            }
        })
        
        view.addSubview(animationView!)
        
    }
}
