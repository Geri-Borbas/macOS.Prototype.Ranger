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

    
    @IBOutlet weak var app: App!
    

    func applicationDidFinishLaunching(_ notification: Notification)
    {
        app.start()
    }
}

