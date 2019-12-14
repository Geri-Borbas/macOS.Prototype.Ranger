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
    
    
    // MARK: - Display Data
    
    var tables:[String] = []
    {
        didSet
        {
            // Look for changes.
            if tables.elementsEqual(oldValue) == false
            { onChange?() }
        }
    }
    
    var players:[[String: String]] = [[:]]
    {
        didSet
        {
            // Look for changes.
            if players.elementsEqual(oldValue) == false
            { onChange?() }
        }
    }
    
    var selectedTableIndex: Int = 0
    {
        didSet
        {
            // Look for changes.
            if selectedTableIndex != oldValue
            {
                try? processData() // May invoke `players.didSet` above
            }
        }
    }
    
    
    // MARK: - Data
    
    var liveTourneyTables: [LiveTourneyTable] = []
    
    
    // MARK: - Binds
    
    var onChange: (() -> Void)?
    
    
    // MARK: - Lifecycle
    
    func start(onChange: (() -> Void)?)
    {
        print("TourneyTableViewModel.start()")
        
        // Retain.
        self.onChange = onChange
        
        // Schedule timer.
        Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true)
        { _ in self.tick() }
        
        // Test.
        sharkScope.test()
    }
    
    
    // MARK: - Fetch
    
    func tick()
    {
        try? processData()
    }
    
    func processData() throws
    {
        // Fetch data.
        liveTourneyTables = try pokerTracker.fetch(LiveTourneyTableQuery())
        let liveTourneyPlayers = try pokerTracker.fetch(LiveTourneyPlayerQuery())
        
        // Format tables (may invoke `players.didSet`).
        tables = liveTourneyTables.map(
        {
            (eachTable: LiveTourneyTable) -> String in
            String(format: "Table %d - %.0f/%.0f Ante %.0f (%d players)",
                   eachTable.id_live_table,
                   eachTable.amt_sb,
                   eachTable.amt_bb,
                   eachTable.amt_ante,
                   eachTable.cnt_players
            )
        })
        
        print("tables: \(tables)")
        
        // Collect `id_player` for live players.
        let liveTourneyPlayerIDs = liveTourneyPlayers
        .map{ eachLiveTourneyPlayer in eachLiveTourneyPlayer.id_player }
        
        // Log.
        // print("liveTourneyPlayerIDs: \(liveTourneyPlayerIDs)")
        
        // Fetch player names.
        let playerNames = try pokerTracker.fetch(PlayerQuery(playerIDs: liveTourneyPlayerIDs))
        
        // Crunch data for UI (may invoke `players.didSet`).
        players = liveTourneyPlayers
        .filter
        {
            (eachLiveTourneyPlayer: LiveTourneyPlayer) in
            eachLiveTourneyPlayer.id_live_table == selectedTableIndex + 1 // Get rid of this after hooking up `NSComboBoxDataSource`
        }
        .map
        {
            (eachLiveTourneyPlayer: LiveTourneyPlayer) in
            // let eachLiveTourneyPlayerStatistics = playerStatistics.filter{ eachPlayerStatistics in eachPlayerStatistics.id_player == eachLiveTourneyPlayer.id_player }.first
            let eachPlayer = playerNames.filter{ eachPlayer in eachPlayer.id_player == eachLiveTourneyPlayer.id_player }.first
            let eachPlayerName = eachPlayer?.player_name ?? ""
            // print(eachPlayer?.id_player as Any)
            // print(eachPlayer?.player_name as Any)
            return [
                "Player" : "\(eachPlayerName) at \(eachLiveTourneyPlayer.id_live_table)",
                "Stack" : String(eachLiveTourneyPlayer.amt_stack)
            ]
        }
    }
    
    func tableSummary(for index: Int, font: NSFont) -> (blinds: NSAttributedString, stacks: NSAttributedString)
    {
        // Variables.
        var smallBlind:Double = 0
        var bigBlind:Double = 0
        var ante:Double = 0
        var players:Double = 0
        
        // Check data.
        if (tables.count == 0)
        {
            // Empty state.
            return (
                NSMutableAttributedString(string: "-"),
                NSMutableAttributedString(string: "-")
            )
        }
        
        // Fetch data from first live table.
        let selectedLiveTourneyTable = liveTourneyTables[index]
        smallBlind = selectedLiveTourneyTable.amt_sb
        bigBlind = selectedLiveTourneyTable.amt_bb
        ante = selectedLiveTourneyTable.amt_ante
        players = Double(selectedLiveTourneyTable.cnt_players)
        
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
    
    
    // MARK: - TableView Data Hooks

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
