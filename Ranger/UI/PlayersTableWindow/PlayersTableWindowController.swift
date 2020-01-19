//
//  PlayersTableWindowController.swift
//  Ranger
//
//  Created by Geri Borbás on 2019. 12. 30..
//  Copyright © 2019. Geri Borbás. All rights reserved.
//

import Cocoa


class PlayersTableWindowController: NSWindowController
{
        
    
    // MARK: - Lifecycle
    
    static func instantiateAndShow(withPlayers players: [Model.Player]) -> PlayersTableWindowController
    {
        // Instantiate a new controller.
        let storyboard = NSStoryboard(name: "Main", bundle: nil)
        let playersTableWindowController = storyboard.instantiateController(withIdentifier: "PlayersTableWindowController") as! PlayersTableWindowController
            playersTableWindowController.showWindow(self)
        
        // Track table.
        let playersTableViewController = playersTableWindowController.contentViewController as! PlayersTableViewController
            playersTableViewController.update(with: players)
        
        // Hide stack column.
        
        // Hide buttons.
        if let window = playersTableViewController.view.window
        {
            window.standardWindowButton(.miniaturizeButton)?.isHidden = true
            window.standardWindowButton(.zoomButton)?.isHidden = true
            window.standardWindowButton(.closeButton)?.isHidden = true
        }
        
        return playersTableWindowController
    }
}
