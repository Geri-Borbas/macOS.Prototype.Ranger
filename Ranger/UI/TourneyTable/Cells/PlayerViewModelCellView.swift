//
//  PlayerViewModelCellView.swift
//  Ranger
//
//  Created by Geri Borbás on 2020. 01. 02..
//  Copyright © 2020. Geri Borbás. All rights reserved.
//

import Cocoa


class PlayerViewModelCellView: NSTableCellView
{
    
    
    var textFieldData: TextFieldData!
    var playerViewModel: PlayerViewModel!
    
    
    func setup(with playerViewModel: PlayerViewModel, in tableColumn: NSTableColumn?)
    {
        // Checks.
        guard let column = tableColumn else { return }
        guard let textField = self.textField else { return }
        
        // Retain data.
        self.playerViewModel = playerViewModel
        self.textFieldData = playerViewModel.textFieldDataForColumnIdentifiers[column.identifier.rawValue]!
        
        // Apply text.
        textFieldData.apply(to: textField)
    }
    
    
    // MARK: - Context menu
    
    override func menu(for event: NSEvent) -> NSMenu?
    {
        return NSMenu(title: "Row").with(items:
        [
           NSMenuItem(title: "Copy name to clipboard", action: #selector(copyNameToClipboard), keyEquivalent: "").with(target: self),
           NSMenuItem(title: "Copy statistics to clipboard", action: #selector(copyStatisticsToClipboard), keyEquivalent: "").with(target: self)
        ])
    }

    @objc func copyNameToClipboard(menuItem: NSMenuItem)
    {
        // Copy name to clipboard.
        NSPasteboard.general.declareTypes([NSPasteboard.PasteboardType.string], owner: nil)
        NSPasteboard.general.setString(playerViewModel?.pokerTracker.latestHandPlayer.player_name ?? "", forType: NSPasteboard.PasteboardType.string)
    }

    @objc func copyStatisticsToClipboard(menuItem: NSMenuItem)
    {
        // Copy name to clipboard.
        NSPasteboard.general.declareTypes([NSPasteboard.PasteboardType.string], owner: nil)
        NSPasteboard.general.setString(playerViewModel?.pokerTracker.latestHandPlayer.player_name ?? "", forType: NSPasteboard.PasteboardType.string)
    }
}
