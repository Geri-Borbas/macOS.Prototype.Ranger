//
//  Tables.swift
//  Ranger
//
//  Created by Geri Borbás on 2019. 12. 29..
//  Copyright © 2019. Geri Borbás. All rights reserved.
//

import Foundation
import SwiftUI


class TablesStatusBarItem
{
    
    
    let icon: String = "♠️"
    
    
    var menu: NSMenu = NSMenu(title: "Table Menu")
    var statusBarItem: NSStatusItem
    
    
    init()
    {
        statusBarItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.squareLength)
        statusBarItem.button?.title = icon
        statusBarItem.menu = menu
        
        // Default state.
        stopIndicateTracking()
    }
    
    func indicateTracking(windowTitle: String)
    {
        menu.removeAllItems()
        addItemForTable(windowTitle)
        menu.addItem(NSMenuItem.separator())
        menu.addItem(NSMenuItem(title: "Tracking PokerStarsEU...", action: nil, keyEquivalent: ""))
    }
    
    func addItemForTable(_ tableWindowTitle: String)
    {
        let tableItem = NSMenuItem(
            title: tableWindowTitle,
            action: #selector(menuItemDidClick),
            keyEquivalent: ""
        )
        tableItem.target = self
        menu.addItem(tableItem)
    }
    
    func stopIndicateTracking()
    {
        menu.removeAllItems()
        menu.addItem(NSMenuItem(title: "No tables to track", action: nil, keyEquivalent: ""))
    }

    @objc func menuItemDidClick(menuItem: NSMenuItem)
    {
        print("\(menuItem.title) clicked.")
    }
}
