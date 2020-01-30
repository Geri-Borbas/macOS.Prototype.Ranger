//
//  File.swift
//  Ranger
//
//  Created by Geri Borbás on 2019. 12. 29..
//  Copyright © 2019. Geri Borbás. All rights reserved.
//

import Foundation
import AppKit
import SwiftUI
import PokerTracker


/// The root application controller object.
class App: NSObject, TableTrackerDelegate
{
    
    
    static var configuration: App.Configuration = App.Configuration.load()
    
    private var windowTracker: TableTracker = TableTracker()
    private var tournamentWindowControllersForWindowInfos: [TableWindowInfo:TournamentWindowController] = [:]
    
    
    func start()
    {
        // Subscribe window updates.
        windowTracker.delegate = self
        windowTracker.start()
    }
    
    func stop()
    {
        PokerTracker.Service.disconnect()
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
    
    @IBAction func openOptedOutPlayersDidClick(_ sender: AnyObject)
    {
        // Instantiate window.
        let window = PlayersWindowController.instantiateAndShow(
                withPlayers: Model.Players.optedOutPlayers(),
                hiddenColumnIdentifiers: ["Seat", "Stack"]
        )
        
        // Add menu item.
        if let window = window
        { NSApp.addWindowsItem(window, title: "Opted-Out Players", filename: false) }
    }
    
    
    // MARK: - Track tables
    
    func windowTrackerDidStartTrackingTable(tableWindowInfo: TableWindowInfo)
    {
        // Instantiate new tournament window.
        let tournamentWindowController = TournamentWindowController.instantiateAndShow(forTableWindowInfo: tableWindowInfo)
        
        // Collect.
        tournamentWindowControllersForWindowInfos[tableWindowInfo] = tournamentWindowController
        
        // Add menu item.
        if let window = tournamentWindowController.window
        {
            let menuItemTitle = "Tournament \(tableWindowInfo.tableInfo?.tournamentNumber ?? "(?)") Table \(String(tableWindowInfo.tableInfo?.tableNumber ?? 0))"
            NSApp.addWindowsItem(window, title: menuItemTitle, filename: false)
        }
    }
    
    func windowTrackerDidUpdateTableWindowInfo(tableWindowInfo: TableWindowInfo)
    {
        manageWindowLevels()
        
        // Only if any.
        guard let tournamentWindowController = tournamentWindowControllersForWindowInfos[tableWindowInfo] else { return }
        
        // Update tournament window.
        tournamentWindowController.update(with: tableWindowInfo)
        
        // Update menu item.
        if let window = tournamentWindowController.window
        {
            let menuItemTitle = "Tournament \(tableWindowInfo.tableInfo?.tournamentNumber ?? "(?)") Table \(String(tableWindowInfo.tableInfo?.tableNumber ?? 0))"
            NSApp.changeWindowsItem(window, title: menuItemTitle, filename: false)
        }
    }
    
    func windowTrackerDidStopTrackingTable(tableWindowInfo: TableWindowInfo)
    {
        // Only if any.
        guard let tournamentWindowController = tournamentWindowControllersForWindowInfos[tableWindowInfo] else { return }
        
        // Turn back dragging.
        if let tableWindow = tournamentWindowController.window
        { tableWindow.isMovable = true }
        
        // Close window if any (if opted-in).
        if App.configuration.autoCloseTableWindow
        { tournamentWindowController.close() }
    }
    
    func manageWindowLevels()
    {
        // Lookup frontmost app.
        let identifier = NSWorkspace.shared.frontmostApplication?.bundleIdentifier ?? ""
        let windowsShouldBeFloating = identifier.contains(any: windowTracker.trackedProcesses)
        
        // Put windows above everything if playing (prevents flickering when switching tables),
        // back to normal hierarchy otherwise (system windows cover overlays again).
        tournamentWindowControllersForWindowInfos.values.forEach
        {
            eachTournamentWindowController in
            if let eachWindow = eachTournamentWindowController.window
            { eachWindow.level = windowsShouldBeFloating ? .floating : .normal }
        }
    }
}
