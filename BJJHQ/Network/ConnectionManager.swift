//
//  ConnectionManager.swift
//  EasyGift
//
//  Created by Asad Mehmood on 20/12/2021.
//  Copyright © 2021 codesrbit. All rights reserved.
//

import Network
import UIKit

final class ConnectionManager {
    
    static let shared = ConnectionManager()
    
    private let queue = DispatchQueue(label: "Monitor")
    private let monitor: NWPathMonitor
    
    public private(set) var isConnected: Bool = false
    
    private init() {
        monitor = NWPathMonitor()
    }
    
    public func startMonitoring() {
        monitor.start(queue: queue)
        monitor.pathUpdateHandler = { [weak self] path in
            self?.isConnected = (path.status == .satisfied)
            
            if let connected = self?.isConnected {
                if connected {
                    DispatchQueue.main.async {
                        if let topController = UIApplication.topViewController() {
                            if topController is NoNetworkViewController {
                                if let networkController = topController as? NoNetworkViewController {
                                    if let navController = networkController.navigationController {
                                        navController.popViewController(animated: true)
                                    }
                                    else {
                                        networkController.dismiss(animated: true, completion: nil)
                                    }
                                }
                            }
                        }
                    }
                }
                else {
                    DispatchQueue.main.async {
                        if let topController = UIApplication.topViewController() {
                            if !(topController is NoNetworkViewController) {
                            
                                if let navController = UIApplication.topViewController()?.navigationController {
                                    navController.pushViewController(NoNetworkViewController(), animated: true)
                                }
                                else {
                                    let noNetworkScreen = NoNetworkViewController()
                                    noNetworkScreen.modalPresentationStyle = .fullScreen
                                    UIApplication.topViewController()?.present(noNetworkScreen, animated: true, completion: nil)
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    
    public func stop() {
        monitor.cancel()
    }
    
}
