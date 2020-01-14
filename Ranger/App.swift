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
    
    static var configuration: App.Configuration = App.Configuration.load()
    
    
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
        
        let isTourneyTableWindow = tableWindowInfo.tableInfo != nil
        let isSameTourney = tableWindowController?.tableWindowInfo?.tableInfo?.tournamentNumber == tableWindowInfo.tableInfo?.tournamentNumber
        
        // Window (do not create new window on table seating changes).
        if (isTourneyTableWindow && isSameTourney)
        { windowTrackerDidUpdateTableWindowInfo(tableWindowInfo: tableWindowInfo) }
        else
        { tableWindowController = TourneyTableWindowController.instantiateAndShow(forTableWindowInfo: tableWindowInfo) }
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
        
        // Turn back dragging.
        if let tableWindow = tableWindowController?.window
        { tableWindow.isMovable = true }
        
        // Close window if any (if opted-in).
        if let tableWindowController = tableWindowController, App.configuration.autoCloseTableWindow
        { tableWindowController.close() }
    }
    
}
