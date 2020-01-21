//
//  File.swift
//  Ranger
//
//  Created by Geri Borbás on 2019. 12. 29..
//  Copyright © 2019. Geri Borbás. All rights reserved.
//

import Foundation
import SwiftUI


/// Simulate PokerStars windows (to test table tracking).
class TableSimulator: NSObject, NSWindowDelegate
{
                
    
    static var configuration: TableSimulator.Configuration = TableSimulator.Configuration.load()
    
    
    // MARK: - Menu Events
    
    @IBAction func openSimulatedTableDidClick(_ sender: AnyObject)
    {
        // Checks.
        guard TableSimulator.remainingTournaments.count > 0
        else { return }
        
        // Instantiate window.
        let window = SimulatedTableWindowController.instantiateAndShow()
                
        // Add menu item.
        if
            let window = window,
            let simulatedTableViewController = window.contentViewController as? SimulatedTableViewController,
            let tournament = simulatedTableViewController.tournament
        {
            // Add menu item.
            let title = "Simulated Tournament \(tournament.number)"
            NSApp.addWindowsItem(window, title: title, filename: false)
            
            // Track.
            TableSimulator.track(controller: simulatedTableViewController)
            window.delegate = self
        }
    }
    
    func windowWillClose(_ notification: Notification)
    {
        // Checks.
        guard
            let window = notification.object as? NSWindow,
            let simulatedTableViewController = window.contentViewController as? SimulatedTableViewController
        else { return }
        
        // Untrack.
        TableSimulator.untrack(controller: simulatedTableViewController)
    }
}


// MARK: - Tracking Windows

extension TableSimulator
{
    
    
    static var simulatedTableWindows: [SimulatedTableViewController] = []
    
    static func track(controller: SimulatedTableViewController)
    { simulatedTableWindows.append(controller) }
    
    static func untrack(controller: SimulatedTableViewController)
    { simulatedTableWindows.removeAll(where: { eachSimulatedTableViewController in eachSimulatedTableViewController == controller }) }
    
    static var activeTournaments: [TableSimulator.Configuration.Tournament]
    {
        return simulatedTableWindows.compactMap(
        {
            eachSimulatedTableViewController in
            eachSimulatedTableViewController.tournament
            
        })
    }
    
    static var remainingTournaments: [TableSimulator.Configuration.Tournament]
    {
        configuration.tournaments.filter
        {
            eachSimulatedTableViewController in
            activeTournaments.contains(eachSimulatedTableViewController) == false
        }
    }
    
    static func handOffsetForTournamentNumberIfAny(tournamentNumber: String) -> Int
    {
        // Lookup matching controller.
        guard let simulatedTableViewController = simulatedTableWindows.filter(
        {
            eachSimulatedTableViewController in
            eachSimulatedTableViewController.tournament?.number == tournamentNumber
            
        }).first
        else { return 0 }
        
        // Return current offset.
        return simulatedTableViewController.handOffset
    }
}
