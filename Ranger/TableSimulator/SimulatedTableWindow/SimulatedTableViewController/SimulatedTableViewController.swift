//
//  TourneyViewController.swift
//  Ranger
//
//  Created by Geri Borbás on 2019. 12. 02..
//  Copyright © 2019. Geri Borbás. All rights reserved.
//

import Cocoa
import CoreGraphics


class SimulatedTableViewController: NSViewController
{

    
    var tournamentType: TableSimulator.Configuration.TournamentType?
    var startDate: Date = Date()
    
    
    override func viewDidAppear()
    {
        super.viewDidAppear()
        
        // Pick a random tournament type.
        self.tournamentType = TableSimulator.configuration.tournamentTypes.randomElement()
        
        // Schedule timer.
        self.startDate = Date()
        Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true)
        { _ in self.tick() }
        
        // Update right away.
        self.tick()
    }
    
    func tick()
    {
        // Checks.
        guard let tournamentType = tournamentType else { return }
     
        // Create title.
        let elapsedTime = Date().timeIntervalSince(self.startDate)
        let title = String(
            format: "%@ - %@ - Tournament %@ Table 2 - Logged In as Borbas.Geri",
            tournamentType.name,
            tournamentType.blindLevel(for: elapsedTime),
            tournamentType.number
        )
        
        // Set title.
        self.view.window?.title = title
    }
}

