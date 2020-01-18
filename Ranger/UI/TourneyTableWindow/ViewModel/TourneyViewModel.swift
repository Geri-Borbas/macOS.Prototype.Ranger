//
//  TourneyViewModel.swift
//  Ranger
//
//  Created by Geri Borbás on 2019. 12. 14..
//  Copyright © 2019. Geri Borbás. All rights reserved.
//

import Foundation
import SwiftUI
import PokerTracker
import SharkScope


protocol TourneyViewModelDelegate
{
    
    
    func tourneyPlayersDidChange(tourneyPlayers: [Model.Player])
    func tourneyOrbitCostDidChange(orbitCost: Float)
}


class TourneyViewModel: NSObject
{
 
    
    // MARK: - Services
    
    private var pokerTracker: PokerTracker.Service = PokerTracker.Service()
    private var sharkScope: SharkScope.Service = SharkScope.Service()
    
    
    // MARK: - Data
    
    /// The poker table this instance is tracking.
    private var tableWindowInfo: TableWindowInfo?
    private var tickCount: Int = 0
    private var tickTime = 10.0
    private var handUpdateTickFrequency = 1
    
    private var activePlayerCount: Int = 0
    private var orbitCost: Float
    {
        // Only if table info is set (and parsed).
        guard let tableInfo = tableWindowInfo?.tableInfo
        else { return 0.0 }
        
        return Float(tableInfo.smallBlind) + Float(tableInfo.bigBlind) + Float(activePlayerCount) * Float(tableInfo.ante)
    }
    
    // MARK: - UI Data
    
    public var latestProcessedHandNumber: String = ""
    public var latestBigBlind: Int = 0
    public var latestTourneyPlayerCount: Int = 0
    
    
    // MARK: - Binds
    
    var delegate: TourneyViewModelDelegate?
    
    
    // MARK: - Lifecycle
    
    public func track(_ tableWindowInfo: TableWindowInfo, delegate: TourneyViewModelDelegate?)
    {
        // Retain.
        self.tableWindowInfo = tableWindowInfo
        self.delegate = delegate
        
        // Schedule timer.
        Timer.scheduledTimer(withTimeInterval: tickTime, repeats: true)
        { _ in self.tick() }
        
        // Fire right now.
        self.tick()
    }
    
    public func update(with tableWindowInfo: TableWindowInfo)
    {
        // Only if changed.
        guard self.tableWindowInfo != tableWindowInfo
        else { return }
        
        // Set.
        self.tableWindowInfo = tableWindowInfo
        
        // Only if table info is parsed.
        guard let tableInfo = tableWindowInfo.tableInfo
        else { return }
        
        // Look for changes.
        let isNewBlindLevel = tableInfo.bigBlind != latestBigBlind
        
        // Only on change.
        guard isNewBlindLevel else { return }
        
        // Track.
        latestBigBlind = tableInfo.bigBlind
        
        // Callback.
        delegate?.tourneyOrbitCostDidChange(orbitCost: orbitCost)
    }
    
    // MARK: - SharkScope
    
    func fetchSharkScopeStatus(completion: @escaping (_ status: String) -> Void)
    {
        // Ping to SharkScope.
        sharkScope.fetch(TimelineRequest(network: "PokerStars", player:"Borbas.Geri").withoutCache(),
                        completion:
        {
            (result: Result<Timeline, SharkScope.Error>) in
            switch result
            {
                case .success(let lastActivity):
                    completion("\(lastActivity.Response.UserInfo.RemainingSearches) search remaining (logged in as \(lastActivity.Response.UserInfo.Username)).")
                    break
                case .failure(let error):                    
                    completion("SharkScope error: \(error)")
                    break
            }
        })
    }
    
    
    // MARK: - Process Data
    
    private func tick()
    {
        tickCount += 1
        try? processData()
    }
    
    private func processData() throws
    {
        // Only if table info is set (and parsed).
        guard let tableInfo = tableWindowInfo?.tableInfo
        else { return }
        
        // May offset hands in simulation mode.
        var handOffset = App.configuration.isSimulationMode ? App.configuration.simulation.handOffset : 0
            handOffset -= tickCount / handUpdateTickFrequency
            handOffset = max(handOffset, 0)
        
        // Get players of the latest hand of the tourney tracked by PokerTracker.
        let tourneyPlayers = Model.Players.playersOfLatestHand(inTournament: tableInfo.tournamentNumber, handOffset: handOffset)
        
        // Only if players any.
        guard let firstPlayer = tourneyPlayers.first
        else { return }
        
        // Look for change.
        let isNewHand = (firstPlayer.pokerTracker?.handPlayer?.hand_no ?? "") != latestProcessedHandNumber
        
        // Only on new hand.
        guard isNewHand else { return }
        
        // Track.
        latestProcessedHandNumber = firstPlayer.pokerTracker?.handPlayer?.hand_no ?? ""
        
        // Count players with non-zero stack.
        let tourneyPlayerCount = tourneyPlayers.reduce(0, { count, eachPlayer in count + ((eachPlayer.stack > 0.0) ? 1 : 0) })
        
        // Look for change.
        if (tourneyPlayerCount != activePlayerCount)
        {
            // Set.
            activePlayerCount = tourneyPlayerCount
            
            // Invoke callback.
            delegate?.tourneyOrbitCostDidChange(orbitCost: orbitCost)
        }
        
        // Invoke callback.
        delegate?.tourneyPlayersDidChange(tourneyPlayers: tourneyPlayers)
    }
    
    
    // MARK: - Summary Data
    
    public func summary(with font: NSFont) -> NSAttributedString
    {
        // Variables.
        var smallBlind:Double = 0
        var bigBlind:Double = 0
        var ante:Double = 0
        var players:Double = 0
        
        // Check data.
        guard let tableInfo = tableWindowInfo?.tableInfo
        else { return NSMutableAttributedString(string: "-") }
        
        // Get data from window title.
        smallBlind = Double(tableInfo.smallBlind)
        bigBlind = Double(tableInfo.bigBlind)
        ante = Double(tableInfo.ante)
        players = Double(activePlayerCount)
        
        // Model.
        let M:Double = smallBlind + bigBlind + players * ante
        let roundedM = String(format: "%.0f", ceil(M * 100) / 100)
        
        // Formats.
        let lightAttribute: [NSAttributedString.Key: Any] = [
            .font : NSFont.systemFont(ofSize: font.pointSize, weight: NSFont.Weight.light),
            .foregroundColor : NSColor.systemGray
        ]
        
        let boldAttribute: [NSAttributedString.Key: Any]  = [
            .font : NSFont.systemFont(ofSize: font.pointSize, weight: NSFont.Weight.bold)
        ]
        
        let summary = NSMutableAttributedString(string: "")
            summary.append(NSMutableAttributedString(string: String(format: "%.0f/%.0f", smallBlind, bigBlind), attributes:boldAttribute))
            summary.append(NSMutableAttributedString(string: String(format: " ante %.0f (%.0f players)", ante, players), attributes:lightAttribute))
            summary.append(NSMutableAttributedString(string: String(format: ", M is %@", roundedM), attributes:lightAttribute))
        
        // Return.
        return summary
    }
}
