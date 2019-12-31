//
//  TourneyTableViewModel.swift
//  Ranger
//
//  Created by Geri Borbás on 2019. 12. 14..
//  Copyright © 2019. Geri Borbás. All rights reserved.
//

import Foundation
import SwiftUI


class TourneyTableViewModel: NSObject
    
{
    
    
    // MARK: - Services
    
    private lazy var pokerTracker: PokerTracker = PokerTracker()
    private lazy var sharkScope: SharkScope = SharkScope()
    
    
    // MARK: - Data
    
    /// The poker table this instance is tracking.
    private var tableWindowInfo: TableWindowInfo?
    private var tickCount: Int = 0
    
    /// View models for players seated at table.
    private var playerViewModels: [PlayerViewModel] = []
    
    /// SharkScope `Data`.
    // TODO: Move to `PlayerViewModel` later on.
    private var playerStatisticsForPlayerNames: [String:Statistics] = [:]
    private var playerTableCountsForPlayerNames: [String:Int] = [:]
    
    
    // MARK: - UI Data
    
    public var latestProcessedHandNumber: String = ""
    
    
    // MARK: - Binds
    
    private var onChange: (() -> Void)?
    
    
    // MARK: - Lifecycle
    
    public func track(_ tableWindowInfo: TableWindowInfo, onChange: (() -> Void)?)
    {
        // Retain.
        self.tableWindowInfo = tableWindowInfo
        self.onChange = onChange
        
        // Schedule timer.
        Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true)
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
           (result: Result<Timeline, RequestError>) in
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
            handOffset -= tickCount
            handOffset = max(handOffset, 0)
        
        // Get players of the latest hand tracked by PokerTracker.
        let latestHandPlayers = try pokerTracker.fetch(LatestHandPlayerQuery(tourneyNumber: tableInfo.tournamentNumber, handOffset: handOffset))
        
        // Only if new hands any.
        guard
            let firstPlayer = latestHandPlayers.first,
                firstPlayer.hand_no != latestProcessedHandNumber
        else
        { return }
        
        // Track.
        latestProcessedHandNumber = firstPlayer.hand_no
        
        // Collect `id_player` for current players.
        let latestHandPlayerIDs = latestHandPlayers
        .map{ eachPlayer in eachPlayer.id_player }

        // Collect `id_player` for view model players.
        var viewModelPlayerIDs: [Int] = playerViewModels.map
        {
            eachPlayerViewModel in
            eachPlayerViewModel.pokerTracker.latestHandPlayer.id_player
        }

        // Collect removable players.
        var removablePlayerIDs: [Int] = []
        viewModelPlayerIDs.forEach
        {
            eachViewModelPlayerID in
            if (latestHandPlayerIDs.contains(eachViewModelPlayerID) == false)
            { removablePlayerIDs.append(eachViewModelPlayerID) }
        }
        
        // Remove removable players.
        removablePlayerIDs.forEach
        {
            eachRemovablePlayerID in
            if let indexOfRemovablePlayer = viewModelPlayerIDs.firstIndex(of: eachRemovablePlayerID)
            { viewModelPlayerIDs.remove(at: indexOfRemovablePlayer) }
        }

        // Create / Collect new players if needed.
        latestHandPlayerIDs.forEach
        {
            eachCurrentPlayerID in
            if (viewModelPlayerIDs.contains(eachCurrentPlayerID) == false)
            {
                let eachIndex = latestHandPlayerIDs.firstIndex(of: eachCurrentPlayerID)!
                playerViewModels.append(PlayerViewModel(with: latestHandPlayers[eachIndex]))
            }
        }
        
