//
//  Notes.swift
//  Ranger
//
//  Created by Geri Borbás on 2019. 12. 13..
//  Copyright © 2019. Geri Borbás. All rights reserved.
//

import Foundation
import SwiftUI


class Notes
{
    
    
    func Overlay()
    {
        guard let mainWindow = NSApplication.shared.mainWindow
        else { return }
        
        mainWindow.styleMask.remove(.titled)
        mainWindow.styleMask.insert(.resizable)
        mainWindow.orderFront(self)
        mainWindow.isMovableByWindowBackground = true
        mainWindow.level = NSWindow.Level.floating
        mainWindow.isOpaque = false
        mainWindow.backgroundColor = NSColor.clear
    }
    
    func Capture()
    {
        // https://developer.apple.com/documentation/coregraphics/1454852-cgwindowlistcreateimage?language=objc
        // https://stackoverflow.com/questions/21947646/take-screenshots-of-specific-application-window-on-mac
        
        print("Capture window content")
        
        // let screenShot:CGImage? = CGWindowListCreateImage(
        //     CGRect.null,
        //     CGWindowListOption.optionAll, // CGWindowListOption.optionIncludingWindow,
        //     CGWindowID(NSApplication.shared.mainWindow!.windowNumber),
        //     CGWindowImageOption.bestResolution)
        
        // optionAll: CGWindowListOption
        // optionOnScreenOnly: CGWindowListOption
        // optionOnScreenAboveWindow: CGWindowListOption
        // optionOnScreenBelowWindow: CGWindowListOption
        // optionIncludingWindow: CGWindowListOption
        // excludeDesktopElements: CGWindowListOption
        
        // let image = NSImage(cgImage: cgImage!, size: window.frame.size)
    }
}
