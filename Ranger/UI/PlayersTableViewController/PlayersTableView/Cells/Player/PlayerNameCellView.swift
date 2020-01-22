//
//  PlayerNameCellView.swift
//  Ranger
//
//  Created by Geri Borbás on 2020. 01. 05..
//  Copyright © 2020. Geri Borbás. All rights reserved.
//

import Foundation
import SwiftUI


class PlayerNameCellView: PlayerCellView
{

    
    // UI.
    @IBOutlet weak var flagImageView: NSImageView!
    
    
    override func prepareForReuse()
    {
        // UI.
        flagImageView.image = nil
    }
    
    override func setup(with player: Model.Player, in tableColumn: NSTableColumn?)
    {
        // Checks.
        guard let column = tableColumn else { return }
        guard let textField = self.textField else { return }
        
        // Retain data.
        self.player = player
        self.textFieldData = player.textFieldDataForColumnIdentifiers[column.identifier.rawValue]!
        
        // Apply text.
        textFieldData.apply(to: textField)
        
        // Get values.
        if
            let country = player.sharkScope.summary?.Response.PlayerResponse.PlayerView.Player.country,
            let countryName = player.sharkScope.summary?.Response.PlayerResponse.PlayerView.Player.countryName,
            let flagURL = URL(string: "https://www.countryflags.io/\(country.lowercased())/flat/64.png")
        {
            flagImageView.toolTip = countryName
            flagImageView.image = NSImage(byReferencing: flagURL)
        }
    }
}
