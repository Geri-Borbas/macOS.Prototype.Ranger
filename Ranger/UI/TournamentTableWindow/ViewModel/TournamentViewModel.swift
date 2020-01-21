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


struct TournamentInfo: Equatable
{
    
    
    let tournamentNumber: String
    let tableNumber: Int
    
    let smallBlind: Int
    let bigBlind: Int
    let ante: Int
    
    var players: Int
    let orbitCost: Float
    
    
    init(with tableInfo: TableInfo, players: Int)
    {
        self.tournamentNumber = tableInfo.tournamentNumber
        self.tableNumber = tableInfo.tableNumber
        
        self.smallBlind = tableInfo.smallBlind
        self.bigBlind = tableInfo.bigBlind
        self.ante = tableInfo.ante
        
        // Calculations.
        self.players = players
        self.orbitCost = Float(self.smallBlind) + Float(self.bigBlind) + Float(self.players) * Float(self.ante)
    }
}


protocol TournamentViewModelDelegate
{
    
    
    func tournamentPlayersDidChange(tournamentPlayers: [Model.Player])
    func tournamentDidChange(tournamentInfo: TournamentInfo)
}


class TournamentViewModel: NSObject
{
 
    
    // MARK: - Services
    
    private var pokerTracker: PokerTracker.Service = PokerTracker.Service()
    private var sharkScope: SharkScope.Service = SharkScope.Service()
    
    
    // MARK: - Data
    
    /// The poker table this instance is tracking.
    private var tournamentInfo: TournamentInfo?
    
    // Updates.
    private var tickTime = 1.0
    
    
    // MARK: - UI Data
    
    public var latestProcessedHandNumber: String = ""
    public var latestBigBlind: Int = 0
    
    
    // MARK: - Binds
    
    var delegate: TournamentViewModelDelegate?
    
    
    // MARK: - Lifecycle
    
    public func track(_ tableWindowInfo: TableWindowInfo, delegate: TournamentViewModelDelegate?)
    {
        // Binds.
        self.delegate = delegate
        
        // Schedule timer.
        Timer.scheduledTimer(withTimeInterval: tickTime, repeats: true)
        { _ in self.tick() }
        
        // Get toutnament info.
        update(with: tableWindowInfo)
        
        // Fire right now.
        self.tick()
    }
    
    public func update(with tableWindowInfo: TableWindowInfo)
    {
        // Only if table info is parsed.
        guard let tableInfo = tableWindowInfo.tableInfo
        else { return }
        
        // Convert.
        let players = self.tournamentInfo?.players ?? 0
        let tournamentInfo = TournamentInfo(with: tableInfo, players: players)
        
        // Only if changed.
        guard self.tournamentInfo != tournamentInfo
        else { return }
        
        // Set.
        self.tournamentInfo = tournamentInfo
        
        // Look for changes.
        let isNewBlindLevel = tableInfo.bigBlind != latestBigBlind
        
        // Only on change.
        guard isNewBlindLevel else { return }
        
        // Track.
        latestBigBlind = tableInfo.bigBlind
        
        // Callback.
        delegate?.tournamentDidChange(tournamentInfo: tournamentInfo)
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
        try? processData()
    }
    
    private func processData() throws
    {
        // Only if table info is set (and parsed).
        guard let tournamentInfo = self.tournamentInfo
        else { return }
        
        // May want to offset hands if tracking simulated table.
        let handOffset = TableSimulator.handOffsetForTournamentNumberIfAny(tournamentNumber: tournamentInfo.tournamentNumber)
        
        // Get players of the latest hand of the tournament tracked by PokerTracker.
        let tournamentPlayers = Model.Players.playersOfLatestHand(inTournament: tournamentInfo.tournamentNumber, handOffset: handOffset)
        
        // Only if players any.
        guard let firstPlayer = tournamentPlayers.first
        else { return }
        
        // Look for change.
        let isNewHand = (firstPlayer.pokerTracker?.handPlayer?.hand_no ?? "") != latestProcessedHandNumber
        
        // Only on new hand.
        guard isNewHand else { return }
        
        // Track.
        latestProcessedHandNumber = firstPlayer.pokerTracker?.handPlayer?.hand_no ?? ""
        
        // Count players with non-zero stack.
        let tournamentPlayerCount = tournamentPlayers.reduce(0, { count, eachPlayer in count + ((eachPlayer.stack > 0.0) ? 1 : 0) })
        
        // Look for change.
        if (tournamentPlayerCount != tournamentInfo.players)
        {
            // Track.
            self.tournamentInfo!.players = tournamentPlayerCount
            
            // Invoke callback.
            delegate?.tournamentDidChange(tournamentInfo: self.tournamentInfo!)
        }
        
        // Invoke callback.
        delegate?.tournamentPlayersDidChange(tournamentPlayers: tournamentPlayers)
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
        guard let tournamentInfo = self.tournamentInfo
        else { return NSMutableAttributedString(string: "-") }
        
        // Get data from window title.
        smallBlind = Double(tournamentInfo.smallBlind)
        bigBlind = Double(tournamentInfo.bigBlind)
        ante = Double(tournamentInfo.ante)
        players = Double(tournamentInfo.players)
        
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
