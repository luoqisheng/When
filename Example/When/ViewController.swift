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

class AClass: AppEventProtocol {
    
    @_silgen_name("When:AClass")
    static func When() -> When {
        return AClass()
    }
    
    func didFinishLaunching(_ options: [UIApplication.LaunchOptionsKey : Any]) {
        print("AClass:didFinishLaunching")
    }
    
    func homePageDidAppear() {
        print("AClass:homePageDidAppear")
    }
    
}

struct AStruct: AppEventProtocol {
  
    @_silgen_name("When:AStruct")
    static func When() -> When {
        return AStruct()
    }
    
    func didFinishLaunching(_ options: [UIApplication.LaunchOptionsKey : Any]) {
        print("AStruct:didFinishLaunching")
    }
    
}

class AModule: StartUpProtocol {
    
    func bootstrap() {
        print("AModule:bootstrap")
    }
    
    @_silgen_name("When:AModule")
    static func When() -> When {
        return AModule()
    }
    
    func dependencies() -> [AnyHashable] {
        return [BModule.identifier()!]
    }
    
    static func identifier() -> AnyHashable? {
        return "AModule"
    }
    
}

class BModule: StartUpProtocol {
    
    func bootstrap() {
        print("BModule:bootstrap")
    }
    
    @_silgen_name("When:BModule")
    static func When() -> When {
        return BModule()
    }
    
    func dependencies() -> [AnyHashable] {
        return [CModule.identifier()!, "applicationWillResignActive"]
    }
    
    static func identifier() -> AnyHashable? {
        return "BModule"
    }
    
}

class CModule: StartUpProtocol {
    
    func bootstrap() {
        print("CModule:bootstrap")
    }
    
    @_silgen_name("When:CModule")
    static func When() -> When {
        return CModule()
    }
    
    static func identifier() -> AnyHashable? {
        return "CModule"
    }
    
}
