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
        WhenEngine.homePageDidAppear()
        
        // test
        WhenEngine.userDidLogin()
        WhenEngine.userDidLogout()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

extension ViewController: When {
    
    @_silgen_name("When:ViewController")
    static func When() -> When.Type {
        return self
    }
    
    static func didFinishLaunching(_ options: [UIApplication.LaunchOptionsKey : Any]) {
        print("ViewController:didFinishLaunching")
    }
    
}

struct AStruct: When {
    
    @_silgen_name("When:AStruct")
    static func When() -> When.Type {
        return self
    }
    
    static func didFinishLaunching(_ options: [UIApplication.LaunchOptionsKey : Any]) {
        print("AStruct:didFinishLaunching")
    }
}

enum AEnum: When {
    
    case a
    case b
    
    @_silgen_name("When:AEnum")
    static func When() -> When.Type {
        return self
    }
    
    static func didFinishLaunching(_ options: [UIApplication.LaunchOptionsKey : Any]) {
        print("AEnum:didFinishLaunching")
    }
    
}
