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
        
        public mutating func updateStatistics(for tourneyNumber: String? = nil)
        {
            self.statistics = try? service.fetch(
                BasicPlayerStatisticsQuery(
                    playerIDs: [latestHandPlayer.id_player],
                    tourneyNumber: tourneyNumber
            )).first
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
    
    
    /// PokerTracker `id_player` makes unique view models (used for manage collections).
    static func == (lhs: PlayerViewModel, rhs: PlayerViewModel) -> Bool
    { lhs.pokerTracker.latestHandPlayer.id_player == rhs.pokerTracker.latestHandPlayer.id_player }
}


// MARK: - Description

extension PlayerViewModel: CustomStringConvertible
{
    
    
    var description: String
    {
        String(format:
            "\n%.0f\t%.0f\t%.0f\t%@",
            pokerTracker.latestHandPlayer.stack,
            (pokerTracker.statistics?.VPIP ?? 0) * 100,
            (pokerTracker.statistics?.PFR ?? 0) * 100,
            pokerTracker.latestHandPlayer.player_name
        )
    }
}


// MARK: - Column Data

extension PlayerViewModel
{
    
    
    var textFieldDataForColumnIdentifiers: [String:TextFieldData]
    {
        let dictionary: [String:TextFieldData] =
        [
            "Seat" : TextFieldIntData(value: pokerTracker.latestHandPlayer.seat),
            "Player" : TextFieldStringData(value: pokerTracker.latestHandPlayer.player_name),
            "Stack" : TextFieldDoubleData(value: pokerTracker.latestHandPlayer.stack),
            "VPIP" : TextFieldDoubleData(value: pokerTracker.statistics?.VPIP),
            "PFR" : TextFieldDoubleData(value: pokerTracker.statistics?.PFR),
            "Tables" : TextFieldIntData(value: sharkScope.tables),
            "ITM" : TextFieldFloatData(value: sharkScope.statistics?.ITM),
            "Early" : TextFieldFloatData(value: sharkScope.statistics?.FinshesEarly),
            "Late" : TextFieldFloatData(value: sharkScope.statistics?.FinshesLate),
            "Field Beaten" : TextFieldFloatData(value: sharkScope.statistics?.PercentFieldBeaten),
            "Finishes" : TextFieldDoubleData(value: sharkScope.statistics?.byPositionPercentage.trendLine.slope),
            "Count" : TextFieldFloatData(value: sharkScope.statistics?.Count),
            "Entrants" : TextFieldFloatData(value: sharkScope.statistics?.AvEntrants),
            "Stake" : TextFieldFloatData(value: sharkScope.statistics?.AvStake),
            "Years" : TextFieldFloatData(value: sharkScope.statistics?.YearsPlayed),
            "Losing" : TextFieldFloatData(value: sharkScope.statistics?.LosingDaysWithBreakEvenPercentage),
            "Winning" : TextFieldFloatData(value: sharkScope.statistics?.WinningDaysWithBreakEvenPercentage),
            "Profit" : TextFieldFloatData(value: sharkScope.statistics?.Profit),
            "ROI" : TextFieldFloatData(value: sharkScope.statistics?.AvROI),
            "Frequency" : TextFieldFloatData(value: sharkScope.statistics?.DaysBetweenPlays),
            "Games/Day" : TextFieldFloatData(value: sharkScope.statistics?.AvGamesPerDay),
            "Ability" : TextFieldFloatData(value: sharkScope.statistics?.Ability),
        ]
        return dictionary
    }
    
}


// MARK: - Sorting

