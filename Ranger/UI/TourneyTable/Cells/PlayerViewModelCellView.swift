//
//  PlayerViewModelCellView.swift
//  Ranger
//
//  Created by Geri Borbás on 2020. 01. 02..
//  Copyright © 2020. Geri Borbás. All rights reserved.
//

import Cocoa


class PlayerViewModelCellView: NSTableCellView
{
    
    
    var textFieldData: TextFieldData!
    var playerViewModel: PlayerViewModel!
    
    
    func setup(with playerViewModel: PlayerViewModel, in tableColumn: NSTableColumn?)
    {
        // Checks.
        guard let column = tableColumn else { return }
        guard let textField = self.textField else { return }
        
        // Retain data.
        self.playerViewModel = playerViewModel
        self.textFieldData = playerViewModel.textFieldDataForColumnIdentifiers[column.identifier.rawValue]!
        
        // Apply text.
        textFieldData.apply(to: textField)
    }
}
