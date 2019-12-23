//
//  PlayerSummary.swift
//  Ranger
//
//  Created by Geri Borbás on 2019. 12. 16..
//  Copyright © 2019. Geri Borbás. All rights reserved.
//

import Foundation


struct ApiError: RootResponse
{
    
    
    let Response: ErrorResponse
    
    func NSError(domain: String) -> NSError
    {
        return Foundation.NSError(
            domain: domain,
            code: Int(Response.ErrorResponse.Error.id) ?? 0,
            userInfo:[ NSLocalizedDescriptionKey: Response.ErrorResponse.Error.value ]
        )
    }
}


struct ErrorResponse: Response
{


    let metadataHash: String
    let timestamp: StringFor<Date>
    let success: StringFor<Bool>

    let ErrorResponse: ErrorResponse
    let UserInfo: UserInfo
    
    
    struct ErrorResponse: Decodable
    {
        
        let Error: Error
        
        
        struct Error: Decodable
        {
            
            
            let id: String
            let value: String
        }
    }
}
