//
//  Formatter+Extensions.swift
//  Ranger
//
//  Created by Geri Borbás on 2020. 01. 15..
//  Copyright © 2020. Geri Borbás. All rights reserved.
//

import Foundation


extension Formatter
{
    
    
    static let withSeparator: NumberFormatter =
    {
        let formatter = NumberFormatter()
        formatter.groupingSeparator = " "
        formatter.numberStyle = .decimal
        return formatter
    }()
}
