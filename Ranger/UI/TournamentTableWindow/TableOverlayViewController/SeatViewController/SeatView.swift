//
//  SeatsView.swift
//  Ranger
//
//  Created by Geri Borbás on 2020. 01. 26..
//  Copyright © 2020. Geri Borbás. All rights reserved.
//

import Cocoa


class SeatView: NSView
{


    // UI.
    @IBOutlet weak var outlets: SeatViewOutlets!
    
    
    var cornerRadiusesForBoxes: [NSBox:CGFloat] = [:]
    var fontSizesForIdentifiers: [NSTextField:CGFloat] = [:]
    
    
    override func layout()
    {
        super.layout()
        captureMetrics()
    }
    
    func captureMetrics()
    {
        // Capture interface builder metrics (capture only once upon unarchiving).
        guard
            cornerRadiusesForBoxes == [:],
            fontSizesForIdentifiers == [:]
        else { return }
        
        // Capture corner radiuses.
        cornerRadiusesForBoxes =
        [
            outlets.mBox : outlets.mBox.cornerRadius,
            outlets.vpipBox : outlets.vpipBox.cornerRadius,
            outlets.pfrBox : outlets.pfrBox.cornerRadius
        ]
        
        // Capture font sizes.
        fontSizesForIdentifiers =
        [
            outlets.nameTextField : outlets.nameTextField.fontSize,
            outlets.tablesTextField : outlets.tablesTextField.fontSize,
            outlets.mTextField : outlets.mTextField.fontSize,
            outlets.mHandsTextField : outlets.mHandsTextField.fontSize,
            outlets.vpipTextField : outlets.vpipTextField.fontSize,
            outlets.pfrTextField : outlets.pfrTextField.fontSize,
            outlets.handsTextField : outlets.handsTextField.fontSize
        ]
    }
    
    func capturedCornerRadius(for box: NSBox) -> CGFloat
    { cornerRadiusesForBoxes[box] ?? box.cornerRadius }
    
    func capturedFontSize(for textField: NSTextField) -> CGFloat
    { fontSizesForIdentifiers[textField] ?? 0.0 }
    
    
    // MARK: - Layout Scale
    
    func scale(to scale: CGFloat)
    {
        // Scale corner radiuses.
        outlets.mBox.cornerRadius = capturedCornerRadius(for: outlets.mBox) * scale
        outlets.vpipBox.cornerRadius = capturedCornerRadius(for: outlets.vpipBox) * scale
        outlets.pfrBox.cornerRadius = capturedCornerRadius(for: outlets.pfrBox) * scale
        
        // Scale fonts.
        outlets.nameTextField.fontSize = capturedFontSize(for: outlets.nameTextField) * scale
        outlets.tablesTextField.fontSize = capturedFontSize(for: outlets.tablesTextField) * scale
        outlets.mTextField.fontSize = capturedFontSize(for: outlets.mTextField) * scale
        outlets.mHandsTextField.fontSize = capturedFontSize(for: outlets.mHandsTextField) * scale
        outlets.vpipTextField.fontSize = capturedFontSize(for: outlets.vpipTextField) * scale
        outlets.pfrTextField.fontSize = capturedFontSize(for: outlets.pfrTextField) * scale
        outlets.handsTextField.fontSize = capturedFontSize(for: outlets.handsTextField) * scale
    }
}
