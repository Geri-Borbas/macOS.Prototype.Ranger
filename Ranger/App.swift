//
//  File.swift
//  Ranger
//
//  Created by Geri Borbás on 2019. 12. 29..
//  Copyright © 2019. Geri Borbás. All rights reserved.
//

import Foundation
import SwiftUI


/// The root application controller object.
class App: NSObject, TableTrackerDelegate, StatusBarItemDelegate
{
    
    
    private var statusBarItem: StatusBarItem = StatusBarItem()
    private var windowTracker: TableTracker = TableTracker()
    private var tableWindowController: TournamentWindowController?
    
    static var configuration: App.Configuration = App.Configuration.load()
    
    
    func start()
    {
        // Subscribe window updates.
        windowTracker.delegate = self
        windowTracker.start()
        
        // Subscribe status bar item updates.
        statusBarItem.delegate = self
    }
    
    
    // MARK: - Menu Events
    
    @IBAction func openCachedPlayersDidClick(_ sender: AnyObject)
    {
        // Instantiate window.
        let window = PlayersWindowController.instantiateAndShow(
            withPlayers: Model.Players.cachedPlayers(),
            hiddenColumnIdentifiers: ["Seat", "Stack"]
        )
        
        // Add menu item.
        if let window = window
        { NSApp.addWindowsItem(window, title: "Cached Players", filename: false) }
    }
    
    @IBAction func openRegsDidClick(_ sender: AnyObject)
    {
        // Instantiate window.
        let window = PlayersWindowController.instantiateAndShow(
                withPlayers: Model.Players.regs(),
                hiddenColumnIdentifiers: ["Seat", "Stack"]
        )
        
        // Add menu item.
        if let window = window
        { NSApp.addWindowsItem(window, title: "Regs", filename: false) }
    }
    
    
    // MARK: - Status Bar Item Events
    
    func statusBarItemClicked(menuItem: StatusBarItem.MenuItem)
    {
        switch menuItem
        {
            case StatusBarItem.MenuItem.openCachedPlayers:
                print("StatusBarItem.MenuItem.openCachedPlayers")
            case StatusBarItem.MenuItem.openRegs:
                print("StatusBarItem.MenuItem.openRegs")
            default:
                print("No window controller for menu item \(menuItem.title).")
        }
    }
    
    
    // MARK: - Track tables
    
    func windowTrackerDidStartTrackingTable(tableWindowInfo: TableWindowInfo)
    {
        // Status.
        statusBarItem.indicateTracking(windowTitle: tableWindowInfo.name)
        
        let isTourneyTableWindow = tableWindowInfo.tableInfo != nil
        let isSameTourney = tableWindowController?.tableWindowInfo?.tableInfo?.tournamentNumber == tableWindowInfo.tableInfo?.tournamentNumber
        
        // Window (do not create new window on table seating changes).
        if (isTourneyTableWindow && isSameTourney)
        {
            // Only update.
            windowTrackerDidUpdateTableWindowInfo(tableWindowInfo: tableWindowInfo)
        }
        else
        {
            // Instantiate new tournament window.
            tableWindowController = TournamentWindowController.instantiateAndShow(forTableWindowInfo: tableWindowInfo)
            
            // Add menu item.
            if let window = tableWindowController?.window
            {
                let menuItemTitle = "Tournament \(tableWindowInfo.tableInfo?.tournamentNumber ?? "(?)") Table \(String(tableWindowInfo.tableInfo?.tableNumber ?? 0))"
                NSApp.addWindowsItem(window, title: menuItemTitle, filename: false)
            }
        }
    }
    
    func windowTrackerDidUpdateTableWindowInfo(tableWindowInfo: TableWindowInfo)
    {
        // Only if any.
        guard let tableWindowController = tableWindowController else { return }
        
        // Update tournament window.
        tableWindowController.update(with: tableWindowInfo)
        
        // Update menu item.
        if let window = tableWindowController.window
        {
            let menuItemTitle = "Tournament \(tableWindowInfo.tableInfo?.tournamentNumber ?? "(?)") Table \(String(tableWindowInfo.tableInfo?.tableNumber ?? 0))"
            NSApp.changeWindowsItem(window, title: menuItemTitle, filename: false)
        }
    }
    
    func windowTrackerDidStopTrackingTable(tableWindowInfo: TableWindowInfo)
    {
        // UI.
        statusBarItem.stopIndicateTracking()
        
        // Turn back dragging.
        if let tableWindow = tableWindowController?.window
        { tableWindow.isMovable = true }
        
        // Close window if any (if opted-in).
        if let tableWindowController = tableWindowController, App.configuration.autoCloseTableWindow
        { tableWindowController.close() }
    }
    
}
