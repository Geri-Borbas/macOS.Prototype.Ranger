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
        
        
        let tournamentNumber: String
        let tableNumber: Int
        let smallBlind: Int
        let bigBlind: Int
        let ante: Int
        var tableName: String { "\(tournamentNumber) \(tableNumber)" }
        var orbitCost: Float { Float(smallBlind) + Float(bigBlind) + 9.0 * Float(ante) }
    }
    
    var tableInfo: TableInfo?
    {
        var tournamentNumber: String
        var tableNumber: Int
        var smallBlind: Int
        var bigBlind: Int
        var ante: Int = 0
        
        // Only with 4 components.
        let components = name.components(separatedBy: " - ")
        guard components.count == 4 || components.count == 5
        else { return nil }
        
        let blindsComponentIndex = components.count - 3
        let tournamentTableNameComponentIndex = components.count - 2
                
        // Parse blinds.
        let blindLevelComponents = components[blindsComponentIndex].components(separatedBy: " ")
        let blindsComponents = blindLevelComponents[0].components(separatedBy: "/")
        
        smallBlind = Int(blindsComponents[0]) ?? -1
        bigBlind = Int(blindsComponents[1]) ?? -1
        
        // Only numbers.
        guard smallBlind != -1, bigBlind != -1
        else { return nil }
        
        // Parse ante if any.
        if blindLevelComponents.count > 1
        { ante = Int(blindLevelComponents[1].replacingOccurrences(of: "ante ", with: "")) ?? 0 }
        
        // Parse tourney.
        let tournamentTableNameComponents = components[tournamentTableNameComponentIndex].components(separatedBy: " ")
        
        // Only with 4 table name components.
        guard tournamentTableNameComponents.count == 4
        else { return nil }
        
        tournamentNumber = tournamentTableNameComponents[1]
        tableNumber = Int(tournamentTableNameComponents[3]) ?? -1
        
        // Only numbers.
        guard NumberFormatter().number(from: tournamentNumber) != nil, tableNumber != -1
        else { return nil }
        
        // Return.
        return TableInfo(
            tournamentNumber: tournamentNumber,
            tableNumber: tableNumber,
            smallBlind: smallBlind,
            bigBlind: bigBlind,
            ante: ante
        )
    }
}


extension TableWindowInfo
{
    
    
    static var simulatedTableWindowInfo: TableWindowInfo
    {
        TableWindowInfo(
            name: "$3.50 NL Hold'em [18 Players, Turbo] - \(App.configuration.simulation.smallBlind)/\(App.configuration.simulation.bigBlind) ante \(App.configuration.simulation.ante) - Tournament \(App.configuration.simulation.tournamentNumber) Table 2 - Logged in as Borbas.Geri",
            number: 0,
            bounds: CGRect()
        )
    }
}
