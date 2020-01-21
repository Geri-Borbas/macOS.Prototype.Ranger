//
//  TourneyViewController.swift
//  Ranger
//
//  Created by Geri Borbás on 2019. 12. 02..
//  Copyright © 2019. Geri Borbás. All rights reserved.
//

import Cocoa
import CoreGraphics
import PokerTracker


class SimulatedTableViewController: NSViewController
{

    
    // MARK: - Services
    
    private var pokerTracker: PokerTracker.Service = PokerTracker.Service()

    
    // MARK: - Data
    
    var tournament: TableSimulator.Configuration.Tournament?
    var tourneyHandSummaries: [TourneyHandSummary]?
    var handOffset: Int = 0
    
    
    override func viewDidAppear()
    {
        super.viewDidAppear()
        
        // Pick a random tournament.
        tournament = TableSimulator.remainingTournaments.randomElement()
        
        // Checks.
        guard let tournament = tournament else { return }
        
        // Attempt to get `TourneyHandSummary` collection from PokerTracker.
        tourneyHandSummaries = try? PokerTracker.Service().fetch(PokerTracker.TourneyHandSummaryQuery(tourneyNumber: tournament.number))
        
        // Checks.
        guard let tourneyHandSummaries = tourneyHandSummaries
        else { return }
        
        // Get the furthest hand in the list.
        handOffset = tourneyHandSummaries.count - 1
        
        // Schedule timer.
        Timer.scheduledTimer(withTimeInterval: tournament.handInterval, repeats: true)
        { _ in self.tick() }
        
        // Update right away.
        self.tick()
    }
    
    func tick()
    {
        // Checks.
        guard let tournament = tournament else { return }
        guard let tourneyHandSummaries = tourneyHandSummaries else { return }
     
        // Get blind level from current hand.
        let tourneyHandSummary = tourneyHandSummaries[handOffset]
        let blindLevel = tourneyHandSummary.blinds_name.replacingOccurrences(of: "Ante ", with: "ante ").replacingOccurrences(of: " NL", with: "")
        
        // Log.
        // print("Simulating hand #\(tourneyHandSummary.hand_no).")
        
        // Assemble title.
        let title = String(
            format: "%@ - %@ - Tournament %@ Table 2 - Logged In as Borbas.Geri",
            tournament.name,
            blindLevel,
            tournament.number
        )
        
        // Set title.
        self.view.window?.title = title
        
        // Step.
        handOffset -= 1
        handOffset = max(handOffset, 0)
    }
}

