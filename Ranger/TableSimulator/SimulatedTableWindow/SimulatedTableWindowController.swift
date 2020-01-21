//
//  PlayersTableWindowController.swift
//  Ranger
//
//  Created by Geri Borbás on 2019. 12. 30..
//  Copyright © 2019. Geri Borbás. All rights reserved.
//

import Cocoa


class SimulatedTableWindowController: NSWindowController
{
        
    
    static func instantiateAndShow() -> NSWindow?
    {
        // Instantiate a new controller.
        let storyboard = NSStoryboard(name: "Main", bundle: nil)
        let simulatedTableWindowController = storyboard.instantiateController(withIdentifier: "SimulatedTableWindowController") as! SimulatedTableWindowController
            simulatedTableWindowController.showWindow(self)
        
        // Return window reference.
        return simulatedTableWindowController.window
    }
}
