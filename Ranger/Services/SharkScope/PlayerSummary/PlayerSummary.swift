//
//  PlayerSummary.swift
//  Ranger
//
//  Created by Geri Borbás on 2019. 12. 16..
//  Copyright © 2019. Geri Borbás. All rights reserved.
//

import Foundation


struct PlayerSummary: RootResponse, Equatable
{ let Response: PlayerSummaryResponse }


struct PlayerSummaryResponse: Response, Equatable
{


    let metadataHash: String
    let timestamp: StringFor<Date>
    let success: StringFor<Bool>

    let PlayerResponse: PlayerSummaryResponse.PlayerResponse
    let UserInfo: UserInfo
    
    
    struct PlayerResponse: Decodable, Equatable
    {


        let PlayerView: PlayerView


        struct PlayerView: Decodable, Equatable
        {


            let Filter: String
            let Player: Player
            

            struct Player: Decodable, Equatable
            {


                let country: String
                let countryName: String
                let lastActivity: StringFor<Date>
                let name: String
                let network: String
                let Statistics: Statistics
                // RecentTournaments
            }
        }
    }
}
