//
//  TourneyTableViewModel.swift
//  Ranger
//
//  Created by Geri Borbás on 2019. 12. 14..
//  Copyright © 2019. Geri Borbás. All rights reserved.
//

import Foundation
import SwiftUI


class TourneyTableViewModel: NSObject, NSTableViewDelegate, NSTableViewDataSource
{
    
    
    // MARK: - Services
    
    lazy var pokerTracker: PokerTracker = PokerTracker()
    lazy var sharkScope: SharkScope = SharkScope()
    
    
    // MARK: - Data
    
    var players:[[String: String]] = [[:]]
    {
        didSet
        {
            // Look for changes.
            if players.elementsEqual(oldValue) == false
            { onChange?() }
        }
    }
    
    // var Tables:[[]]
    
    var selectedTableIndex: Int = 0
    {
        didSet
        {
            // Look for changes.
            if selectedTableIndex != oldValue
            {
                processLiveData() // May invoke `players.didSet` above
            }
        }
    }
    
    
    // MARK: - Binds
    
    var onChange: (() -> Void)?
    
    
    // MARK: - Lifecycle
    
    func start(onTick: (() -> Void)?)
    {        
        // Retain.
        self.onChange = onTick
        
        // Schedule timer.
        Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true)
        { _ in self.tick() }
        
        // Test.
        sharkScope.test()
    }
    
    
    // MARK: - Fetch
    
    func tick()
    {
        processLiveData()
    }
    
    func processLiveData()
    {
        // Fetch.
        try? pokerTracker.fetchLiveTourneyPlayerCollection()
        try? pokerTracker.fetchLiveTourneyTableCollection()
        // try? pokerTracker.fetchBasicPlayerStatisticsCollection()
        
        // Check data.
        guard let liveTourneyPlayerCollection = pokerTracker.liveTourneyPlayerCollection, liveTourneyPlayerCollection.rows.count > 0
        else
        {
            print("No live tables found.")
            return
        }
        
        /*
        guard let basicPlayerStatisticsCollection = pokerTracker.basicPlayerStatisticsCollection, basicPlayerStatisticsCollection.rows.count > 0
        else
        {
            print("No player statistics found.")
            return
        }
        */
        
        // Collect `id_player` for live players.
        let liveTourneyPlayerIDs = liveTourneyPlayerCollection.rows
        .map{ eachLiveTourneyPlayer in eachLiveTourneyPlayer.id_player }
        
        // Log.
        print("liveTourneyPlayerIDs: \(liveTourneyPlayerIDs)")
        
        // Collect names.
        try? pokerTracker.fetchPlayerCollection(for: liveTourneyPlayerIDs)
        
        // Check data.
        guard let playerCollection = pokerTracker.playerCollection, playerCollection.rows.count > 0
        else
        {
            print("No players found.")
            return
        }
        
        // Collect statistics for live players.
        /*
        let playerStatistics = basicPlayerStatisticsCollection.rows
        .filter
        {
            eachBasicPlayerStatistics in
            liveTourneyPlayerIDs.contains(eachBasicPlayerStatistics.id_player)
        }
        */
        
        // Log.
        // print("basicPlayerStatisticsCollection.rows \(basicPlayerStatisticsCollection.rows)")
        // print("playerStatistics: \(playerStatistics)")
        
        // .reduce([], { playerIDs, eachPlayerID in playerIDs.contains(eachPlayerID) ? playerIDs : playerIDs + [eachPlayerID] })
        
        // Crunch data for UI (may invoke `players.didSet`).
        players = liveTourneyPlayerCollection.rows
        .filter
        {
            (eachLiveTourneyPlayer: LiveTourneyPlayer) in
            eachLiveTourneyPlayer.id_live_table == selectedTableIndex + 1 // Get rid of this after hooking up `NSComboBoxDataSource`
        }
        .map
        {
            (eachLiveTourneyPlayer: LiveTourneyPlayer) in
            // let eachLiveTourneyPlayerStatistics = playerStatistics.filter{ eachPlayerStatistics in eachPlayerStatistics.id_player == eachLiveTourneyPlayer.id_player }.first
            let eachPlayer = playerCollection.rows.filter{ eachPlayer in eachPlayer.id_player == eachLiveTourneyPlayer.id_player }.first
            print(eachPlayer?.id_player as Any)
            print(eachPlayer?.player_name as Any)
            return [
                "Player" : "\(eachLiveTourneyPlayer.id_player) at \(eachLiveTourneyPlayer.id_live_table)",
                "Stack" : String(eachLiveTourneyPlayer.amt_stack)
            ]
        }
    }
    
    
    // MARK: - TableView Hooks

    func numberOfRows(in tableView: NSTableView) -> Int
    { return players.count }
    
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView?
    {
        // Checks.
        guard let column = tableColumn else { return nil }
        
        // Data.
        let player = players[row]
        
        // Cell view.
        guard let cellView = tableView.makeView(withIdentifier: (column.identifier), owner: self) as? NSTableCellView else { return nil }
        cellView.textField?.stringValue = player[column.title] ?? ""
        
        return cellView
    }
    
    
}