extension PlayerViewModel
{
    
    
    func isInIncreasingOrder(to rhs: PlayerViewModel, using sortDescriptors: [NSSortDescriptor]) -> Bool
    {
        // Shortcut.
        let lhs = self
        
        // Convert for (hardcoded but) swifty sort descriptors (named order descriptors).
        let orderDescriptorsForSortDescriptorKeys: [String:(ascending: (PlayerViewModel, PlayerViewModel) -> Bool, descending: (PlayerViewModel, PlayerViewModel) -> Bool)] =
        [
            "Seat" :
            (
                ascending: { lhs, rhs in lhs.pokerTracker.latestHandPlayer.seat < rhs.pokerTracker.latestHandPlayer.seat },
                descending: { lhs, rhs in lhs.pokerTracker.latestHandPlayer.seat >= rhs.pokerTracker.latestHandPlayer.seat }
            ),
            "Stack" :
            (
                ascending: { lhs, rhs in lhs.pokerTracker.latestHandPlayer.stack < rhs.pokerTracker.latestHandPlayer.stack },
                descending: { lhs, rhs in lhs.pokerTracker.latestHandPlayer.stack >= rhs.pokerTracker.latestHandPlayer.stack }
            ),
            "VPIP" :
            (
                ascending: { lhs, rhs in lhs.pokerTracker.statistics?.VPIP ?? 0 < rhs.pokerTracker.statistics?.VPIP ?? 0 },
                descending: { lhs, rhs in lhs.pokerTracker.statistics?.VPIP ?? 0 >= rhs.pokerTracker.statistics?.VPIP ?? 0 }
            ),
            "PFR" :
            (
            ascending: { lhs, rhs in lhs.pokerTracker.statistics?.PFR ?? 0 < rhs.pokerTracker.statistics?.PFR ?? 0 },
            descending: { lhs, rhs in lhs.pokerTracker.statistics?.PFR ?? 0 >= rhs.pokerTracker.statistics?.PFR ?? 0 }
            ),
            "Tables" :
            (
                ascending: { lhs, rhs in lhs.sharkScope.tables ?? 0 < rhs.sharkScope.tables ?? 0 },
                descending: { lhs, rhs in lhs.sharkScope.tables ?? 0 >= rhs.sharkScope.tables ?? 0 }
            ),
            "ITM" :
            (
                ascending: { lhs, rhs in lhs.sharkScope.statistics?.ITM ?? 0 < rhs.sharkScope.statistics?.ITM ?? 0 },
                descending: { lhs, rhs in lhs.sharkScope.statistics?.ITM ?? 0 >= rhs.sharkScope.statistics?.ITM ?? 0 }
            ),
            "Early" :
            (
                ascending: { lhs, rhs in lhs.sharkScope.statistics?.FinshesEarly ?? 0 < rhs.sharkScope.statistics?.FinshesEarly ?? 0 },
                descending: { lhs, rhs in lhs.sharkScope.statistics?.FinshesEarly ?? 0 >= rhs.sharkScope.statistics?.FinshesEarly ?? 0 }
            ),
            "Late" :
            (
                ascending: { lhs, rhs in lhs.sharkScope.statistics?.FinshesLate ?? 0 < rhs.sharkScope.statistics?.FinshesLate ?? 0 },
                descending: { lhs, rhs in lhs.sharkScope.statistics?.FinshesLate ?? 0 >= rhs.sharkScope.statistics?.FinshesLate ?? 0 }
            ),
            "Field Beaten" :
            (
                ascending: { lhs, rhs in lhs.sharkScope.statistics?.PercentFieldBeaten ?? 0 < rhs.sharkScope.statistics?.PercentFieldBeaten ?? 0 },
                descending: { lhs, rhs in lhs.sharkScope.statistics?.PercentFieldBeaten ?? 0 >= rhs.sharkScope.statistics?.PercentFieldBeaten ?? 0 }
            ),
            "Finishes" :
            (
                ascending: { lhs, rhs in lhs.sharkScope.statistics?.byPositionPercentage.trendLine.slope ?? 0 < rhs.sharkScope.statistics?.byPositionPercentage.trendLine.slope ?? 0 },
                descending: { lhs, rhs in lhs.sharkScope.statistics?.byPositionPercentage.trendLine.slope ?? 0 >= rhs.sharkScope.statistics?.byPositionPercentage.trendLine.slope ?? 0 }
            ),
            "Count" :
            (
                ascending: { lhs, rhs in lhs.sharkScope.statistics?.Count ?? 0 < rhs.sharkScope.statistics?.Count ?? 0 },
                descending: { lhs, rhs in lhs.sharkScope.statistics?.Count ?? 0 >= rhs.sharkScope.statistics?.Count ?? 0 }
            ),
            "Entrants" :
            (
                ascending: { lhs, rhs in lhs.sharkScope.statistics?.AvEntrants ?? 0 < rhs.sharkScope.statistics?.AvEntrants ?? 0 },
                descending: { lhs, rhs in lhs.sharkScope.statistics?.AvEntrants ?? 0 >= rhs.sharkScope.statistics?.AvEntrants ?? 0 }
            ),
            "Stake" :
            (
                ascending: { lhs, rhs in lhs.sharkScope.statistics?.Stake ?? 0 < rhs.sharkScope.statistics?.Stake ?? 0 },
                descending: { lhs, rhs in lhs.sharkScope.statistics?.Stake ?? 0 >= rhs.sharkScope.statistics?.Stake ?? 0 }
            ),
            "Years" :
            (
                ascending: { lhs, rhs in lhs.sharkScope.statistics?.YearsPlayed ?? 0 < rhs.sharkScope.statistics?.YearsPlayed ?? 0 },
                descending: { lhs, rhs in lhs.sharkScope.statistics?.YearsPlayed ?? 0 >= rhs.sharkScope.statistics?.YearsPlayed ?? 0 }
            ),
            "Losing" :
            (
                ascending: { lhs, rhs in lhs.sharkScope.statistics?.LosingDaysWithBreakEvenPercentage ?? 0 < rhs.sharkScope.statistics?.LosingDaysWithBreakEvenPercentage ?? 0 },
                descending: { lhs, rhs in lhs.sharkScope.statistics?.LosingDaysWithBreakEvenPercentage ?? 0 >= rhs.sharkScope.statistics?.LosingDaysWithBreakEvenPercentage ?? 0 }
            ),
            "Winning" :
            (
                ascending: { lhs, rhs in lhs.sharkScope.statistics?.WinningDaysWithBreakEvenPercentage ?? 0 < rhs.sharkScope.statistics?.WinningDaysWithBreakEvenPercentage ?? 0 },
                descending: { lhs, rhs in lhs.sharkScope.statistics?.WinningDaysWithBreakEvenPercentage ?? 0 >= rhs.sharkScope.statistics?.WinningDaysWithBreakEvenPercentage ?? 0 }
            ),
            "Profit" :
            (
                ascending: { lhs, rhs in lhs.sharkScope.statistics?.Profit ?? 0 < rhs.sharkScope.statistics?.Profit ?? 0 },
                descending: { lhs, rhs in lhs.sharkScope.statistics?.Profit ?? 0 >= rhs.sharkScope.statistics?.Profit ?? 0 }
            ),
            "ROI" :
            (
                ascending: { lhs, rhs in lhs.sharkScope.statistics?.AvROI ?? 0 < rhs.sharkScope.statistics?.AvROI ?? 0 },
                descending: { lhs, rhs in lhs.sharkScope.statistics?.AvROI ?? 0 >= rhs.sharkScope.statistics?.AvROI ?? 0 }
            ),
            "Frequency" :
            (
                ascending: { lhs, rhs in lhs.sharkScope.statistics?.DaysBetweenPlays ?? 0 < rhs.sharkScope.statistics?.DaysBetweenPlays ?? 0 },
                descending: { lhs, rhs in lhs.sharkScope.statistics?.DaysBetweenPlays ?? 0 >= rhs.sharkScope.statistics?.DaysBetweenPlays ?? 0 }
            ),
            "Games/Day" :
            (
                ascending: { lhs, rhs in lhs.sharkScope.statistics?.AvGamesPerDay ?? 0 < rhs.sharkScope.statistics?.AvGamesPerDay ?? 0 },
                descending: { lhs, rhs in lhs.sharkScope.statistics?.AvGamesPerDay ?? 0 >= rhs.sharkScope.statistics?.AvGamesPerDay ?? 0 }
            ),
            "Ability" :
            (
                ascending: { lhs, rhs in lhs.sharkScope.statistics?.Ability ?? 0 < rhs.sharkScope.statistics?.Ability ?? 0 },
                descending: { lhs, rhs in lhs.sharkScope.statistics?.Ability ?? 0 >= rhs.sharkScope.statistics?.Ability ?? 0 }
            )
        ]
        
        // Use only the first sort descriptor (for now).
        guard let firstSortDescriptor = sortDescriptors.first
        else { return false }
        
        // Lookup corresponding order descriptor.
        guard let eachOrderDescriptor = orderDescriptorsForSortDescriptorKeys[firstSortDescriptor.key ?? ""]
        else { return false }
        
        // Select direction.
        let selectedOrderDescriptor = firstSortDescriptor.ascending ? eachOrderDescriptor.ascending : eachOrderDescriptor.descending
        
        // Determine order.
        return selectedOrderDescriptor(lhs, rhs)
    }
}


