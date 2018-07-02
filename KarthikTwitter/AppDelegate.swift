//
//  AppDelegate.swift
//  KarthikTwitter
//
//  Created by Karthikeyan A. on 29/06/18.
//  Copyright © 2018 Karthikeyan A. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        // handle call back
        Wrapper.shared.handle(open: url)
        return true
    }

    


}

