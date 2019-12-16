//
//  KeyDecodingStrategy+SharkScope.swift
//  Ranger
//
//  Created by Geri Borbás on 2019. 12. 17..
//  Copyright © 2019. Geri Borbás. All rights reserved.
//

import Foundation


struct SharkScopeCodingKey: CodingKey
{
  
    
    var stringValue: String

    init?(stringValue: String)
    { self.stringValue = stringValue }

    
    var intValue: Int?
    { return nil }

    init?(intValue: Int)
    { return nil }
}


extension JSONDecoder.KeyDecodingStrategy
{


    static var convertFromSharkScopeJSON: JSONDecoder.KeyDecodingStrategy
    {
        return .custom
        {
            codingKeys in

            // Get last key.
            let key = codingKeys.last!
            
            // Lookup first letter.
            let firstLetter = key.stringValue.prefix(1).lowercased()
            
            if firstLetter == "@"
            { return SharkScopeCodingKey(stringValue: String(key.stringValue.dropFirst()))! }
            
            if firstLetter == "$"
            { return SharkScopeCodingKey(stringValue: "value")! }
                        
            return key
        }
    }
}
