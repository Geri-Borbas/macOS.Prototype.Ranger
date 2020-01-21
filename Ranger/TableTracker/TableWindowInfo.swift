//
//  TableWindowInfo.swift
//  Ranger
//
//  Created by Geri Borbás on 2019. 12. 29..
//  Copyright © 2019. Geri Borbás. All rights reserved.
//

import Foundation
import SwiftUI


struct TableWindowInfo
{
    
    
    // Properties.
    var name: String
    var number: Int
    var bounds: CGRect
    
    // UI.
    var UIKitBounds: CGRect
    {
        CGRect.init(
            x: self.bounds.minX,
            y: NSScreen.main!.frame.size.height - self.bounds.minY - self.bounds.size.height,
            width: self.bounds.size.width,
            height: self.bounds.size.height
        )
    }
        
    // Parse.
    var tableInfo: TableInfo?
    { TableInfo(name: name) }
}


extension TableWindowInfo: Equatable
{
    
    
    /// Equality is used for diffing in `TableTracker.tick()`.
    static func == (lhs: TableWindowInfo, rhs: TableWindowInfo) -> Bool
    {
        lhs.tableInfo?.tournamentNumber == rhs.tableInfo?.tournamentNumber
    }
}


extension TableWindowInfo: Comparable
{
    
    
    /// Equality is used in sorting at `TableTracker.lookupTableWindowInfos()`.
    static func < (lhs: TableWindowInfo, rhs: TableWindowInfo) -> Bool
    {
        lhs.number < rhs.number
    }
}


extension TableWindowInfo: Hashable
{


    func hash(into hasher: inout Hasher)
    {
        hasher.combine(tableInfo?.tournamentNumber)
    }
}
