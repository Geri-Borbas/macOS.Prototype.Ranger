//
//  VersionCheckResponse.swift
//  Ranger
//
//  Created by Geri Borbás on 2019. 12. 10..
//  Copyright © 2019. Geri Borbás. All rights reserved.
//

import Foundation


struct VersionCheckResponse: Codable
{
    // Attributes.
    let metadataHash: String
    let timestamp: Double // POSIX time
    let success: String
    
    // Elements.
    let ErrorResponse: ErrorResponse
    let UserInfo: UserInfo
    
    struct ErrorResponse: Codable
    {
        // Elements.
        let Error: Error
        
        struct Error: Codable
        {
            // Attributes.
            let id: Int
            
            // Value.
            let value: String
        }
    }
    
    struct UserInfo: Codable
    {
        // Attributes.
        let hasFacebook: String
        let hasTwitter: String
        let loggedIn: String
        
        // Elements.
        let Country: String
        // <Regions code="All" name="International"/>
        // <Regions code="NonUS" name="Non US"/>
        let Currency: String
        let RemainingSearches: Int
        let RequestLanguages: String
        // <Subscriptions freeSearchesRemaining="0" totalSearchesRemaining="0"/>
        // <AuthorizedNetworks/>
    }
}
