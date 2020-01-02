//
//  PercentBarCellView.swift
//  Ranger
//
//  Created by Geri Borbás on 2020. 01. 02..
//  Copyright © 2020. Geri Borbás. All rights reserved.
//

import Foundation
import SwiftUI


class PercentBarCellView: PlayerViewModelCellView
{

    
    @IBOutlet weak var box: NSBox!
    @IBOutlet weak var boxWidthConstraint: NSLayoutConstraint!
    var textFieldFloatData: TextFieldFloatData!
    
    
    override func setup(with playerViewModel: PlayerViewModel, in tableColumn: NSTableColumn?)
    {
        // Checks.
        guard let column = tableColumn else { return }
        guard let textField = self.textField else { return }
        
        // Retain data.
        self.textFieldFloatData = playerViewModel.textFieldDataForColumnIdentifiers[column.identifier.rawValue]! as? TextFieldFloatData
        
        // Apply text.
        textFieldFloatData.apply(to: textField)
        
        // Layout.
        boxWidthConstraint.constant = self.frame.width * CGFloat(textFieldFloatData.floatValue ?? 1.0)
        
        // Don't clip.
        textField.wantsLayer = true
        textField.layer?.masksToBounds = false
    }
}
