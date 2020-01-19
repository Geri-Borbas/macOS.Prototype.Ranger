//
//  PlayersTableWindowController.swift
//  Ranger
//
//  Created by Geri Borbás on 2019. 12. 30..
//  Copyright © 2019. Geri Borbás. All rights reserved.
//

import Cocoa


class PlayersWindowController: NSWindowController
{
        
    
    static func instantiateAndShow(withPlayers players: [Model.Player], hiddenColumnIdentifiers: [String]? = nil)
    {
        // Instantiate a new controller.
        let storyboard = NSStoryboard(name: "Main", bundle: nil)
        let playersWindowController = storyboard.instantiateController(withIdentifier: "PlayersWindowController") as! PlayersWindowController
            playersWindowController.showWindow(self)
        
        // Track table.
        let playersViewController = playersWindowController.contentViewController as! PlayersViewController
            playersViewController.update(with: players)
        
        // Hide stack column.
        if let hiddenColumnIdentifiers = hiddenColumnIdentifiers
        { playersViewController.hideColumns(columnIdentifiers: hiddenColumnIdentifiers) }
        
        // Hide buttons.
        if let window = playersViewController.view.window
        {
            window.standardWindowButton(.miniaturizeButton)?.isHidden = true
            window.standardWindowButton(.zoomButton)?.isHidden = true
            window.standardWindowButton(.closeButton)?.isHidden = true
        }
    }
}
