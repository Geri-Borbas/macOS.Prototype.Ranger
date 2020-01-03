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
    @IBOutlet weak var layoutParameters: LayoutParameters?
    
    
    override func setup(with playerViewModel: PlayerViewModel, in tableColumn: NSTableColumn?)
    {
        // Checks.
        guard let column = tableColumn else { return }
        guard let textField = self.textField else { return }
        
        // Retain data.
        self.textFieldData = playerViewModel.textFieldDataForColumnIdentifiers[column.identifier.rawValue]! // as? TextFieldData
        
        // Apply text.
        textFieldData.apply(to: textField)
        
        // Get metrics.
        var adjustedPercent: Float = 0.0
        if let parameters = layoutParameters
        {
            // Float.
            if let textFieldFloatData = self.textFieldData as? TextFieldFloatData
            { adjustedPercent = textFieldFloatData.floatValue ?? 0.0 }
            
            // Int.
            if let textFieldIntData = self.textFieldData as? TextFieldIntData
            { adjustedPercent = Float(textFieldIntData.intValue ?? 0) }
            
            // Int.
            if let textFieldDoubleData = self.textFieldData as? TextFieldDoubleData
            { adjustedPercent = Float(textFieldDoubleData.doubleValue ?? 0) }
            
            adjustedPercent = parameters.adjusted(value: adjustedPercent)
        }
                
        // Layout.
        var boxParent: NSView = self
        // if (box.superview != self) { boxParent = box.superview! }
        boxWidthConstraint.constant = boxParent.frame.width * CGFloat(adjustedPercent)
        
        // Don't clip.
        textField.wantsLayer = true
        textField.layer?.masksToBounds = false
    }
}
