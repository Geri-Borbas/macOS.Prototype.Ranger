//
//  TourneyTableView.swift
//  Ranger
//
//  Created by Geri Borbás on 2020. 01. 06..
//  Copyright © 2020. Geri Borbás. All rights reserved.
//

import Cocoa
import SharkScope


@objc protocol TourneyTableViewDelegate
{
    
    
    func fetchCompletedTournementsRequested(for playerName: String)
}


class TourneyTableView: NSTableView
{

    
    @IBOutlet var tourneyTableViewDelegate: TourneyTableViewDelegate?
    

    // MARK: - Context menu
    
    override func menu(for event: NSEvent) -> NSMenu?
    {
        let clickLocation = self.convert(event.locationInWindow, from: nil)
        let clickedRow = self.row(at: clickLocation)
        let clickedColumn = self.column(at: clickLocation)
        
        // Get cell.
        guard let playerCellView = self.view(atColumn: clickedColumn, row: clickedRow, makeIfNecessary: false) as? PlayerCellView
        else { return nil }
        
        // Get model.
        guard let player = playerCellView.player
        else { return nil }
        
        // Create context menu for row.
        return NSMenu(title: "Player Context Menu (\(player.name))").with(items:
        [
            NSMenuItem(
                title: player.name,
                action: nil,
                keyEquivalent: ""
            ),
            
            NSMenuItem.separator(),
            
            NSMenuItem(
                title: "Fetch Completed Tournaments (25 Search)",
                action: #selector(fetchCompletedTournaments),
                keyEquivalent: "")
                .with(
                    representedObject: player,
                    target: self
                ),
            
            NSMenuItem.separator(),
            
            NSMenuItem(
                title: "Copy name to clipboard",
                action: #selector(copyNameToClipboard),
                keyEquivalent: "")
                .with(
                    representedObject: player,
                    target: self
                ),
            NSMenuItem(
                title: "Copy statistics to clipboard",
                action: #selector(copyStatisticsToClipboard),
                keyEquivalent: "")
                .with(
                    representedObject: player,
                    target: self
            ),
            
            NSMenuItem.separator(),
            
            NSMenuItem(
                title: "Delete tables cache",
                action: #selector(deleteTablesCache),
                keyEquivalent: "")
                .with(
                    representedObject: player,
                    target: self
                ),
            NSMenuItem(
                title: "Delete statistics cache",
                action: #selector(deleteStatisticsCache),
                keyEquivalent: "")
                .with(
                    representedObject: player,
                    target: self
            )
        ])
    }

    @objc func fetchCompletedTournaments(menuItem: NSMenuItem)
    {
        // Get model.
        guard let player = menuItem.representedObject as? Model.Player
        else { return }
        
        // Dispatch request to delegate if any.
        tourneyTableViewDelegate?.fetchCompletedTournementsRequested(for: player.name)
    }

    @objc func copyNameToClipboard(menuItem: NSMenuItem)
    {
        // Get model.
        guard let player = menuItem.representedObject as? Model.Player
        else { return }
        
        // Copy name to clipboard.
        NSPasteboard.general.declareTypes([NSPasteboard.PasteboardType.string], owner: nil)
        NSPasteboard.general.setString(player.name, forType: NSPasteboard.PasteboardType.string)
    }

    @objc func copyStatisticsToClipboard(menuItem: NSMenuItem)
    {
        // Get model.
        guard let player = menuItem.representedObject as? Model.Player
        else { return }
        
        // Copy statistics to clipboard.
        NSPasteboard.general.declareTypes([NSPasteboard.PasteboardType.string], owner: nil)
        NSPasteboard.general.setString(player.statisticsSummary, forType: NSPasteboard.PasteboardType.string)
    }

    @objc func deleteTablesCache(menuItem: NSMenuItem)
    {
        // Get model.
        guard let player = menuItem.representedObject as? Model.Player
        else { return }
        
        // Remove file.
        RequestCache().deleteTablesCache(for: player.name)
    }

    @objc func deleteStatisticsCache(menuItem: NSMenuItem)
    {
        // Get model.
        guard let player = menuItem.representedObject as? Model.Player
        else { return }
        
        // Remove file.
        RequestCache().deleteStatisticsCache(for: player.name)
    }
    
}
