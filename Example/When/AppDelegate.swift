//
//  AppDelegate.swift
//  When
//
//  Created by luoqisheng on 07/21/2020.
//  Copyright (c) 2020 luoqisheng. All rights reserved.
//

import UIKit
import When

protocol AppEventProtocol: When {
    
    func didFinishLaunching(_ options: [UIApplication.LaunchOptionsKey : Any]) -> Void
    
    func homePageDidAppear() -> Void
    
    func userDidLogin() -> Void
    
    func userDidLogout() -> Void
}

extension AppEventProtocol {
        
    func didFinishLaunching(_ options: [UIApplication.LaunchOptionsKey : Any]) -> Void { }
    
    func homePageDidAppear() -> Void { }
    
    func userDidLogin() -> Void { }
    
    func userDidLogout() -> Void { }
    
}

extension WhenEngine: AppEventProtocol {
    
    func didFinishLaunching(_ options: [UIApplication.LaunchOptionsKey : Any]) {
        WhenEngine.broadcast(protocol: AppEventProtocol.self) { observers in
            observers.didFinishLaunching(options)
        }
    }
    
    func homePageDidAppear() {
        WhenEngine.broadcast(protocol: AppEventProtocol.self) { observers in
            observers.homePageDidAppear()
        }
    }
    
    func userDidLogin() -> Void {
        WhenEngine.broadcast(protocol: AppEventProtocol.self) { observers in
            observers.userDidLogin()
        }
    }
    
    func userDidLogout() -> Void {
        WhenEngine.broadcast(protocol: AppEventProtocol.self) { observers in
            observers.userDidLogout()
        }
    }
    
}

protocol StartUpProtocol: WhenTask {
    
    func bootstrap() -> Void
    
}

extension WhenEngine: StartUpProtocol {
    
    func bootstrap() {
        WhenEngine.broadcast(protocol: StartUpProtocol.self) { (observers) in
            observers.bootstrap()
        }
        
        WhenEngine.broadcast { (when) in
            if let when = when as? OCStartUpProtocol {
                when.bootstrap?()
            }
        }
    }
    
}

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    var willResignActive: Milestone = Milestone(identifier: "applicationWillResignActive") {
        print("applicationWillResignActive")
    }
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        WhenEngine.shared.setup(milestones: [self.willResignActive])
        WhenEngine.shared.didFinishLaunching(launchOptions ?? [:])
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
        self.willResignActive.start()
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

