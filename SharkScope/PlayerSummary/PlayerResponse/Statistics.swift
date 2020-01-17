
//
//  Statistics.swift
//  Ranger
//
//  Created by Geri Borbás on 2019. 12. 18..
//  Copyright © 2019. Geri Borbás. All rights reserved.
//

import Foundation


public struct Statistics: Decodable, Equatable
{

    
    typealias StatisticType = Statistic
    

    public let displayCurrency: String
    public let Statistic: [Statistic]
    public let StatisticalDataSet: [StatisticalDataSet]
    // Timeline
    
    /// `Statistic.value` / `Statistic.authorized` index keyed by `Statistic.id`.
    private let statisticValuesByIds: [String:String]
    private let statisticAuthorizationByIds: [String:Bool]
    
    // Data sets.
    public let byPositionPercentage: GraphData

    
    public struct Statistic: Decodable, Equatable
    {


        public let id: String
        public let value: String
        public var authorized: StringFor<Bool>?
        
        public init(from decoder: Decoder) throws
        {
            // Decode `id`.
            let container = try decoder.container(keyedBy: DynamicCodingKey.self)
            self.id = try container.decode(String.self, forKey: DynamicCodingKey(stringValue: "id")!)
            
            // Decode value (if authorized).
            self.authorized = try container.decodeIfPresent(StringFor<Bool>.self, forKey: DynamicCodingKey(stringValue: "authorized")!)
            if (self.authorized?.value == false)
            { self.value = "" }
            else
            { self.value = try container.decode(String.self, forKey: DynamicCodingKey(stringValue: "value")!) }
        }
    }
    
    
    public struct StatisticalDataSet: Decodable, Equatable
    {


        public let id: String
        public let Data: [Data]?
        public let authorized: StringFor<Bool>?
        
        
        public struct Data: Decodable, Equatable
        {


            public let x: String
            public let Y: [Y]
            
            
            public struct Y: Decodable, Equatable
            {


                public let id: String
                public let value: String
            }
        }
    }
    
    
    public init(from decoder: Decoder) throws
    {
        // Default(ish) implementation.
        let container = try decoder.container(keyedBy: DynamicCodingKey.self)
        self.displayCurrency = try container.decode(String.self, forKey: DynamicCodingKey(stringValue: "displayCurrency")!)
        self.Statistic = try container.decode([StatisticType].self, forKey: DynamicCodingKey(stringValue: "Statistic")!)
        self.StatisticalDataSet = try container.decode([Statistics.StatisticalDataSet].self, forKey: DynamicCodingKey(stringValue: "StatisticalDataSet")!)
        
        // Create index for Statistics Accessors below.
        self.statisticValuesByIds = Dictionary(uniqueKeysWithValues: self.Statistic.map{ ($0.id, $0.value) })
        self.statisticAuthorizationByIds = Dictionary(uniqueKeysWithValues: self.Statistic.map{ ($0.id, $0.authorized?.value ?? true) })
        
        // Extract "ByPositionPercentage".
        let byPositionPercentageDataSet = self.StatisticalDataSet.filter{ $0.id == "ByPositionPercentage" }.first
        self.byPositionPercentage = GraphData(from: byPositionPercentageDataSet)
    }
    
    public func isAuthorized(statistic: String) -> Bool
    {
        guard statisticAuthorizationByIds.keys.contains(statistic)
        else { return false }
        
        return statisticAuthorizationByIds[statistic]!
    }
}


// MARK: - Statistics Accessors

extension Statistics
{
        
    /// The Ability rating is a rating that goes up to 100 and shows a player’s ability
    /// based on an assessment of all the other statistics we have compiled for that player.
    public var Ability: Float { Float(self.statisticValuesByIds["Ability"] ?? "0") ?? 0 }
    
    /// The total points from the player’s unlocked SharkScope Achievements. Each regular
    /// card achievement unlocked is worth 1 point, face cards are worth 3 points and aces
    /// 5 achievement points.
    public var AchievementPoints: Float { Float(self.statisticValuesByIds["AchievementPoints"] ?? "0") ?? 0 }
    
    /// The total number of days the player has played on.
    public var ActiveDayCount: Float { Float(self.statisticValuesByIds["ActiveDayCount"] ?? "0") ?? 0 }
    
    /// The average number of entrants in the played tournaments.
    public var AvEntrants: Float { Float(self.statisticValuesByIds["AvEntrants"] ?? "0") ?? 0 }
    
    /// The average completion time of each tournament played (in seconds).
    public var AvGameDuration: Float { Float(self.statisticValuesByIds["AvGameDuration"] ?? "0") ?? 0 }
    
    /// The average number of games per day on active days.
    public var AvGamesPerDay: Float { Float(self.statisticValuesByIds["AvGamesPerDay"] ?? "0") ?? 0 }
    
