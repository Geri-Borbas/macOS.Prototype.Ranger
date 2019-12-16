//
//  PlayerSummary.swift
//  Ranger
//
//  Created by Geri Borbás on 2019. 12. 16..
//  Copyright © 2019. Geri Borbás. All rights reserved.
//

import Foundation


struct PlayerSummary: Decodable
{
    
    
    let Response: Response
    
    
    struct Response: Decodable
    {
        
        
        let metadataHash: String
        let timestamp: Double
        let success: Bool
        
        // let PlayerResponse: Any
        // let UserInfo: UserInfo
        
        
        struct UserInfo: Decodable
        {
            

            let hasFacebook: Bool
            let hasTwitter: Bool
            let loggedIn: Bool
            let optedInForNewsletter: Bool
            // let Username: String
            // let Country: String
            // let Regions: [Any]
            // let Currency: String
            // let RemainingSearches: Int
            // let ExpirationDate: Double
            // let RequestLanguages: String
            // let Subscriptions: [Any]
            // let AuthorizedNetworks: [Any]
        }
    }
}

