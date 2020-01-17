//
//  Numeric+Extensions.swift
//  Ranger
//
//  Created by Geri Borbás on 2020. 01. 15..
//  Copyright © 2020. Geri Borbás. All rights reserved.
//

import Foundation


extension Numeric
{
    
    
    var formattedWithSeparator: String
    { return Formatter.withSeparator.string(for: self) ?? "" }
}