    /// The average profit including rake.
    public var AvProfit: Float? { isAuthorized(statistic: "AvProfit") ? Float(self.statisticValuesByIds["AvProfit"] ?? "0") ?? 0 : nil }
    
    /// Average ROI is the average Return On Investment. It is calculated as the average of each
    /// ((payout-(stake+rake))*100)/(stake+rake). So it will be -100% for a player that loses
    /// every game, and about 309% for a player that wins every 9 handed game. It could of course
    /// be a lot higher if, for example the player won every 180 player game they played in. It
    /// is a measure of ability independent of stake. Another way to look at it is as an ITM%
    /// (In The Money percentage) weighted to the actual payouts relative to the stake. Please
    /// note that this figure is the average of the ROIs which is different from Total ROI which
    /// is the ROI of the averages.
    public var AvROI: Float? { isAuthorized(statistic: "AvROI") ? Float(self.statisticValuesByIds["AvROI"] ?? "0") ?? 0 : nil }
    
    /// The average stake of the tournaments played.
    public var AvStake: Float { Float(self.statisticValuesByIds["AvStake"] ?? "0") ?? 0 }
    
    /// The bankroll needed for the worst losing period.
    public var Bankroll: Float { Float(self.statisticValuesByIds["Bankroll"] ?? "0") ?? 0 }
    
    /// The average profit for the player’s best 100-game winning streak.
    public var Best100StreakAvProfit: Float { Float(self.statisticValuesByIds["Best100StreakAvProfit"] ?? "0") ?? 0 }
    
    /// The average profit for the player’s best 500-game winning streak.
    public var Best500StreakAvProfit: Float { Float(self.statisticValuesByIds["Best500StreakAvProfit"] ?? "0") ?? 0 }
    
    /// The total number of days the player played but did not make a profit or a loss.
    public var BreakEvenDays: Float { Float(self.statisticValuesByIds["BreakEvenDays"] ?? "0") ?? 0 }
    
    /// The sum of all the player’s cashes.
    public var Cashes: Float { Float(self.statisticValuesByIds["Cashes"] ?? "0") ?? 0 }
    
    /// The total number of tournaments the player has played.
    public var Count: Float { Float(self.statisticValuesByIds["Count"] ?? "0") ?? 0 }
    
    /// The frequency the player has finished in the bottom 10% of tournaments.
    public var FinshesEarly: Float { Float(self.statisticValuesByIds["FinshesEarly"] ?? "0") ?? 0 }
    
    /// The frequency the player has finished in the bottom 10% to 30% of tournaments.
    public var FinshesEarlyMiddle: Float { Float(self.statisticValuesByIds["FinshesEarlyMiddle"] ?? "0") ?? 0 }
    
    /// The frequency the player has finished in the top 10% of tournaments.
    public var FinshesLate: Float { Float(self.statisticValuesByIds["FinshesLate"] ?? "0") ?? 0 }
    
    /// The frequency the player has finished in the middle 40% of tournaments.
    public var FinshesMiddle: Float { Float(self.statisticValuesByIds["FinshesMiddle"] ?? "0") ?? 0 }
    
    /// The frequency the player has finished in the top 10% to 30% of tournaments.
    public var FinshesMiddleLate: Float { Float(self.statisticValuesByIds["FinshesMiddleLate"] ?? "0") ?? 0 }
    
    /// The date/time of the first game played.
    public var FirstGameDate: Date { Date(timeIntervalSince1970: Double(self.statisticValuesByIds["FirstGameDate"] ?? "0") ?? 0 ) }
    
    /// The frequency the player cashes and is In The Money.
    public var ITM: Float { Float(self.statisticValuesByIds["ITM"] ?? "0") ?? 0 }
    
    /// The date/time of the last game played.
    public var LastGameDate: Date { Date(timeIntervalSince1970: Double(self.statisticValuesByIds["LastGameDate"] ?? "0") ?? 0 ) }
    
    /// The total number of days the player had a loss.
    public var LosingDays: Float { Float(self.statisticValuesByIds["LosingDays"] ?? "0") ?? 0 }
    
    /// The player’s highest number of consecutive tournaments where they finished In The Money.
    public var MaxCashingStreak: Float { Float(self.statisticValuesByIds["MaxCashingStreak"] ?? "0") ?? 0 }
    
    /// The player’s highest number of consecutive tournaments losses.
    public var MaxLosingStreak: Float { Float(self.statisticValuesByIds["MaxLosingStreak"] ?? "0") ?? 0 }
    
    /// The player’s highest number of consecutive 1st place tournaments finishes.
    public var MaxWinningStreak: Float { Float(self.statisticValuesByIds["MaxWinningStreak"] ?? "0") ?? 0 }
    
