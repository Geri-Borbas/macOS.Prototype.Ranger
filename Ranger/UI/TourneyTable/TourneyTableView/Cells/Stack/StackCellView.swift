//
//  FinishGraphCellView.swift
//  Ranger
//
//  Created by Geri Borbás on 2020. 01. 05..
//  Copyright © 2020. Geri Borbás. All rights reserved.
//

import Foundation
import SwiftUI


class StackCellView: PlayerCellView
{

    
    // M.
    @IBOutlet weak var mTextField: NSTextField!
    @IBOutlet weak var mBar: NSBox!
    
    // Stack.
    @IBOutlet weak var stackBarView: StackBarView!
    
    @IBOutlet weak var stackColorRanges: ColorRanges?
    @IBOutlet weak var percentProvider: PercentProvider?
    
    @IBOutlet weak var tourneyTableViewModel: TourneyTableViewModel!
    
    
    override func prepareForReuse()
    {
        // UI.
        self.textField?.stringValue = "-"
        self.mTextField?.stringValue = "-"
        setNeedsDisplay(self.bounds)
    }
    
    override func setup(with player: Model.Player, in tableColumn: NSTableColumn?)
    {
        // Checks.
        guard let column = tableColumn else { return }
        guard let textField = self.textField else { return }
        
        // Retain data.
        self.textFieldData = player.textFieldDataForColumnIdentifiers[column.identifier.rawValue]!
        
        // Apply text.
        textFieldData.apply(to: textField)
        
        // Get value.
        let stack: Float = self.textFieldData.floatValue ?? 0
        let orbitCost: Float = tourneyTableViewModel.orbitCost
        let M: Float =  stack / orbitCost
        
        // Layout.
        self.mTextField.floatValue = M

        // Dispatch values to stack bar.
        self.stackBarView.stack = textFieldData.floatValue ?? 0.0
        self.stackBarView.orbitCost = tourneyTableViewModel.orbitCost
        
        // Draw stack bar.
        self.stackBarView.setNeedsDisplay(self.stackBarView.bounds)
        
        // Layout colors.
        if let colorRanges = stackColorRanges
        {
            textField.textColor = colorRanges.color(for: M).blended(withFraction: 0.2, of: NSColor.clear)
            mBar.fillColor = colorRanges.color(for: M)
        }
                
        // Don't clip text fields.
        textField.wantsLayer = true
        textField.layer?.masksToBounds = false
        mTextField.wantsLayer = true
        mTextField.layer?.masksToBounds = false
    }
}
