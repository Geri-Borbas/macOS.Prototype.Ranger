//
//  TourneyTableViewModel.swift
//  Ranger
//
//  Created by Geri Borbás on 2019. 12. 14..
//  Copyright © 2019. Geri Borbás. All rights reserved.
//

import Foundation
import SwiftUI
import PokerTracker
import SharkScope


class TourneyTableViewModel: NSObject
{
 
    
    // MARK: - Services
    
    private var pokerTracker: PokerTracker.Service = PokerTracker.Service()
    private var sharkScope: SharkScope.Service = SharkScope.Service()
    
    
    // MARK: - Data
    
    /// The poker table this instance is tracking.
    private var tableWindowInfo: TableWindowInfo?
    private var tickCount: Int = 0
    private var tickTime = 3.0
    private var handUpdateTickFrequency = 1
    
    /// View models for players seated at table.
    private var players: [Model.Player] = []
    
    
    // MARK: - UI Data
    
    public var latestProcessedHandNumber: String = ""
    public var latestBigBlind: Int = 0
    private var sortDescriptors: [NSSortDescriptor]?
    private var selectedPlayer: Model.Player?
    private var stackPercentProviderEasing: String?
    public var sharkScopeStatus: String
    { sharkScope.status }
    
    
    // MARK: - Binds
    
    @IBOutlet weak var stackPercentProvider: PercentProvider!
    var activePlayerCount: Float
    {
        // Count players with non-zero stack.
        players.reduce(0.0, { count, eachPlayer in count + ((eachPlayer.stack > 0.0) ? 1 : 0) })
    }
    var orbitCost: Float
    {
        // Only if table info is set (and parsed).
        guard let tableInfo = tableWindowInfo?.tableInfo
        else { return 0.0 }
        
        return Float(tableInfo.smallBlind) + Float(tableInfo.bigBlind) + activePlayerCount * Float(tableInfo.ante)
    }
    
    private var onChange: (() -> Void)?
    
    
    // MARK: - Lifecycle
    
    public func track(_ tableWindowInfo: TableWindowInfo, onChange: (() -> Void)?)
    {
        // Retain.
        self.tableWindowInfo = tableWindowInfo
        self.onChange = onChange
        
        // Schedule timer.
        Timer.scheduledTimer(withTimeInterval: tickTime, repeats: true)
        { _ in self.tick() }
    }
    
    public func update(with tableWindowInfo: TableWindowInfo)
    {
        // Only if changed.
        guard self.tableWindowInfo != tableWindowInfo
        else { return }
        
        // Set.
        self.tableWindowInfo = tableWindowInfo
        
        // TODO: Indicate force change regardless of unchanged hand history.
        try? processData()
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
        var currentPlayers = Model.Players.playersOfLatestHand(inTournament: tableInfo.tournamentNumber, handOffset: handOffset)
        
        // Only if players any.
        guard let firstPlayer = currentPlayers.first
        else { return }
        
        // Look for changes.
        let isNewHand = (firstPlayer.pokerTracker?.handPlayer?.hand_no ?? "") != latestProcessedHandNumber
        let isNewBlindLevel = tableInfo.bigBlind != latestBigBlind
        let isSomethingChanged = isNewHand || isNewBlindLevel
        
        // Only on change.
        guard isSomethingChanged else { return }
        
        // Track.
        latestBigBlind = tableInfo.bigBlind
        latestProcessedHandNumber = firstPlayer.pokerTracker?.handPlayer?.hand_no ?? ""
        
        // Save any SharkScope statistics if any.
        players.forEach
        {
            eachPlayer in
            if (currentPlayers.contains(eachPlayer))
            {
                let index = currentPlayers.firstIndex(of: eachPlayer)!
                currentPlayers[index].sharkScope = eachPlayer.sharkScope
            }
        }
        
        // And just use the new collection.
        players = currentPlayers
        
        // Get latest PokerTracker statistics (get session stats for hero).
        for (eachIndex, eachPlayer) in players.enumerated()
        { players[eachIndex].pokerTracker?.updateStatistics(for: eachPlayer.isHero ? tableInfo.tournamentNumber : nil) }
        
        // Track stack extremes.
        stackPercentProvider.maximum = NSNumber(value: players.reduce(
            0.0,
            { max($0, $1.stack) })
        )
        
        // Sort view model using retained sort descriptors (if any).
        sort(using: self.sortDescriptors)
        
        // Invoke callback.
        onChange?()
    }
    
