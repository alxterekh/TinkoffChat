//
//  AppDelegate.swift
//  TinkoffChat
//
//  Created by Alexander on 03/03/2017.
//  Copyright © 2017 Alexander Terekhov. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
        
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let rootController = storyboard.instantiateViewController(withIdentifier: "MainVC") 
        let frame = UIScreen.main.bounds
        self.window = TouchableWindow(frame: frame)
        guard let window = self.window else {
            assertionFailure("No window!")
            return false
        }
        
        window.rootViewController = rootController
        window.makeKeyAndVisible()
        
        return true
    }
}