        // Invoke callback.
        onChange?()
    }
    
    
    // MARK: - Summary Data
    
    public func summary(with font: NSFont) -> (blinds: NSAttributedString, stacks: NSAttributedString)
    {
        // Variables.
        var smallBlind:Double = 0
        var bigBlind:Double = 0
        var ante:Double = 0
        var players:Double = 0
        
        // Check data.
        guard let tableInfo = tableWindowInfo?.tableInfo
        else
        {
            // Empty state.
            return (
                NSMutableAttributedString(string: "-"),
                NSMutableAttributedString(string: "-")
            )
        }
        
        // Fetch data from first live table.
        smallBlind = Double(tableInfo.smallBlind)
        bigBlind = Double(tableInfo.bigBlind)
        ante = Double(tableInfo.ante)
        players = Double(playerViewModels.count)
        
        // Model.
        let M:Double = smallBlind + bigBlind + 9 * ante
        let M_5:Double = M * 5
        let M_10:Double = M * 10
        
        // View Model.
        let M_Rounded = String(format: "%.0f", ceil(M * 100) / 100)
        let M_5_Rounded = String(format: "%.0f", ceil(M_5 * 100) / 100)
        let M_10_Rounded = String(format: "%.0f", ceil(M_10 * 100) / 100)
        
        // Format.
        let lightAttribute: [NSAttributedString.Key: Any] = [
            .font : NSFont.systemFont(ofSize: font.pointSize, weight: NSFont.Weight.light),
            .foregroundColor : NSColor.systemGray
        ]
        
        let boldAttribute: [NSAttributedString.Key: Any]  = [
            .font : NSFont.systemFont(ofSize: font.pointSize, weight: NSFont.Weight.bold)
        ]
        
        let redAttribute: [NSAttributedString.Key: Any] = [
            .font : NSFont.systemFont(ofSize: font.pointSize, weight: NSFont.Weight.bold),
            .foregroundColor : NSColor.systemRed
        ]
        
        let orangeAttribute: [NSAttributedString.Key: Any] = [
            .font : NSFont.systemFont(ofSize: font.pointSize, weight: NSFont.Weight.bold),
            .foregroundColor : NSColor.systemOrange
            ]
        
        let yellowAttribute: [NSAttributedString.Key: Any] = [
            .font : NSFont.systemFont(ofSize: font.pointSize, weight: NSFont.Weight.bold),
            .foregroundColor : NSColor.systemYellow
            ]
        
        let levelString = NSMutableAttributedString(string: "")
            levelString.append(NSMutableAttributedString(string: String(format: "%.0f/%.0f", smallBlind, bigBlind), attributes:boldAttribute))
            levelString.append(NSMutableAttributedString(string: String(format: " Ante %.0f (%.0f players)", ante, players), attributes:lightAttribute))
        
        let stackString = NSMutableAttributedString(string: "")
        
            // M.
            stackString.append(NSMutableAttributedString(string: "1M ", attributes:lightAttribute))
            stackString.append(NSMutableAttributedString(string: String(format:"%@ ", M_Rounded), attributes:redAttribute))
            stackString.append(NSMutableAttributedString(string: String(format: "/ %.0f BB (%.0f hands)", M / bigBlind, players), attributes:lightAttribute))
            stackString.append(NSMutableAttributedString(string: "\n", attributes:lightAttribute))
        
            // 5M.
            stackString.append(NSMutableAttributedString(string: "5M ", attributes:lightAttribute))
            stackString.append(NSMutableAttributedString(string: String(format:"%@ ", M_5_Rounded), attributes:orangeAttribute))
            stackString.append(NSMutableAttributedString(string: String(format: "/ %.0f BB (%.0f hands)", M_5 / bigBlind, 5 * players), attributes:lightAttribute))
            stackString.append(NSMutableAttributedString(string: "\n", attributes:lightAttribute))
        
            // 10M.
            stackString.append(NSMutableAttributedString(string: "10M ", attributes:lightAttribute))
            stackString.append(NSMutableAttributedString(string: String(format:"%@ ", M_10_Rounded), attributes:yellowAttribute))
            stackString.append(NSMutableAttributedString(string: String(format: "/ %.0f BB (%.0f hands)", M_10 / bigBlind, 10 * players), attributes:lightAttribute))
        
        // Set.
        return (
            levelString,
            stackString
        )
    }
}


// MARK: - TableView Data

