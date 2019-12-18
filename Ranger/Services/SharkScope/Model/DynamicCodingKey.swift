//
//  DynamicCodingKey.swift
//  Ranger
//
//  Created by Geri Borbás on 2019. 12. 18..
//  Copyright © 2019. Geri Borbás. All rights reserved.
//

import Foundation


struct DynamicCodingKey: CodingKey
{
    
    
    var intValue: Int?
    
    init?(intValue: Int)
    { nil }
    
    var stringValue: String
    
    init?(stringValue: String)
    { self.stringValue = stringValue }
}
