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
    private var tableWindowController: TourneyTableWindowController?
    
    
    func start()
    {
        // Subscribe window updates.
        windowTracker.delegate = self
        windowTracker.start()
    }
    
    
    // MARK: - Track tables
    
    func windowTrackerDidStartTrackingTable(tableWindowInfo: TableWindowInfo)
    {
        // Status.
        tablesStatusBarItem.indicateTracking(windowTitle: tableWindowInfo.name)
        
        // Window.
        tableWindowController = TourneyTableWindowController.instantiateAndShow(forTableWindowInfo: tableWindowInfo)
    }
    
    func windowTrackerDidUpdateTableWindowInfo(tableWindowInfo: TableWindowInfo)
    {
        // Only if any.
        guard let tableWindowController = tableWindowController else { return }
        
        // Update.
        tableWindowController.update(with: tableWindowInfo)
    }
    
    func windowTrackerDidStopTrackingTable(tableWindowInfo: TableWindowInfo)
    {
        // UI.
        tablesStatusBarItem.stopIndicateTracking()
        
        // Close window if any.
        if let tableWindowController = tableWindowController
        { tableWindowController.close() }
    }
    
}
