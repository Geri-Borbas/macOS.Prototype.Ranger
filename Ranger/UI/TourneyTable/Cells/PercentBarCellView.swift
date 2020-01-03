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

    
    @IBOutlet weak var percentBar: NSBox!
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
        
        // Percent bar.
        layoutPercentBar()
        
        // Don't clip text field.
        textField.wantsLayer = true
        textField.layer?.masksToBounds = false
    }
    
    override func layout()
    {
        super.layout()
        layoutPercentBar()
    }
    
    func layoutPercentBar()
    {
        // Get metrics.
        var percent: Float = 1.0
        if let parameters = layoutParameters
        {
            var value: Float = 0.0
            
            // Float.
            if let textFieldFloatData = self.textFieldData as? TextFieldFloatData
            { value = textFieldFloatData.floatValue ?? 0.0 }
            
            // Int.
            if let textFieldIntData = self.textFieldData as? TextFieldIntData
            { value = Float(textFieldIntData.intValue ?? 0) }
            
            // Double.
            if let textFieldDoubleData = self.textFieldData as? TextFieldDoubleData
            { value = Float(textFieldDoubleData.doubleValue ?? 0) }
            
            percent = parameters.percent(value: value)
        }
                
        // Layout.
        boxWidthConstraint.constant = (percentBar.superview?.frame.width ?? 0) * CGFloat(percent)
    }
}
