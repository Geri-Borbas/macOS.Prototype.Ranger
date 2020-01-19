//
//  Tables.swift
//  Ranger
//
//  Created by Geri Borbás on 2019. 12. 29..
//  Copyright © 2019. Geri Borbás. All rights reserved.
//

import Foundation
import SwiftUI


protocol StatusBarItemDelegate
{
    
    
    func statusBarItemClicked(menuItem: StatusBarItem.MenuItem)
}


extension StatusBarItem
{
    
    
    struct MenuItem: Equatable
    {
        
        
        let title: String
        
        
        static let openCachedPlayers = MenuItem(title: "Open cached players")
        static let openRegs = MenuItem(title: "Open regs")
    }
}


class StatusBarItem
{
    
    
    let icon: String = "♠️"
    var delegate: StatusBarItemDelegate?
    
    
    
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
        
        addItem(with: MenuItem(title: windowTitle))
        menu.addItem(NSMenuItem.separator())
        addItem(with: MenuItem.openCachedPlayers)
        addItem(with: MenuItem.openRegs)
        menu.addItem(NSMenuItem.separator())
        addItem(with: MenuItem(title: "Tracking PokerStarsEU..."))
    }
    
    func addItem(with menuItem: MenuItem)
    {
        let item = NSMenuItem(
            title: menuItem.title,
            action: #selector(menuItemDidClick),
            keyEquivalent: ""
        )
        
        // References.
        item.representedObject = menuItem
        item.target = self
        
        menu.addItem(item)
    }
    
    func stopIndicateTracking()
    {
        menu.removeAllItems()
        menu.addItem(NSMenuItem(title: "No tables to track", action: nil, keyEquivalent: ""))
    }

    @objc func menuItemDidClick(item: NSMenuItem)
    {
        // Get title.
        guard let menuItem = item.representedObject as? MenuItem
        else { return }
        
        delegate?.statusBarItemClicked(menuItem: menuItem)
    }
}
