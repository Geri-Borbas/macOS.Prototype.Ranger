//
//  SharkScopeResponse.swift
//  Ranger
//
//  Created by Geri Borbás on 2019. 12. 12..
//  Copyright © 2019. Geri Borbás. All rights reserved.
//

import Foundation


struct Response: Decodable
{
    
    
    let Response: Response
    
    
    struct Response: Decodable
    {
        
        
        let metadataHash: String

        
        private enum CodingKeys: String, CodingKey
        {
            case metadataHash = "@metadataHash"
        }
    }
}
