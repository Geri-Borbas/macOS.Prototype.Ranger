//
//  CountriesTests.swift
//  RangerTests
//
//  Created by Geri Borbás on 2020. 01. 10..
//  Copyright © 2020. Geri Borbás. All rights reserved.
//

import XCTest
import SharkScope


class TournamentsTests: XCTestCase
{

    
    typealias Tournament = SharkScope.Tournaments.Tournament
    
    
    var tournaments: [Tournament] = []
    
    
    override func setUp()
    {
    
        
        let sharkScope = SharkScope.Service()
        
        
        sharkScope.fetch(
            TournamentsRequest(network: "PokerStars", player:"quAAsar"),
            completion:
            {
                 (result: Result<Tournaments, SharkScope.Error>) in
                       
                switch result
                {
                    case .success(let tournaments):
                             
                        // Prototype.
                        self.tournaments = tournaments.tournaments

                        break

                    case .failure(let error):

                        // Fail silently for now.
                        print(error)

                    break
                }
           }
        )
    }
    
    func _testCount()
    {
        print("Count: \(tournaments.count)")
    }
    
    func _testResults()
    {
        let results = tournaments.reduce(0.0){ sum, eachTournament in sum + eachTournament.Result }
        print("Profit: \(results)")
    }
    
    func _testGrouping()
    {
        let byEntrants: [Int:[Tournament]] = Dictionary(grouping: tournaments, by: { $0.Entrants })
        print("Entrants: \(byEntrants.keys.sorted())")

        let byBuyIn: [Float:[Tournament]] = Dictionary(grouping: tournaments, by: { $0.Stake + $0.Rake })
        print("Buy-in: \(byBuyIn.keys.sorted())")
    }
        
    func testSessions()
    {
        // 8 hours between sessions.
        let treshold: TimeInterval = TimeInterval(4 * 60 * 60)
        var sessions: [[Tournament]] = []
        var eachSession: [Tournament] = []
        var previousTournament: Tournament?
        var log: String = ""
        
        tournaments.sorted().forEach
        {
            eachTournament in
            
            // If there is a previous tournament.
            if let previousTournament_ = previousTournament
            {
                log += "\(previousTournament_.GameID) at \(previousTournament_.Date)\n"
                
                // Lookup if elapsed time meets the treshold.
                let timeBetweenTournaments = eachTournament.Date.timeIntervalSince(previousTournament_.Date)
                let isNewSession = timeBetweenTournaments > treshold
                                
                // Group new session if so.
                if isNewSession
                {
                    sessions.append(eachSession)
                    eachSession.removeAll()
                }
                else
                {
                    // Simply collect tourney otherwise.
                    eachSession.append(eachTournament)
                }
            }
            else
            {
                // Collect first tourney.
                eachSession.append(eachTournament)
            }
            
            previousTournament = eachTournament
        }
        
        // Log.
        log = "Session; Count; Hours; Result; Hourly Result; Entrants\n"
        for (index, eachSession) in sessions.enumerated()
        {
            let weight = 1.0 / Double(eachSession.count)
            let duration = eachSession.last?.Date.timeIntervalSince(eachSession.first!.Date) ?? 0.0
            let hours = duration / 3600.0
            let entrants = eachSession.reduce(0.0){ average, eachTournament in average + Double(eachTournament.Entrants) * weight }
            let result = eachSession.reduce(0.0){ sum, eachTournament in sum + eachTournament.Result }
            let hourlyResult = (hours > 0) ? Double(result) / hours : 0.0
            log += "\(index); \(eachSession.count); \(hours); \(result); \(hourlyResult); \(entrants)\n"
        }
        
        log.copyToClipboard()
    }
}

extension TimeInterval
{
    
    
    func format(using units: NSCalendar.Unit) -> String?
    {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = units
        formatter.unitsStyle = .abbreviated
        formatter.zeroFormattingBehavior = .pad
        return formatter.string(from: self)
    }
}