// MARK: - Strings

extension PlayerViewModel
{
    
    
    var playerName: String
    { pokerTracker.latestHandPlayer.player_name }
    
    var statisticsSummary: String
    {
        String(format:
            """
            Early Finish: %.0f
            Late Finish: %.0f
            Field Beaten: %.0f
            Finishes: %.f
            Losing/Winning: %.f/%.f

            ITM: %.0f%%
            Count: %@

            ROI: %.f%%
            Profit: $%@
            """,
               sharkScope.statistics?.FinshesEarly ?? 0,
               sharkScope.statistics?.FinshesLate ?? 0,
               sharkScope.statistics?.PercentFieldBeaten ?? 0,
               ((sharkScope.statistics?.byPositionPercentage.trendLine.slope ?? 0) * -10000.0),
               (sharkScope.statistics?.LosingDaysWithBreakEvenPercentage ?? 0) * 100.0,
               (sharkScope.statistics?.WinningDaysWithBreakEvenPercentage ?? 0) * 100.0,
               
               sharkScope.statistics?.ITM ?? 0,
               (sharkScope.statistics?.Count ?? 0).formattedWithSeparator,
               
               sharkScope.statistics?.AvROI ?? 0,
               (sharkScope.statistics?.AvProfit ?? 0).formattedWithSeparator
        )
    }
}


extension Formatter
{
    
    
    static let withSeparator: NumberFormatter =
    {
        let formatter = NumberFormatter()
        formatter.groupingSeparator = " "
        formatter.numberStyle = .decimal
        return formatter
    }()
}


extension Numeric
{
    
    
    var formattedWithSeparator: String
    { return Formatter.withSeparator.string(for: self) ?? "" }
}
