//
//  PercentBarCellView.swift
//  Ranger
//
//  Created by Geri Borbás on 2020. 01. 02..
//  Copyright © 2020. Geri Borbás. All rights reserved.
//

import Foundation
import SwiftUI


class PercentBarCellView: PlayerCellView
{

    
    @IBOutlet weak var bar: NSBox!
    @IBOutlet weak var barWidthConstraint: NSLayoutConstraint?
    @IBOutlet weak var barColorRanges: ColorRanges?
    @IBOutlet weak var textFieldColorRanges: ColorRanges?
    
    @IBOutlet weak var percentProvider: PercentProvider?
    
    
    override func setup(with player: Model.Player, in tableColumn: NSTableColumn?)
    {
        // Checks.
        guard let column = tableColumn else { return }
        guard let textField = self.textField else { return }
        
        // Retain data.
        self.textFieldData = player.textFieldDataForColumnIdentifiers[column.identifier.rawValue]!
        
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
        // Get value.
        let value: Float = self.textFieldData.floatValue ?? 0
        
        // Get percent.
        var percent: Float = 1.0
        if let parameters = percentProvider
        { percent = parameters.percent(value: value) }
                
        // Layout bar size.
        if let widthConstraint = barWidthConstraint
        {
            let width = (bar.superview?.frame.width ?? 0) * CGFloat(percent)
            widthConstraint.constant = max(0, width)
        }
                
        // Layout bar color.
        if let colorRanges = barColorRanges
        { bar.fillColor = colorRanges.color(for: value) }
                
        // Layout text field color.
        if let colorRanges = textFieldColorRanges
        { textField?.textColor = colorRanges.color(for: value) }
    }
}
