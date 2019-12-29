//
//  File.swift
//  Ranger
//
//  Created by Geri Borbás on 2019. 12. 29..
//  Copyright © 2019. Geri Borbás. All rights reserved.
//

import Foundation
import SwiftUI


class App: TableTrackerDelegate
{
    
    
    private var tablesStatusBarItem: TablesStatusBarItem = TablesStatusBarItem()
    private var windowTracker: TableTracker = TableTracker()
    private var appWindow: NSWindow?
    
    
    func start()
    {
        // First window is status bar item.
        self.appWindow = NSApplication.shared.windows[1]
        
        // Subscribe window updates.
        windowTracker.delegate = self
        windowTracker.start()
    }
    
    
    // MARK: - WindowTracker
    
    func windowTrackerDidStartTrackingTable(tableWindowInfo: TableWindowInfo)
    {
        // Prevent drag.
        appWindow?.isMovable = false
        
        // UI.
        tablesStatusBarItem.indicateTracking(windowTitle: tableWindowInfo.name)
    }
    
    func windowTrackerDidUpdateTableWindowInfo(tableWindowInfo: TableWindowInfo)
    {
        // Only if any.
        guard let appWindow = appWindow
        else { return }
        
        // Align.
        appWindow.setFrame(
            NSRect(
                x: tableWindowInfo.UIKitBounds.origin.x,
                y: tableWindowInfo.UIKitBounds.origin.y - appWindow.frame.size.height,
                width: tableWindowInfo.UIKitBounds.size.width,
                height: appWindow.frame.size.height
            ),
            display: true
        )
                 
         // Put above.
         appWindow.order(NSWindow.OrderingMode.above, relativeTo: tableWindowInfo.number)
    }
    
    func windowTrackerDidStopTrackingTable(tableWindowInfo: TableWindowInfo)
    {
        // Enable drag.
        appWindow?.isMovable = true
        
        // UI.
        tablesStatusBarItem.stopIndicateTracking()
    }
    
}
