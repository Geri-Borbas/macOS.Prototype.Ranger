//
//  TourneyWindowController.swift
//  Ranger
//
//  Created by Geri Borbás on 2019. 12. 30..
//  Copyright © 2019. Geri Borbás. All rights reserved.
//

import Cocoa


class TournamentWindowController: NSWindowController
{
    
    
    public var tableWindowInfo: TableWindowInfo?
        
    
    // MARK: - Lifecycle
    
    static func instantiateAndShow(forTableWindowInfo tableWindowInfo: TableWindowInfo) -> TournamentWindowController
    {
        // Instantiate a new controller.
        let storyboard = NSStoryboard(name: "Main", bundle: nil)
        let tournamentTableWindowController = storyboard.instantiateController(withIdentifier: "TournamentWindowController") as! TournamentWindowController
            tournamentTableWindowController.showWindow(self)
        
        // Track table.
        let tourneyTableViewController = tournamentTableWindowController.contentViewController as! TournamentViewController
            tourneyTableViewController.update(with: tableWindowInfo)
        
        // Inject reference.
        tournamentTableWindowController.tableWindowInfo = tableWindowInfo
        
        // Hide buttons.
        if let window = tourneyTableViewController.view.window
        {
            // Always on top.
            window.level = .floating // .statusBar
            window.titlebarAppearsTransparent = true
            
            // Click-through, but titled.
            window.styleMask = [.borderless, .titled, .closable]
            
            // See-trough.
            window.backgroundColor = NSColor.clear
            window.isOpaque = false
         
            // Hide controls.
            window.standardWindowButton(.miniaturizeButton)?.isHidden = true
            window.standardWindowButton(.zoomButton)?.isHidden = true
            window.standardWindowButton(.closeButton)?.isHidden = true
        }
        
        return tournamentTableWindowController
    }
    
    func update(with tableWindowInfo: TableWindowInfo)
    {
        let tourneyTableViewController = self.contentViewController as! TournamentViewController
            tourneyTableViewController.update(with: tableWindowInfo)
    }
}
