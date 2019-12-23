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
        let liveTourneyPlayer: LiveTourneyPlayer
        var player: Player?
        var statistics: BasicPlayerStatistics?
        
        // Service.
        private lazy var service: Ranger.PokerTracker = Ranger.PokerTracker()
        
        
        init(with liveTourneyPlayer: LiveTourneyPlayer)
        {
            self.liveTourneyPlayer = liveTourneyPlayer
            
            // Query rest of the data.
            self.player = try? service.fetch(PlayerQuery(playerIDs: [liveTourneyPlayer.id_player])).first
            self.statistics = try? service.fetch(BasicPlayerStatisticsQuery(playerIDs: [liveTourneyPlayer.id_player])).first
        }
        
        public mutating func updateStatistics()
        {
            self.statistics = try? service.fetch(BasicPlayerStatisticsQuery(playerIDs: [liveTourneyPlayer.id_player])).first
        }
    }
    
    
    struct SharkScope: Equatable
    {
        
        
        var summary: PlayerSummary?
        var activeTournaments: ActiveTournaments?
    }
    
    
    init(with liveTourneyPlayer: LiveTourneyPlayer)
    {
        self.pokerTracker = PokerTracker(with: liveTourneyPlayer)
        self.sharkScope = SharkScope()
    }
    
    /// PokerTracked `id_player` equality makes unique view models.
    static func == (lhs: PlayerViewModel, rhs: PlayerViewModel) -> Bool
    { lhs.pokerTracker.liveTourneyPlayer.id_player == rhs.pokerTracker.liveTourneyPlayer.id_player }
}


extension PlayerViewModel
{
    
    
}
