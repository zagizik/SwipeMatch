//
//  AppDelegate.swift
//  SwipeMatch
//
//  Created by Александр Банников on 25.10.2020.
//

import UIKit

import UIKit

@UIApplicationMain
 class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        window = UIWindow()
        window?.makeKeyAndVisible()
        window?.rootViewController = RegistrationController()
        
        return true
    }
}
