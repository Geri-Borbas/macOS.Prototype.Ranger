//
//  PlayerCellView.swift
//  Ranger
//
//  Created by Geri Borbás on 2020. 01. 02..
//  Copyright © 2020. Geri Borbás. All rights reserved.
//

import Cocoa


class PlayerCellView: NSTableCellView
{
    
    
    var textFieldData: TextFieldData!
    var player: Model.Player!
    
    
    func setup(with player: Model.Player, in tableColumn: NSTableColumn?)
    {
        // Checks.
        guard let column = tableColumn else { return }
        guard let textField = self.textField else { return }
        
        // Retain data.
        self.player = player
        self.textFieldData = player.textFieldDataForColumnIdentifiers[column.identifier.rawValue]!
        
        // Apply text.
        textFieldData.apply(to: textField)
    }
}
