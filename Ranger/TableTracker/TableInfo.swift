//
//  TableInfo.swift
//  Ranger
//
//  Created by Geri Borbás on 2020. 01. 11..
//  Copyright © 2020. Geri Borbás. All rights reserved.
//

import Foundation


struct TableInfo: Equatable
{
   
   
    let tournamentNumber: String
    let tableNumber: Int
    let smallBlind: Int
    let bigBlind: Int
    let ante: Int

    var tableName: String { "\(tournamentNumber) \(tableNumber)" }
}


extension TableInfo
{
    
    
    init?(name: String)
    {
        var tournamentNumber: String
        var tableNumber: Int
        var smallBlind: Int
        var bigBlind: Int
        var ante: Int = 0
        
        // Only with 4, 5 components.
        let components = name.components(separatedBy: " - ")
        guard components.count == 4 || components.count == 5
        else { return nil }
        
        print("components: \(components)")
        
        let blindsComponentIndex = components.count - 3
        let tournamentTableNameComponentIndex = components.count - 2
                
        print("blindsComponentIndex: \(blindsComponentIndex)")
        print("tournamentTableNameComponentIndex: \(tournamentTableNameComponentIndex)")
        
        // Parse blinds.
        let blindLevelComponents = components[blindsComponentIndex].components(separatedBy: " ")
        let blindsComponents = blindLevelComponents[0].components(separatedBy: "/")
        
        print("blindLevelComponents: \(blindLevelComponents)")
        print("blindsComponents: \(blindsComponents)")
        
        // Number formatter for parsing "," thousand separator.
        let formatter = NumberFormatter()
            formatter.numberStyle = .decimal
            formatter.maximumFractionDigits = 0
            formatter.decimalSeparator = "."
            formatter.groupingSize = 3
            formatter.groupingSeparator = ","
        
        // Parse blinds.
        smallBlind = formatter.number(from: blindsComponents[0])?.intValue ?? -1
        bigBlind = formatter.number(from: blindsComponents[1])?.intValue ?? -1
        
        print("smallBlind: \(smallBlind)")
        print("bigBlind: \(bigBlind)")
        
        // Only numbers.
        guard smallBlind != -1, bigBlind != -1
        else { return nil }
        
        // Parse ante if any.
        if blindLevelComponents.count > 1
        {
            let anteString = blindLevelComponents[1].replacingOccurrences(of: "ante ", with: "")
            ante = formatter.number(from: anteString)?.intValue ?? -1
        }
        
        print("ante: \(ante)")
        
        // Parse tourney.
        let tournamentTableNameComponents = components[tournamentTableNameComponentIndex].components(separatedBy: " ")
        
        // Only with 4 table name components.
        guard tournamentTableNameComponents.count == 4
        else { return nil }
        
        tournamentNumber = tournamentTableNameComponents[1]
        tableNumber = Int(tournamentTableNameComponents[3]) ?? -1
        
        print("tournamentNumber: \(tournamentNumber)")
        print("tableNumber: \(tableNumber)")
        
        // Only numbers.
        guard NumberFormatter().number(from: tournamentNumber) != nil, tableNumber != -1
        else { return nil }
        
        // Set.
        self.tournamentNumber = tournamentNumber
        self.tableNumber = tableNumber
        self.smallBlind = smallBlind
        self.bigBlind = bigBlind
        self.ante = ante
    }
}
