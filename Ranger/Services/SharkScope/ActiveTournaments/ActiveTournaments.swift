//
//  PlayerSummary.swift
//  Ranger
//
//  Created by Geri Borbás on 2019. 12. 16..
//  Copyright © 2019. Geri Borbás. All rights reserved.
//

import Foundation


struct ActiveTournaments: RootResponse
{ let Response: ActiveTournamentsResponse }


struct ActiveTournamentsResponse: Response
{


    let metadataHash: String
    let timestamp: StringFor<Date>
    let success: StringFor<Bool>

    let PlayerResponse: PlayerResponse
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
                let ActiveTournaments: ActiveTournaments
                
                
                struct ActiveTournaments: Decodable
                {
                    
                    
                    let Tournament: [Tournament]
                    
                    
                    struct Tournament: Decodable
                    {
                        

                        // let guarantee: StringFor<Float>
                        let rake: StringFor<Float>
                        let currency: String
                        let gameClass: String
                        let id: StringFor<Int>
                        // let lateRegEndDate: StringFor<Date>
                        let name: String
                        let state: String
                        let totalEntrants: StringFor<Int>
                        let overlay: String
                        let lastUpdateTime: StringFor<Date>
                        let game: String
                        let stake: StringFor<Float>
                        let currentEntrants: StringFor<Int>
                        // let scheduledStartDate: StringFor<Date>
                        let flags: String
                        let structure: String
                        let network: String
                        let playersPerTable: StringFor<Int>
                    }
                }
            }
        }
    }
}
