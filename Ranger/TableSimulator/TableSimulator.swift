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
class TableSimulator: NSObject
{
                
    
    static var configuration: TableSimulator.Configuration = TableSimulator.Configuration.load()
    
    
    // MARK: - Menu Events
    
    @IBAction func openSimulatedTableDidClick(_ sender: AnyObject)
    {
        // Instantiate window.
        let window = SimulatedTableWindowController.instantiateAndShow()
                
        // Add menu item.
        if let window = window
        {
            let tournamentType = (window.contentViewController as? SimulatedTableViewController)?.tournamentType
            let title = String(format: "Simulated Tournament %@", tournamentType?.name ?? "")
            NSApp.addWindowsItem(window, title: "Cached Players", filename: false)
        }
    }    
}
