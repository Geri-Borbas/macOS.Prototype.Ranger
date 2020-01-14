//
//  PlayerSummary.swift
//  Ranger
//
//  Created by Geri Borbás on 2019. 12. 16..
//  Copyright © 2019. Geri Borbás. All rights reserved.
//

import Foundation


struct CompletedTournaments: RootResponse, Equatable
{ let Response: CompletedTournamentsResponse }


struct CompletedTournamentsResponse: Response, Equatable
{


    let metadataHash: String
    let timestamp: StringFor<Date>
    let success: StringFor<Bool>

    let PlayerResponse: PlayerResponse
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
                
                /*
                var ActiveTournaments: ActiveTournaments?
                
                
                struct ActiveTournaments: Decodable, CustomStringConvertible, Equatable
                {
                 
                    
                    var Tournament: [Tournament]
                    
                    
                    struct Tournament: Decodable, CustomStringConvertible, Equatable
                    {
                        

                        // let guarantee: StringFor<Float>
                        // let rake: StringFor<Float>
                        // let currency: String
                        // let gameClass: String
                        let id: StringFor<Int>
                        // let lateRegEndDate: StringFor<Date>
                        let name: String
                        let state: String
                        let totalEntrants: StringFor<Int>
                        // let overlay: String
                        // let lastUpdateTime: StringFor<Date>
                        // let game: String
                        let stake: StringFor<Float>
                        let currentEntrants: StringFor<Int>
                        // let scheduledStartDate: StringFor<Date>
                        // let flags: String
                        // let structure: String
                        // let network: String
                        // let playersPerTable: StringFor<Int>
                        
                        
                        var description: String
                        { return String(format: "%@ - Entrants %d/%d", name, currentEntrants.value, totalEntrants.value) }
                    }
                    
                    init(from decoder: Decoder) throws
                    {
                        // Default(ish) implementation.
                        let container = try decoder.container(keyedBy: DynamicCodingKey.self)
                        
                        // Try to decode one tournament first.
                        var Tournament: [Tournament] = []
                        if let oneTournament = try? container.decode(ActiveTournaments.Tournament.self, forKey: DynamicCodingKey(stringValue: "Tournament")!)
                        { Tournament = [oneTournament] }
                        // Decode tournament list after.
                        else
                        { Tournament = try container.decode([ActiveTournaments.Tournament].self, forKey: DynamicCodingKey(stringValue: "Tournament")!) }
                        
                        // Assign.
                        self.Tournament = Tournament
                    }
                    
                    
                    var description: String
                    {
                        return "[\n" + self.Tournament.reduce("")
                        {
                            description, eachTournament in
                            description + "\t" + eachTournament.description + "\n"
                        } + "]"
                    }
                    
                    
                }
                */
 
            }
        }
    }
}
