//
//  Query.swift
//  Ranger
//
//  Created by Geri Borbás on 2019. 12. 14..
//  Copyright © 2019. Geri Borbás. All rights reserved.
//

import Foundation


protocol Query
{
    
    
    associatedtype EntryType where EntryType: Entry
    
    
    var string: String { get }
}
