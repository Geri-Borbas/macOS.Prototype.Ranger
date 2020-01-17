//
//  StringRepresenting.swift
//  Ranger
//
//  Created by Geri Borbás on 2019. 12. 18..
//  Copyright © 2019. Geri Borbás. All rights reserved.
//

import Foundation


public typealias StringFor<Type> = StringRepresenting<Type> where Type: StringRepresentable


public struct StringRepresenting<RepresentedType: StringRepresentable>: Decodable, Equatable
{
    
    
    var value: RepresentedType
    
    
    public init(from decoder: Decoder) throws
    {
        // Decode string value.
        let container = try decoder.singleValueContainer()
        let string = try container.decode(String.self)
        
        // Corresponding string initializer (see `StringRepresentable`).
        guard let value = RepresentedType(string) else
        {
            throw DecodingError.dataCorruptedError(
                in: container,
                debugDescription: "Decoding \(RepresentedType.self) from \(string) failed."
            )
        }
        
        // Set.
        self.value = value
    }
    
    public static func == (lhs: StringRepresenting<RepresentedType>, rhs: StringRepresenting<RepresentedType>) -> Bool
    { lhs.value == rhs.value }
}



