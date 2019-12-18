//
//  Statistics.swift
//  Ranger
//
//  Created by Geri Borbás on 2019. 12. 18..
//  Copyright © 2019. Geri Borbás. All rights reserved.
//

import Foundation


struct Statistics: Decodable
{

    
    typealias StatisticType = Statistic
    

    let displayCurrency: String
    let Statistic: [Statistic]
    // StatisticalDataSet
    // Timeline
    
    /// `Statistic.value` index keyed by `Statistic.id`.
    private let statisticValuesByIds: [String:String]

    
    struct Statistic: Decodable
    {


        let id: String
        let value: String
    }
    
    
    init(from decoder: Decoder) throws
    {
        // Default implementation.
        let container = try decoder.container(keyedBy: DynamicCodingKey.self)
        self.displayCurrency = try container.decode(String.self, forKey: DynamicCodingKey(stringValue: "displayCurrency")!)
        self.Statistic = try container.decode([StatisticType].self, forKey: DynamicCodingKey(stringValue: "Statistic")!)
        
        // Create index for Statistics Accessors below.
        statisticValuesByIds = Dictionary(uniqueKeysWithValues: self.Statistic.map{ ($0.id, $0.value) })
    }
}


// MARK: - Accessors

extension Statistics
{
        
    /// The Ability rating is a rating that goes up to 100 and shows a player’s ability
    /// based on an assessment of all the other statistics we have compiled for that player.
    var Ability: Float { Float(self.statisticValuesByIds["Ability"] ?? "0") ?? 0 }
    
    /// The total points from the player’s unlocked SharkScope Achievements. Each regular
    /// card achievement unlocked is worth 1 point, face cards are worth 3 points and aces
    /// 5 achievement points.
    var AchievementPoints: Float { Float(self.statisticValuesByIds["AchievementPoints"] ?? "0") ?? 0 }
    
    /// The total number of days the player has played on.
    var ActiveDayCount: Float { Float(self.statisticValuesByIds["ActiveDayCount"] ?? "0") ?? 0 }
    
    /// The average number of entrants in the played tournaments.
    var AvEntrants: Float { Float(self.statisticValuesByIds["AvEntrants"] ?? "0") ?? 0 }
    
    /// The average completion time of each tournament played (in seconds).
    var AvGameDuration: Float { Float(self.statisticValuesByIds["AvGameDuration"] ?? "0") ?? 0 }
    
    /// The average number of games per day on active days.
    var AvGamesPerDay: Float { Float(self.statisticValuesByIds["AvGamesPerDay"] ?? "0") ?? 0 }
    
    /// The average profit including rake.
    var AvProfit: Float { Float(self.statisticValuesByIds["AvProfit"] ?? "0") ?? 0 }
    
    /// Average ROI is the average Return On Investment. It is calculated as the average of each
    /// ((payout-(stake+rake))*100)/(stake+rake). So it will be -100% for a player that loses
    /// every game, and about 309% for a player that wins every 9 handed game. It could of course
    /// be a lot higher if, for example the player won every 180 player game they played in. It
    /// is a measure of ability independent of stake. Another way to look at it is as an ITM%
    /// (In The Money percentage) weighted to the actual payouts relative to the stake. Please
    /// note that this figure is the average of the ROIs which is different from Total ROI which
    /// is the ROI of the averages.
    var AvROI: Float { Float(self.statisticValuesByIds["AvROI"] ?? "0") ?? 0 }
    
    /// The average stake of the tournaments played.
    var AvStake: Float { Float(self.statisticValuesByIds["AvStake"] ?? "0") ?? 0 }
    
    /// The bankroll needed for the worst losing period.
    var Bankroll: Float { Float(self.statisticValuesByIds["Bankroll"] ?? "0") ?? 0 }
    
    /// The average profit for the player’s best 100-game winning streak.
    var Best100StreakAvProfit: Float { Float(self.statisticValuesByIds["Best100StreakAvProfit"] ?? "0") ?? 0 }
    
    /// The average profit for the player’s best 500-game winning streak.
    var Best500StreakAvProfit: Float { Float(self.statisticValuesByIds["Best500StreakAvProfit"] ?? "0") ?? 0 }
    
    /// The total number of days the player played but did not make a profit or a loss.
    var BreakEvenDays: Float { Float(self.statisticValuesByIds["BreakEvenDays"] ?? "0") ?? 0 }
    
    /// The sum of all the player’s cashes.
    var Cashes: Float { Float(self.statisticValuesByIds["Cashes"] ?? "0") ?? 0 }
    
    /// The total number of tournaments the player has played.
    var Count: Float { Float(self.statisticValuesByIds["Count"] ?? "0") ?? 0 }
    
    /// The frequency the player has finished in the bottom 10% of tournaments.
    var FinshesEarly: Float { Float(self.statisticValuesByIds["FinshesEarly"] ?? "0") ?? 0 }
    