    /// The most Games the player has played in a day.
    public var MostGamesInDay: Float { Float(self.statisticValuesByIds["MostGamesInDay"] ?? "0") ?? 0 }
    
    /// The number of PokerStars Tournament Leaderboard Points earned
    /// (http://www.pokerstars.com/poker/tournaments/leader-board/explained/).
    public var PTLBPoints: Float { Float(self.statisticValuesByIds["PTLBPoints"] ?? "0") ?? 0 }
    
    /// The average percentage of field beaten.
    public var PercentFieldBeaten: Float { Float(self.statisticValuesByIds["PercentFieldBeaten"] ?? "0") ?? 0 }
    
    /// The total profit including rake.
    public var Profit: Float? { isAuthorized(statistic: "Profit") ? Float(self.statisticValuesByIds["Profit"] ?? "0") ?? 0 : nil }
    
    /// The sum of all rake paid by the player.
    public var Rake: Float { Float(self.statisticValuesByIds["Rake"] ?? "0") ?? 0 }
    
    /// The sum of all money staked by the player.
    public var Stake: Float { Float(self.statisticValuesByIds["Stake"] ?? "0") ?? 0 }
    
    /// The total ROI (Return on Investment).
    public var TotalROI: Float? { isAuthorized(statistic: "TotalROI") ? Float(self.statisticValuesByIds["TotalROI"] ?? "0") ?? 0 : nil }
    
    /// The total numbers of 1st place tournament finishes.
    public var TournamentWins: Float { Float(self.statisticValuesByIds["TournamentWins"] ?? "0") ?? 0 }
    
    /// The frequency the player plays Turbo or Super Turbo tournaments.
    public var TurboRatio: Float { Float(self.statisticValuesByIds["TurboRatio"] ?? "0") ?? 0 }
    
    /// A User-provided note on the player.
    public var UserNote: String { self.statisticValuesByIds["UserNote"] ?? "0" }
    
    /// The total number of days the player had a profit.
    public var WinningDays: Float { Float(self.statisticValuesByIds["WinningDays"] ?? "0") ?? 0 }
    
    /// Average Profit for the player’s worst 100-game losing streak.
    public var Worst100StreakAvProfit: Float { Float(self.statisticValuesByIds["Worst100StreakAvProfit"] ?? "0") ?? 0 }
}


// MARK: - Computed Statistics

extension Statistics
{
        
    
    // MARK: - Tables
    
    /// Estimated staked amount (`Count * AvStake`).
    public var EstimatedStake: Float { Count * AvStake }
    
    /// Average hours played per day (`AvGameDuration * AvGamesPerDay / 3600`).
    public var AvHoursPerDay: Float { AvGameDuration * AvGamesPerDay / 3600.0 }
    
    /// Average tables played simultaneously considering 8 hour session per day (`floor(AvHoursPerDay / 8)`).
    public var AvMinSimultaneousTables: Float { floor(AvHoursPerDay / 8.0) }
    
    /// Average tables played simultaneously considering 4 hour session per day (`ceil(AvHoursPerDay / 4)`).
    public var AvMaxSimultaneousTables: Float { ceil(AvHoursPerDay / 4.0) }
    
    
    // MARK: - Times
    
    /// Days played so far (calendar days from `FirstGameDate` to `LastGameDate`).
    public var DaysPlayed: Int { Calendar.current.dateComponents([.day], from: FirstGameDate, to: LastGameDate).day ?? 0 }
    
    /// Years played so far (`Days / 365.2425`).
    public var YearsPlayed: Float { Float(DaysPlayed) / 365.2425 }
    
    /// Average days elapsed between plays (`DaysPlayed / ActiveDayCount`).
    public var DaysBetweenPlays: Float { Float(DaysPlayed) / ActiveDayCount }
    
    /// Losing days percentage of active days (`LosingDays / ActiveDayCount`).
    public var LosingDaysPercentage: Float { LosingDays / ActiveDayCount }
    
    /// Break even days percentage of active days (`BreakEvenDays / ActiveDayCount`).
    public var BreakEvenDaysPercentage: Float { BreakEvenDays / ActiveDayCount }
    
    /// Winning days percentage of active days (`WinningDays / ActiveDayCount`).
    public var WinningDaysPercentage: Float { WinningDays / ActiveDayCount }
    
    /// Losing days percentage of active days containing half of break even days (`LosingDaysPercentage + BreakEvenDaysPercentage / 2`).
    public var LosingDaysWithBreakEvenPercentage: Float { LosingDaysPercentage + BreakEvenDaysPercentage / 2 }
    
    /// Winning days percentage of active days containing half of break even days (`WinningDaysPercentage + BreakEvenDaysPercentage / 2`).
    public var WinningDaysWithBreakEvenPercentage: Float { WinningDaysPercentage + BreakEvenDaysPercentage / 2 }
}
