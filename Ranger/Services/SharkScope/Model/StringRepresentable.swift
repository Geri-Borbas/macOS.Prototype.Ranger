//
//  StringDecodable.swift
//  Ranger
//
//  Created by Geri Borbás on 2019. 12. 18..
//  Copyright © 2019. Geri Borbás. All rights reserved.
//

import Foundation


public protocol StringRepresentable: CustomStringConvertible
{
    
    
    init?(_ string: String)
}


extension Bool: StringRepresentable {}
extension Int: StringRepresentable {}
extension Float: StringRepresentable {}
extension Double: StringRepresentable {}
extension Date: StringRepresentable
{
    
    
    public init?(_ string: String)
    {
        if let double = Double(string)
        { self = Date(timeIntervalSince1970: double) }
        else
        { return nil }
    }
}
