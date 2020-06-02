//
//  AppDelegate.swift
//  PlayerDemo
//
//  Created by apple on 15/2/9.
//  Copyright (c) 2015年 apple. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        AVPLicense.register("cFSOycRSpQaqRo/lC2NkEuxA13qyEwzWNthbOIkZkEClYg/g32G5egC/8xHbLohnmEAg3yRNEMozZuzc38lszTkkkaWctXQ61R84gydGlwD4QEne/rNno/ezKGwTQ8tZiOV16Ittt9zMtsFVW/EyVUmOoOfu3F/rNhy+iJa/Ea9pc88dIyFgrF8/YQMucCpKQfxGvLJrJ6lIPJFWiC8p0EAFaukimaZv6bfXYG5jCEE=")
        
        return true
    }
}

