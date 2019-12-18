//
//  KeyDecodingStrategy+SharkScope.swift
//  Ranger
//
//  Created by Geri Borbás on 2019. 12. 17..
//  Copyright © 2019. Geri Borbás. All rights reserved.
//

import Foundation


struct BadgerFishCodingKey: CodingKey
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

    /// See more at http://www.sklar.com/badgerfish/
    static var convertFromBadgerFish: JSONDecoder.KeyDecodingStrategy
    {
        return .custom
        {
            codingKeys in

            // Get last key.
            let key = codingKeys.last!
            
            // Special case for `class` (as it is reserved).
            if key.stringValue == "@class"
            { return BadgerFishCodingKey(stringValue: "_class")! }
            
            // Lookup first letter.
            let firstLetter = key.stringValue.prefix(1).lowercased()
            
            if firstLetter == "@"
            { return BadgerFishCodingKey(stringValue: String(key.stringValue.dropFirst()))! }
            
            if firstLetter == "$"
            { return BadgerFishCodingKey(stringValue: "value")! }
                        
            return key
        }
    }
}
