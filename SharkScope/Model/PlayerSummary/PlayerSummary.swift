//
//  PlayerSummary.swift
//  Ranger
//
//  Created by Geri Borbás on 2019. 12. 16..
//  Copyright © 2019. Geri Borbás. All rights reserved.
//

import Foundation


public struct PlayerSummary: RootResponse, Equatable
{ public let Response: PlayerSummaryResponse }


public struct PlayerSummaryResponse: Response, Equatable
{


    public let metadataHash: String
    public let timestamp: StringFor<Date>
    public let success: StringFor<Bool>

    public let PlayerResponse: PlayerSummaryResponse.PlayerResponse
    public let UserInfo: UserInfo
    
    
    public struct PlayerResponse: Decodable, Equatable
    {


        public let PlayerView: PlayerView


        public struct PlayerView: Decodable, Equatable
        {


            // let Filter: String
            public let Player: Player
            

            public struct Player: Decodable, Equatable
            {


                public let country: String
                public let countryName: String
                public let lastActivity: StringFor<Date>
                public let name: String
                public let network: String
                public let Statistics: Statistics
                // RecentTournaments
            }
        }
    }
}
