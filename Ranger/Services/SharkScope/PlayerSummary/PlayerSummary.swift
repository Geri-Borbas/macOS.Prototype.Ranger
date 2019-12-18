//
//  PlayerSummary.swift
//  Ranger
//
//  Created by Geri Borbás on 2019. 12. 16..
//  Copyright © 2019. Geri Borbás. All rights reserved.
//

import Foundation


struct PlayerSummary: RootResponse
{ let Response: PlayerSummaryResponse }


struct PlayerSummaryResponse: Response
{


    let metadataHash: String
    let timestamp: StringFor<Date>
    let success: StringFor<Bool>

    let PlayerResponse: PlayerSummaryResponse.PlayerResponse
    let UserInfo: UserInfo
    
    
    struct PlayerResponse: Decodable
    {


        let PlayerView: PlayerView


        struct PlayerView: Decodable
        {


            let Filter: String
            let Player: Player
            

            struct Player: Decodable
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