    func sort(using sortDescriptors: [NSSortDescriptor]?)
    {
        // Only if any (from table descriptors or from previously retained descriptors).
        guard let sortDescriptors = sortDescriptors
        else { return }
        
        // Retain.
        self.sortDescriptors = sortDescriptors
        
        // Sort in place.
        players = players.sorted
        {
            lhs, rhs -> Bool in
            lhs.isInIncreasingOrder(to: rhs, using: sortDescriptors)
        }
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


// MARK: - TableView Data

extension TourneyTableViewModel: NSTableViewDataSource
{
    
    
    func numberOfRows(in tableView: NSTableView) -> Int
    { return players.count }
    
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView?
    {
        // Checks.
        guard let column = tableColumn else { return nil }
        guard players.count > row else { return nil }
        
        // Get data.
        let player = players[row]
        
        // Create / Reuse cell view.
        guard let cellView = tableView.makeView(withIdentifier: (column.identifier), owner: self) as? PlayerCellView else { return nil }
        
        // Apply data.
        cellView.setup(with: player, in: tableColumn)
        
        // Select row if was selected before.
        if (self.selectedPlayer == player)
        { tableView.selectRowIndexes(IndexSet(integer: row), byExtendingSelection: false) }
        
        // Fade if no stack (yet hardcoded).
        if
            let rowView = tableView.rowView(atRow: row, makeIfNecessary: false),
            player.isPlaying,
            player.stack <= 0
        { rowView.alphaValue = 0.4 }
        
        return cellView
    }
}


// MARK: - Context Menu Events

extension TourneyTableViewModel
{
    
    
    func tableHeaderContextMenu(for column: NSTableColumn) -> NSMenu?
    {
        if (column.identifier.rawValue == "Stack")
        {
            return NSMenu(title: "Stack").with(items:
            [
                NSMenuItem(title: "linear", action: #selector(menuItemDidClick), keyEquivalent: "").with(target: self),
                NSMenuItem(title: "easeOut", action: #selector(menuItemDidClick), keyEquivalent: "").with( target: self)
            ])
        }
        
        return nil
    }
    
    @objc func menuItemDidClick(menuItem: NSMenuItem)
    {
        print("menuItemDidClick(\(menuItem.title))")
    }
}



// MARK: - TableView Events

extension TourneyTableViewModel: NSTableViewDelegate
{
    
    // Plug custom row view.
    func tableView(_ tableView: NSTableView, rowViewForRow row: Int) -> NSTableRowView?
    { return TourneyTableRowView() }
    
    // Save selection.
    func tableView(_ tableView: NSTableView, shouldSelectRow row: Int) -> Bool
    {
        // Checks.
        guard players.count > row else { return false }
        
        // Get data.
        let player = players[row]
        
        // Retain selection.
        self.selectedPlayer = player
        
        return true
    }
    
    func tableView(_ tableView: NSTableView, sortDescriptorsDidChange oldDescriptors: [NSSortDescriptor])
    {
        // Sort view model using table sort descriptors.
        sort(using: tableView.sortDescriptors)
        tableView.reloadData()
    }
    
    public func fetchSharkScopeStatisticsForPlayer(inRow row: Int)
    {
        // Checks.
        guard players.count > row else { return }
        
        // Data.
        var player = players[row]

        // Fetch summary.
        sharkScope.fetch(player: player.name,
                         completion:
            {
                (result: Result<(playerSummary: PlayerSummary, activeTournaments: ActiveTournaments), SharkScope.Error>) in
                       
                switch result
                {
                    case .success(let responses):

                        // Retain.
                        player.sharkScope.update(withSummary: responses.playerSummary, activeTournaments: responses.activeTournaments)
                        
                        // Write.
                        self.players[row] = player
                        
                        // Invoke callback.
                        self.onChange?()

                        break

                    case .failure(let error):

                        // Fail silently for now.
                        print(error)

                    break
                }
           })
    }
    
    public func fetchCompletedTournamentsForPlayer(withName playerName: String)
    {
        // Lookup player.
        let firstPlayer = players.filter{ eachPlayer in eachPlayer.name == playerName }.first
        
        // Checks.
        guard let player = firstPlayer else { return }
        
        /// Data.
        sharkScope.fetch(CompletedTournamentsRequest(network: "PokerStars", player:player.name, amount: 80),
                         completion:
            {
                 (result: Result<CompletedTournaments, SharkScope.Error>)in
                       
                switch result
                {
                    case .success(let response):

                        print(response)
                        
                        // Retain.
                        // player.sharkScope.update(withSummary: responses.playerSummary, activeTournaments: responses.activeTournaments)
                        
                        // Invoke callback.
                        // self.onChange?()

                        break

                    case .failure(let error):

                        // Fail silently for now.
                        print(error)

                    break
                }
           })
    }
}
