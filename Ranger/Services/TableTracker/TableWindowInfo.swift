//
//  TableWindowInfo.swift
//  Ranger
//
//  Created by Geri Borbás on 2019. 12. 29..
//  Copyright © 2019. Geri Borbás. All rights reserved.
//

import Foundation
import SwiftUI


struct TableWindowInfo: Equatable
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
        
    struct TableInfo
    {
        
        
        let tournamentID: String
        let tableNumber: Int
        let smallBlind: Int
        let bigBlind: Int
        let ante: Int
        var tableName: String { "\(tournamentID) \(tableNumber)" }
    }
    
    private var tableInfo: TableInfo?
    {
        var tournamentID: String
        var tableNumber: Int
        var smallBlind: Int
        var bigBlind: Int
        var ante: Int = 0
        
        let name = "$3.50 NL Hold'em [18 Players, Turbo] - 400/800 ante 50 - Tournament 2770350462 Table 2 - Logged in as Borbas.Geri"
        let components = name.components(separatedBy: " - ")
        
        // Only with 4 components.
        guard components.count == 4
        else { return nil }
        
        // Parse blinds.
        let blindLevelComponents = components[1].components(separatedBy: " ")
        let blindsComponents = blindLevelComponents[0].components(separatedBy: "/")
        
        smallBlind = Int(blindsComponents[0]) ?? -1
        bigBlind = Int(blindsComponents[1]) ?? -1
        
        // Only numbers.
        guard smallBlind != -1, bigBlind != -1
        else { return nil }
        
        // Parse ante if any.
        if blindLevelComponents.count == 3
        { ante = Int(blindLevelComponents[2]) ?? 0 }
        
        // Parse tourney.
        let tournamentTableNameComponents = components[2].components(separatedBy: " ")
        
        // Only with 4 table name components.
        guard tournamentTableNameComponents.count == 4
        else { return nil }
        
        tournamentID = tournamentTableNameComponents[1]
        tableNumber = Int(tournamentTableNameComponents[3]) ?? -1
        
        // Only numbers.
        guard NumberFormatter().number(from: tournamentID) != nil, tableNumber != -1
        else { return nil }
        
        // Return.
        return TableInfo(
            tournamentID: tournamentID,
            tableNumber: tableNumber,
            smallBlind: smallBlind,
            bigBlind: bigBlind,
            ante: ante
        )
    }
}
