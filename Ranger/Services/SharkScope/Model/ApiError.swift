//
//  PlayerSummary.swift
//  Ranger
//
//  Created by Geri Borbás on 2019. 12. 16..
//  Copyright © 2019. Geri Borbás. All rights reserved.
//

import Foundation


struct ApiError: RootResponse
{ let Response: ErrorResponse }


struct ErrorResponse: Response
{


    let metadataHash: String
    let timestamp: StringFor<Date>
    let success: StringFor<Bool>

    let ErrorResponse: ErrorResponse
    let UserInfo: UserInfo
    
    
    struct ErrorResponse: Decodable
    {
        
        
        let id: StringFor<Int>
        let value: String
    }
}
