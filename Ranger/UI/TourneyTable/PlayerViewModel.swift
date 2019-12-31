//
//  PlayerViewModel.swift
//  Ranger
//
//  Created by Geri Borbás on 2019. 12. 23..
//  Copyright © 2019. Geri Borbás. All rights reserved.
//

import Foundation


struct PlayerViewModel: Equatable
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
            
            // Query latest statistics.
            self.statistics = try? service.fetch(BasicPlayerStatisticsQuery(playerIDs: [latestHandPlayer.id_player])).first
        }
        
        public mutating func updateStatistics()
        {
            self.statistics = try? service.fetch(BasicPlayerStatisticsQuery(playerIDs: [latestHandPlayer.id_player])).first
        }
    }
    
    
    struct SharkScope: Equatable
    {
        
        
        var summary: PlayerSummary?
        var activeTournaments: ActiveTournaments?
    }
    
    
    init(with latestHandPlayer: LatestHandPlayer)
    {
        self.pokerTracker = PokerTracker(with: latestHandPlayer)
        self.sharkScope = SharkScope()
    }
    
    /// PokerTracker `id_player` makes unique view models.
    static func == (lhs: PlayerViewModel, rhs: PlayerViewModel) -> Bool
    { lhs.pokerTracker.latestHandPlayer.id_player == rhs.pokerTracker.latestHandPlayer.id_player }
}


extension PlayerViewModel
{
    
    
}
