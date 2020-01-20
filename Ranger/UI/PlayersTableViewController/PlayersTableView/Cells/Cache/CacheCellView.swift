//
//  FinishGraphCellView.swift
//  Ranger
//
//  Created by Geri Borbás on 2020. 01. 05..
//  Copyright © 2020. Geri Borbás. All rights reserved.
//

import Foundation
import SwiftUI


class CacheCellView: PlayerCellView
{

    
    // UI.
    @IBOutlet weak var activeTournamentsButton: NSButton!
    @IBOutlet weak var statisticsButton: NSButton!
    @IBOutlet weak var tournamentsButton: NSButton!
    
    
    override func prepareForReuse()
    {
        // UI.
        activeTournamentsButton.state = .off
        statisticsButton.state = .off
        tournamentsButton.state = .off
    }
    
    override func setup(with player: Model.Player, in tableColumn: NSTableColumn?)
    {        
        // Get values.
        activeTournamentsButton.state = player.sharkScope.hasActiveTournamentsCache ? .on : .off
        statisticsButton.state = player.sharkScope.hasStatisticsCache ? .on : .off
        tournamentsButton.state = player.sharkScope.hasTournamentsCache ? .on : .off
    }
}
