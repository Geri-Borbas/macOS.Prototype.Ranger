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
    @IBOutlet weak var tableSimulator: TableSimulator!
    

    func applicationDidFinishLaunching(_ notification: Notification)
    {
        app.start()
    }
    
    func applicationShouldTerminate(_ sender: NSApplication) -> NSApplication.TerminateReply
    {
        app.stop()
        return .terminateNow
    }
}