    /// The frequency the player has finished in the bottom 10% to 30% of tournaments.
    var FinshesEarlyMiddle: Float { Float(self.statisticValuesByIds["FinshesEarlyMiddle"] ?? "0") ?? 0 }
    
    /// The frequency the player has finished in the top 10% of tournaments.
    var FinshesLate: Float { Float(self.statisticValuesByIds["FinshesLate"] ?? "0") ?? 0 }
    
    /// The frequency the player has finished in the middle 40% of tournaments.
    var FinshesMiddle: Float { Float(self.statisticValuesByIds["FinshesMiddle"] ?? "0") ?? 0 }
    
    /// The frequency the player has finished in the top 10% to 30% of tournaments.
    var FinshesMiddleLate: Float { Float(self.statisticValuesByIds["FinshesMiddleLate"] ?? "0") ?? 0 }
    
    /// The date/time of the first game played.
    var FirstGameDate: Date { Date(timeIntervalSince1970: Double(self.statisticValuesByIds["FirstGameDate"] ?? "0") ?? 0 ) }
    
    /// The frequency the player cashes and is In The Money.
    var ITM: Float { Float(self.statisticValuesByIds["ITM"] ?? "0") ?? 0 }
    
    /// The date/time of the last game played.
    var LastGameDate: Date { Date(timeIntervalSince1970: Double(self.statisticValuesByIds["LastGameDate"] ?? "0") ?? 0 ) }
    
    /// The total number of days the player had a loss.
    var LosingDays: Float { Float(self.statisticValuesByIds["LosingDays"] ?? "0") ?? 0 }
    
    /// The player’s highest number of consecutive tournaments where they finished In The Money.
    var MaxCashingStreak: Float { Float(self.statisticValuesByIds["MaxCashingStreak"] ?? "0") ?? 0 }
    
    /// The player’s highest number of consecutive tournaments losses.
    var MaxLosingStreak: Float { Float(self.statisticValuesByIds["MaxLosingStreak"] ?? "0") ?? 0 }
    
    /// The player’s highest number of consecutive 1st place tournaments finishes.
    var MaxWinningStreak: Float { Float(self.statisticValuesByIds["MaxWinningStreak"] ?? "0") ?? 0 }
    
    /// The most Games the player has played in a day.
    var MostGamesInDay: Float { Float(self.statisticValuesByIds["MostGamesInDay"] ?? "0") ?? 0 }
    
    /// The number of PokerStars Tournament Leaderboard Points earned
    /// (http://www.pokerstars.com/poker/tournaments/leader-board/explained/).
    var PTLBPoints: Float { Float(self.statisticValuesByIds["PTLBPoints"] ?? "0") ?? 0 }
    
    /// The average percentage of field beaten.
    var PercentFieldBeaten: Float { Float(self.statisticValuesByIds["PercentFieldBeaten"] ?? "0") ?? 0 }
    
    /// The total profit including rake.
    var Profit: Float { Float(self.statisticValuesByIds["Profit"] ?? "0") ?? 0 }
    
    /// The sum of all rake paid by the player.
    var Rake: Float { Float(self.statisticValuesByIds["Rake"] ?? "0") ?? 0 }
    
    /// The sum of all money staked by the player.
    var Stake: Float { Float(self.statisticValuesByIds["Stake"] ?? "0") ?? 0 }
    
    /// The total ROI (Return on Investment).
    var TotalROI: Float { Float(self.statisticValuesByIds["TotalROI"] ?? "0") ?? 0 }
    
    /// The total numbers of 1st place tournament finishes.
    var TournamentWins: Float { Float(self.statisticValuesByIds["TournamentWins"] ?? "0") ?? 0 }
    
    /// The frequency the player plays Turbo or Super Turbo tournaments.
    var TurboRatio: Float { Float(self.statisticValuesByIds["TurboRatio"] ?? "0") ?? 0 }
    
    /// A User-provided note on the player.
    var UserNote: String { self.statisticValuesByIds["UserNote"] ?? "0" }
    
    /// The total number of days the player had a profit.
    var WinningDays: Float { Float(self.statisticValuesByIds["WinningDays"] ?? "0") ?? 0 }
    
    /// Average Profit for the player’s worst 100-game losing streak.
    var Worst100StreakAvProfit: Float { Float(self.statisticValuesByIds["Worst100StreakAvProfit"] ?? "0") ?? 0 }
}


// MARK: - Computed Statistics

extension Statistics
{
        
    /// Estimated staked amount (`Count * AvStake`).
    var EstimatedStake: Float { Count * AvStake }
    
    /// Average hours played per dat (`AvGameDuration * AvGamesPerDay / 3600`).
    var AvHoursPerDay: Float { AvGameDuration * AvGamesPerDay / 3600.0 }
}