extension TourneyTableViewModel: NSTableViewDataSource
{
    
    
    func numberOfRows(in tableView: NSTableView) -> Int
    { return playerViewModels.count }
    
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView?
    {
        // Checks.
        guard let column = tableColumn else { return nil }
        guard playerViewModels.count > row else { return nil }
        
        // Data.
        let playerViewModel = playerViewModels[row]
        let latestHandPlayer = playerViewModel.pokerTracker.latestHandPlayer
        let statistics = playerViewModel.pokerTracker.statistics
        
        // Display data.
        let playerName = latestHandPlayer.player_name
        let stack = latestHandPlayer.stack
        
        // PokerTracker.
        var VPIP = "-"
        var PFR = "-"
        if let statistics = statistics
        {
            VPIP = String(format: "%.0f", statistics.VPIP * 100)
            PFR = String(format: "%.0f", statistics.PFR * 100)
        }
        
        var tables = "-"
        var count: Float?
        var profit: Float?
        var ROI = "-"
        var early = "-"
        var late = "-"
        var years: Float?
        var freq: Float?
        
        // Table count.
        if let tableCount = playerTableCountsForPlayerNames[playerName]
        { tables = String(tableCount) }
        
        // SharkScope.
        if let statistics = playerStatisticsForPlayerNames[playerName]
        {
            count = statistics.Count
            profit = statistics.isAuthorized(statistic: "Profit") ? statistics.Profit : nil
            ROI = statistics.isAuthorized(statistic: "AvROI") ? String(format: "%.1f%%", statistics.AvROI) : "-"
            early = String(format: "%.1f%%", statistics.FinshesEarly)
            late = String(format: "%.1f%%", statistics.FinshesLate)
            years = statistics.YearsPlayed
            freq = statistics.DaysBetweenPlays
        }
        
        let cellDecoratorsForTitles: [String:((NSTextField?) -> Void)] =
        [
            "Player" : { $0?.stringValue = playerName },
            "Stack" : { $0?.doubleValue = stack },
            "VPIP" : { $0?.stringValue = VPIP },
            "PFR" : { $0?.stringValue = PFR },
            "Tables" : { $0?.stringValue = tables },
            "Count" : { if let count = count { $0?.floatValue = count } },
            "Profit" : { if let profit = profit { $0?.floatValue = profit } },
            "ROI" : { $0?.stringValue = ROI },
            "Early" : { $0?.stringValue = early },
            "Late" : { $0?.stringValue = late },
            "Years" : { if let years = years { $0?.floatValue = years } },
            "Freq." : { if let freq = freq { $0?.floatValue = freq } }
        ]
        
        // Create cell view.
        guard let cellView = tableView.makeView(withIdentifier: (column.identifier), owner: self) as? NSTableCellView else { return nil }
        
        // Apply decorator.
        cellDecoratorsForTitles[column.title]!(cellView.textField)
        
        return cellView
    }
}


// MARK: - TableView Events

extension TourneyTableViewModel: NSTableViewDelegate
{
    
    
    func tableView(_ tableView: NSTableView, shouldSelectRow row: Int) -> Bool
    {
        // Checks.
        guard playerViewModels.count > row else { return false }
        
        // Data.
        let playerViewModel = playerViewModels[row]
        let playerName = playerViewModel.pokerTracker.latestHandPlayer.player_name
        
        // Copy name to clipboard.
        NSPasteboard.general.declareTypes([NSPasteboard.PasteboardType.string], owner: nil)
        NSPasteboard.general.setString(playerName, forType: NSPasteboard.PasteboardType.string)
        
        // Fetch summary.
        // let fetchPlayerName = "quAAsar"
        // let fetchPlayerName = "rybluk"
        // let fetchPlayerName = "perst777" // Blocked
        // let fetchPlayerName = "wASH1K"
        // let fetchPlayerName = "Taren Tano" // With space
        // let fetchPlayerName = "Brier Rose" // Full Tilt (Closed)
        // let fetchPlayerName = "NNiubility"
        // let fetchPlayerName = "dontumove" // One table
        let fetchPlayerName = playerName
        sharkScope.fetch(player: fetchPlayerName,
                         completion:
            {
                (result: Result<(playerSummary: PlayerSummary, activeTournaments: ActiveTournaments), RequestError>) in
                
                switch result
                {
                case .success(let responses):
                    
                    // Count only running (or late registration) tables.
                    let tables: Int = responses.activeTournaments.Response.PlayerResponse.PlayerView.Player.ActiveTournaments?.Tournament.reduce(0)
                    {
                        count, eachTournament in
                        count + (eachTournament.state != "Registering" ? 1 : 0)
                        } ?? 0
                    
                    // Logs.
                    print("\(responses.playerSummary.Response.PlayerResponse.PlayerView.Player.name) playing \(tables) tables.")
                    if let activeTournaments = responses.activeTournaments.Response.PlayerResponse.PlayerView.Player.ActiveTournaments
                    { print(activeTournaments) }
                    print(self.sharkScope.status)
                    
                    // Retain data.
                    self.playerStatisticsForPlayerNames[responses.playerSummary.Response.PlayerResponse.PlayerView.Player.name] = responses.playerSummary.Response.PlayerResponse.PlayerView.Player.Statistics
                    self.playerTableCountsForPlayerNames[responses.playerSummary.Response.PlayerResponse.PlayerView.Player.name] = tables
                    
                    // Invoke callback.
                    self.onChange?()
                    
                    break
                    
                case .failure(let error):
                    
                    print(error)
                    
                    // Update UI.
                    print(self.sharkScope.status)
                    
                    break
                }
        })
        
        return true
    }
}
