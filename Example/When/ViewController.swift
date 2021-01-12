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
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

class AClass: AppEventProtocol {
    
    @_silgen_name("When:ViewController")
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

struct AStruct: When {
  
    @_silgen_name("When:AStruct")
    static func When() -> When {
        return AStruct()
    }
    
    func didFinishLaunching(_ options: [UIApplication.LaunchOptionsKey : Any]) {
        print("AStruct:didFinishLaunching")
    }
    
}
