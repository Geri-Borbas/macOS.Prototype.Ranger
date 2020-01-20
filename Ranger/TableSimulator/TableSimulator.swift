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
                
    
    // MARK: - Menu Events
    
    @IBAction func openSimulatedTableDidClick(_ sender: AnyObject)
    {
        // Instantiate window.
        let window = SimulatedTableWindowController.instantiateAndShow()
                
        // Add menu item.
        if let window = window
        { NSApp.addWindowsItem(window, title: "Cached Players", filename: false) }
    }    
}
