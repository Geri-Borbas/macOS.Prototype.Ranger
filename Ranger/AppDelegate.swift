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


    func applicationDidFinishLaunching(_ aNotification: Notification)
    {
        // Window setup.
        let mainWindow:NSWindow? = NSApplication.shared.mainWindow
        
        mainWindow?.styleMask.remove(.titled)
        mainWindow?.styleMask.insert(.resizable)
        mainWindow?.orderFront(self)
        
        mainWindow?.isMovableByWindowBackground = true
        mainWindow?.level = NSWindow.Level.floating
        
        mainWindow?.isOpaque = false
        mainWindow?.backgroundColor = NSColor.clear
    }
}

