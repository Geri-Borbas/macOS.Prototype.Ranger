//
//  TourneyWindowController.swift
//  Ranger
//
//  Created by Geri Borbás on 2019. 12. 30..
//  Copyright © 2019. Geri Borbás. All rights reserved.
//

import Cocoa


class TourneyWindowController: NSWindowController
{
    
    
    public var tableWindowInfo: TableWindowInfo?
        
    
    // MARK: - Lifecycle
    
    static func instantiateAndShow(forTableWindowInfo tableWindowInfo: TableWindowInfo) -> TourneyWindowController
    {
        // Instantiate a new controller.
        let storyboard = NSStoryboard(name: "Main", bundle: nil)
        let tourneyTableWindowController = storyboard.instantiateController(withIdentifier: "TourneyTableWindow") as! TourneyWindowController
            tourneyTableWindowController.showWindow(self)
        
        // Track table.
        let tourneyTableViewController = tourneyTableWindowController.contentViewController as! TourneyViewController
            tourneyTableViewController.track(tableWindowInfo)
        
        // Inject reference.
        tourneyTableWindowController.tableWindowInfo = tableWindowInfo
        
        // Hide buttons.
        if let window = tourneyTableViewController.view.window
        {
            window.standardWindowButton(.miniaturizeButton)?.isHidden = true
            window.standardWindowButton(.zoomButton)?.isHidden = true
            window.standardWindowButton(.closeButton)?.isHidden = true
        }
        
        return tourneyTableWindowController
    }
    
    func update(with tableWindowInfo: TableWindowInfo)
    {
        let tourneyTableViewController = self.contentViewController as! TourneyViewController
            tourneyTableViewController.update(with: tableWindowInfo)
    }
}
