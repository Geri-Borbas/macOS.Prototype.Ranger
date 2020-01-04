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
    
    private var pokerTracker: PokerTracker = PokerTracker()
    private var sharkScope: SharkScope = SharkScope()
    
    
    // MARK: - Data
    
    /// The poker table this instance is tracking.
    private var tableWindowInfo: TableWindowInfo?
    private var tickCount: Int = 0
    private var tickTime = 1.0
    private var handUpdateTickFrequency = 100
    
    /// View models for players seated at table.
    private var playerViewModels: [PlayerViewModel] = []
    
    
    // MARK: - UI Data
    
    public var latestProcessedHandNumber: String = ""
    public var latestBigBlind: Int = 0
    private var sortDescriptors: [NSSortDescriptor]?
    private var selectedPlayerViewModel: PlayerViewModel?
    
    
    // MARK: - Binds
    
    @IBOutlet weak var stackLayoutPatameters: LayoutParameters!
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
            handOffset -= tickCount / handUpdateTickFrequency
            handOffset = max(handOffset, 0)
        
        // Get players of the latest hand tracked by PokerTracker.
        let latestHandPlayers = try pokerTracker.fetch(LatestHandPlayerQuery(tourneyNumber: tableInfo.tournamentNumber, handOffset: handOffset))
        
        // Only if players any.
        guard let firstPlayer = latestHandPlayers.first
        else { return }
        
        // Look for changes.
        let isNewHand = firstPlayer.hand_no != latestProcessedHandNumber
        let isNewBlindLevel = tableInfo.bigBlind != latestBigBlind
        let isSomethingChanged = isNewHand || isNewBlindLevel
        
        // Only on change.
        guard isSomethingChanged else { return }
        
        // Track.
        latestProcessedHandNumber = firstPlayer.hand_no
        
        // Create new view models for latest players.
        var latestHandPlayerViewModels = latestHandPlayers.map
        {
            eachLatestHandPlayer in
            PlayerViewModel(with: eachLatestHandPlayer)
        }

        // Save any SharkScope statistics if any.
        playerViewModels.forEach
        {
            eachPlayerViewModel in
            if (latestHandPlayerViewModels.contains(eachPlayerViewModel))
            {
                let index = latestHandPlayerViewModels.firstIndex(of: eachPlayerViewModel)!
                latestHandPlayerViewModels[index].sharkScope = eachPlayerViewModel.sharkScope
            }
        }
        
        // And just use the new collection.
        playerViewModels = latestHandPlayerViewModels
        
        // Get latest PokerTracker statistics.
        for eachIndex in playerViewModels.indices
        { playerViewModels[eachIndex].pokerTracker.update() }
        
        // Track largest stack.
        stackLayoutPatameters.maximum = NSNumber(value: playerViewModels.reduce(0, { max($0, $1.pokerTracker.latestHandPlayer.stack) }))
        
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
        playerViewModels = playerViewModels.sorted
        {
            lhs, rhs -> Bool in
            lhs.isInIncreasingOrder(to: rhs, using: sortDescriptors)
        }
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
        
        // Get data.
        let playerViewModel = playerViewModels[row]
        
        // Create / Reuse cell view.
        guard let cellView = tableView.makeView(withIdentifier: (column.identifier), owner: self) as? PlayerViewModelCellView else { return nil }
        
        // Apply data.
        cellView.setup(with: playerViewModel, in: tableColumn)
        
        // Select row if was selected before.
        if (self.selectedPlayerViewModel == playerViewModel)
        { tableView.selectRowIndexes(IndexSet(integer: row), byExtendingSelection: false) }
        
        return cellView
    }
    
    func tableView(_ tableView: NSTableView, sortDescriptorsDidChange oldDescriptors: [NSSortDescriptor])
    {
        // Sort view model using table sort descriptors.
        sort(using: tableView.sortDescriptors)
        tableView.reloadData()
    }
}


// MARK: - TableView Events

extension TourneyTableViewModel: NSTableViewDelegate
{
    
    // Plug custom row view.
    func tableView(_ tableView: NSTableView, rowViewForRow row: Int) -> NSTableRowView?
    { return RowView() }
    
    // Save selection.
    func tableView(_ tableView: NSTableView, shouldSelectRow row: Int) -> Bool
    {
        // Checks.
        guard playerViewModels.count > row else { return false }
        
        // Get data.
        let playerViewModel = playerViewModels[row]
        
        // Retain selection.
        self.selectedPlayerViewModel = playerViewModel
        
        return true
    }
    
    public func fetchSharkScopeStatisticsForPlayer(inRow row: Int)
    {
        print("TourneyTableViewModel.fetchSharkScopeStatisticsForPlayer(inRow: \(row))")
        
        // Checks.
        guard playerViewModels.count > row else { return }
        
        // Data.
        var playerViewModel = playerViewModels[row]
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
        // let fetchPlayerName = playerName
        sharkScope.fetch(player: playerName,
                         completion:
            {
                (result: Result<(playerSummary: PlayerSummary, activeTournaments: ActiveTournaments), RequestError>) in
                       
                print("sharkScope.fetch.completion()")
                
                switch result
                {
                    case .success(let responses):

                        // Retain.
                        playerViewModel.sharkScope.update(withSummary: responses.playerSummary, activeTournaments: responses.activeTournaments)
                        
                        // Write.
                        self.playerViewModels[row] = playerViewModel
                        
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
}
