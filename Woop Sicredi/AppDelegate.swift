//
//  AppDelegate.swift
//  Woop Sicredi
//
//  Created by Felipe Baggioto on 03/05/20.
//  Copyright © 2020 Sicredi. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    let service = WoopEventsService()
    let navController = UINavigationController()
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        let window = UIWindow(frame: UIScreen.main.bounds)
        
        let viewModel = MainViewModel(service: service, controller: navController)
        let controller = MainViewController(viewModel: viewModel)
        
        navController.addChild(controller)
        
        window.rootViewController = navController
        
        self.window = window
        window.makeKeyAndVisible()
        
        return true
    }
    
}

