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
    
    
    func statusBarItemClicked(title: StatusBarItem.Title)
}


extension StatusBarItem
{
    
    
    enum Title: String
    {
        
        
        case openCachedPlayers = "Open cached players"
        case openRegs = "Open regs"
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
        addItem(with: windowTitle)
        menu.addItem(NSMenuItem.separator())
        addItem(with: Title.openCachedPlayers)
        addItem(with: Title.openRegs)
        menu.addItem(NSMenuItem.separator())
        menu.addItem(NSMenuItem(title: "Tracking PokerStarsEU...", action: nil, keyEquivalent: ""))
    }
    
    func addItem(with title: Title)
    {
        let menuItem = NSMenuItem(
            title: title.rawValue,
            action: #selector(menuItemDidClick),
            keyEquivalent: ""
        )        
        menuItem.representedObject = title
        menuItem.target = self
        menu.addItem(menuItem)
    }
    
    func addItem(with title: String)
    {
        let menuItem = NSMenuItem(
            title: title,
            action: nil,
            keyEquivalent: ""
        )
        menu.addItem(menuItem)
    }
    
    func stopIndicateTracking()
    {
        menu.removeAllItems()
        menu.addItem(NSMenuItem(title: "No tables to track", action: nil, keyEquivalent: ""))
    }

    @objc func menuItemDidClick(menuItem: NSMenuItem)
    {
        // Get title.
        guard let title = menuItem.representedObject as? Title
        else { return }
        
        delegate?.statusBarItemClicked(title: title)
    }
}
