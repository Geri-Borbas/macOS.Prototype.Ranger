
//
//  PlazerResponse.swift
//  Ranger
//
//  Created by Geri Borbás on 2019. 12. 18..
//  Copyright © 2019. Geri Borbás. All rights reserved.
//

import Foundation


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
