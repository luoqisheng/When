//
//  WhenProtocol.swift
//  Pods-When_Example
//
//  Created by luoqisheng on 2020/7/21.
//

import Foundation

public protocol When {
    
    // required
    static func When() -> When.Type
    
    // events
    static func willFinishLaunching(_ options: [UIApplication.LaunchOptionsKey : Any]) -> Void
    
    static func didFinishLaunching(_ options: [UIApplication.LaunchOptionsKey : Any]) -> Void
    
    static func homePageDidAppear() -> Void
    
    static func userDidLogin() -> Void
    
    static func userDidLogout() -> Void
}

public extension When {
    
    static func willFinishLaunching(_ options: [UIApplication.LaunchOptionsKey : Any]) -> Void { }
    
    static func didFinishLaunching(_ options: [UIApplication.LaunchOptionsKey : Any]) -> Void { }
    
    static func homePageDidAppear() -> Void { }
    
    static func userDidLogin() -> Void { }
    
    static func userDidLogout() -> Void { }
    
}
