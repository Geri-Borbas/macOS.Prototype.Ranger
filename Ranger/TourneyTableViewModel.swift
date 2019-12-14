//
//  TourneyTableViewModel.swift
//  Ranger
//
//  Created by Geri Borbás on 2019. 12. 14..
//  Copyright © 2019. Geri Borbás. All rights reserved.
//

import Foundation
import SwiftUI


class TourneyTableViewModel: NSObject, NSTableViewDelegate, NSTableViewDataSource
{
   
    
    
    
    // MARK: - Services
    
    lazy var pokerTracker: PokerTracker = PokerTracker()
    lazy var sharkScope: SharkScope = SharkScope()
    
    
    // MARK: - Data
    
    let players:[[String: String]] =
        [
            [
                "Player" : "Gus",
                "Stack" : "1340"
            ],
            [
                "Player" : "Daniel",
                "Stack" : "890"
            ],
            [
                "Player" : "Vanessa",
                "Stack" : "2050"
            ]
        ]
    
    
    // MARK: - TableView Hooks

    func numberOfRows(in tableView: NSTableView) -> Int
    { return (players.count) }
    
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView?
    {
        
        // Unwrap column.
        guard let column = tableColumn else { return nil }
        
        // Data.
        let player = players[row]
        
        // Cell view.
        guard let cellView = tableView.makeView(withIdentifier: (column.identifier), owner: self) as? NSTableCellView else { return nil }
        cellView.textField?.stringValue = player[column.title] ?? ""
        
        return cellView
    }
    
    
}
