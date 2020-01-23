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
    
    // Data.
    var countries: Countries = Countries.load()
    
    
    override func layout()
    {
        super.layout()
        
        // Some hardcoded UI.
        flagImageView.layer?.cornerRadius = 2.0
        flagImageView.alphaValue = 0.5
    }
        
    override func prepareForReuse()
    {
        // UI.
        flagImageView.image = NSImage(named: "Unknown")
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
            let countryName = player.sharkScope.summary?.Response.PlayerResponse.PlayerView.Player.countryName
        {
            // Estimate country date.
            let now = Date()
            let timezone = countries.country(for: country.uppercased())?.averageTimezone
            let countryDateFormatter = DateFormatter()
                countryDateFormatter.dateFormat = "MMM d, H:mm"
                countryDateFormatter.timeZone = timezone
            let dateString = countryDateFormatter.string(from: now)
            
            print(now)
            print(timezone)
            print(countryDateFormatter)
            print(dateString)
            
            flagImageView.toolTip = "\(countryName) (\(dateString))"
            flagImageView.image = NSImage(named: country.uppercased())
        }
    }
}
