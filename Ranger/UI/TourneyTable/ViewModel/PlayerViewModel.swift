//
//  PlayerViewModel.swift
//  Ranger
//
//  Created by Geri Borbás on 2019. 12. 23..
//  Copyright © 2019. Geri Borbás. All rights reserved.
//

import Foundation


struct PlayerViewModel
{

    
    var pokerTracker: PokerTracker
    var sharkScope: SharkScope
    
       
    struct PokerTracker: Equatable
    {
        
        
        // Data.
        let latestHandPlayer: LatestHandPlayer
        var statistics: BasicPlayerStatistics?
        
        // Service.
        private lazy var service: Ranger.PokerTracker = Ranger.PokerTracker()
        
        
        init(with latestHandPlayer: LatestHandPlayer)
        {
            self.latestHandPlayer = latestHandPlayer
        }
        
        public mutating func update()
        {
            self.statistics = try? service.fetch(BasicPlayerStatisticsQuery(playerIDs: [latestHandPlayer.id_player])).first
        }
    }
    
    
    struct SharkScope: Equatable
    {
        
        
        let playerName: String
        var summary: PlayerSummary?
        var activeTournaments: ActiveTournaments?
        var tables: Int?
        var statistics: Statistics? { summary?.Response.PlayerResponse.PlayerView.Player.Statistics }
        
        
        init(with playerName: String)
        {
            self.playerName = playerName
        }
        
        public mutating func update(withSummary summary: PlayerSummary, activeTournaments: ActiveTournaments)
        {
            print("PlayerViewModel.SharkScope.update()")
            
            self.summary = summary
            self.activeTournaments = activeTournaments
            
            // Count only running (or late registration) tables.
            self.tables = activeTournaments.Response.PlayerResponse.PlayerView.Player.ActiveTournaments?.Tournament.reduce(0)
            {
                count, eachTournament in
                count + (eachTournament.state != "Registering" ? 1 : 0)
            } ?? 0

            // Logs.
            if let activeTournaments = activeTournaments.Response.PlayerResponse.PlayerView.Player.ActiveTournaments
            { print(activeTournaments) }
        }
    }
    
    
    init(with latestHandPlayer: LatestHandPlayer)
    {
        self.pokerTracker = PokerTracker(with: latestHandPlayer)
        self.sharkScope = SharkScope(with: latestHandPlayer.player_name)
    }
}


extension PlayerViewModel: Equatable
{
    
    
    /// PokerTracker `id_player` makes unique view models.
    static func == (lhs: PlayerViewModel, rhs: PlayerViewModel) -> Bool
    { lhs.pokerTracker.latestHandPlayer.id_player == rhs.pokerTracker.latestHandPlayer.id_player }
}


// MARK: - Column Data

extension PlayerViewModel
{
    
    
    var textFieldDataForColumnIdentifiers: [String:TextFieldData]
    {
        let dict: [String:TextFieldData] =
        [
            "Player" : TextFieldStringData(value: pokerTracker.latestHandPlayer.player_name),
            "Stack" : TextFieldDoubleData(value: pokerTracker.latestHandPlayer.stack),
            "VPIP" : TextFieldDoubleData(value: pokerTracker.statistics?.VPIP),
            "PFR" : TextFieldDoubleData(value: pokerTracker.statistics?.PFR),
            "Tables" : TextFieldIntData(value: sharkScope.tables),
            "Count" : TextFieldFloatData(value: sharkScope.statistics?.Count),
            "Profit" : TextFieldFloatData(value: sharkScope.statistics?.Profit),
            "Stake" : TextFieldFloatData(value: sharkScope.statistics?.AvStake),
            "ROI" : TextFieldFloatData(value: sharkScope.statistics?.AvROI),
            "ITM" : TextFieldFloatData(value: sharkScope.statistics?.ITM),
            "Early" : TextFieldFloatData(value: sharkScope.statistics?.FinshesEarly),
            "Late" : TextFieldFloatData(value: sharkScope.statistics?.FinshesLate),
            "Field Beaten" : TextFieldFloatData(value: sharkScope.statistics?.PercentFieldBeaten),
            "Years" : TextFieldFloatData(value: sharkScope.statistics?.YearsPlayed),
            "Freq." : TextFieldFloatData(value: sharkScope.statistics?.DaysBetweenPlays),
            "Entrants" : TextFieldFloatData(value: sharkScope.statistics?.AvEntrants),
            "Games/Day" : TextFieldFloatData(value: sharkScope.statistics?.AvGamesPerDay),
            "Ability" : TextFieldFloatData(value: sharkScope.statistics?.Ability),
            "Losing" : TextFieldFloatData(value: sharkScope.statistics?.LosingDaysWithBreakEvenPercentage),
            "Winning" : TextFieldFloatData(value: sharkScope.statistics?.WinningDaysWithBreakEvenPercentage),
        ]
        return dict
    }
}

