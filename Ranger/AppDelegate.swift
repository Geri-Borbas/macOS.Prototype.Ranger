//
//  AppDelegate.swift
//  Ranger
//
//  Created by Geri Borbás on 2019. 12. 02..
//  Copyright © 2019. Geri Borbás. All rights reserved.
//

import Cocoa


@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate
{

    
    var app: App = App()
    

    func applicationDidFinishLaunching(_ notification: Notification)
    {
        app.start()
    }
}

