//
//  ViewController.swift
//  When
//
//  Created by luoqisheng on 07/21/2020.
//  Copyright (c) 2020 luoqisheng. All rights reserved.
//

import UIKit
import When

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        WhenEngine.shared.homePageDidAppear()

        // test
        WhenEngine.shared.userDidLogin()
        WhenEngine.shared.userDidLogout()
        
        // test startup
        WhenEngine.shared.bootstrap()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

public class AClass: AppEventProtocol {
    
    @_silgen_name("When:AClass")
    public static func When() -> When {
        return AClass()
    }
    
    func didFinishLaunching(_ options: [UIApplication.LaunchOptionsKey : Any]) {
        print("AClass:didFinishLaunching")
    }
    
    func homePageDidAppear() {
        print("AClass:homePageDidAppear")
    }
    
}

public struct AStruct: AppEventProtocol {
  
    @_silgen_name("When:AStruct")
    public static func When() -> When {
        return AStruct()
    }
    
    func didFinishLaunching(_ options: [UIApplication.LaunchOptionsKey : Any]) {
        print("AStruct:didFinishLaunching")
    }
    
}

public class AModule: StartUpProtocol {
    
    func bootstrap() {
        print("AModule:bootstrap")
    }
    
    @_silgen_name("When:AModule")
    public static func When() -> When {
        return AModule()
    }
    
    public func dependencies() -> [AnyHashable] {
        return [BModule.identifier()!]
    }
    
    public static func identifier() -> AnyHashable? {
        return "AModule"
    }
    
}

public class BModule: StartUpProtocol {
    
    func bootstrap() {
        print("BModule:bootstrap")
    }
    
    @_silgen_name("When:BModule")
    public static func When() -> When {
        return BModule()
    }
    
    public func dependencies() -> [AnyHashable] {
        return [CModule.identifier()!, "applicationWillResignActive"]
    }
    
    public static func identifier() -> AnyHashable? {
        return "BModule"
    }
    
}

public class CModule: StartUpProtocol {
    
    func bootstrap() {
        print("CModule:bootstrap")
    }
    
    @_silgen_name("When:CModule")
    public static func When() -> When {
        return CModule()
    }
    
    public static func identifier() -> AnyHashable? {
        return "CModule"
    }
    
}
