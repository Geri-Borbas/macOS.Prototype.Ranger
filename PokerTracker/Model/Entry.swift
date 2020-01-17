//
//  RowInitable.swift
//  Ranger
//
//  Created by Geri Borbás on 2019. 12. 09..
//  Copyright © 2019. Geri Borbás. All rights reserved.
//

import Foundation
import PostgresClientKit
   
    
public protocol Entry: CustomStringConvertible
{
        
    
    init(row: Row) throws
}
