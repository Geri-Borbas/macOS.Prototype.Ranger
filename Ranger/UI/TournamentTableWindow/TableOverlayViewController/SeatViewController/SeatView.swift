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


    // Circle.
    @IBOutlet weak var circleBackgroundImageView: NSImageView!
    @IBOutlet weak var ringButton: NSButton!
    
    // Tables.
    @IBOutlet weak var tablesTextField: NSTextField!
    @IBOutlet weak var tablesBox: NSBox!
    
    // M.
    @IBOutlet weak var mTextField: NSTextField!
    
    // Statistics.
    @IBOutlet weak var vpipTextField: NSTextField!
    @IBOutlet weak var pfrTextField: NSTextField!
    @IBOutlet weak var handsTextField: NSTextField!
    @IBOutlet weak var vpipView: NSView!
    @IBOutlet weak var vpipBox: NSBox!
    @IBOutlet weak var pfrView: NSView!
    @IBOutlet weak var pfrBox: NSBox!
    
    // Layout.
    @IBOutlet weak var vpipPercentProvider: PercentProvider!
    @IBOutlet weak var pfrPercentProvider: PercentProvider!
    @IBOutlet weak var vpipBoxWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var pfrBoxWidthConstraint: NSLayoutConstraint!
    
    // Collections.
    lazy var statisticsViews: [NSView] =
    [
        tablesTextField,
        tablesBox,
        mTextField,
        vpipTextField,
        pfrTextField,
        handsTextField,
        vpipBox,
        pfrBox
    ]
    
    lazy var pokerTrackerStatisticsViews: [NSView] =
    [
        mTextField,
        vpipTextField,
        pfrTextField,
        handsTextField,
        vpipBox,
        pfrBox
    ]
    
    // Caches.
    var cornerRadiusesForBoxes: [NSBox:CGFloat] = [:]
    var fontSizesForIdentifiers: [NSTextField:CGFloat] = [:]
    
    
    override func layout()
    {
        super.layout()
        captureMetrics()
        layoutBars()
    }
    
    
    // MARK: - Layout Bars
    
    func layoutVpip(for value: Float)
    {
        // Size.
        var width = Float(vpipView.bounds.size.width) * vpipPercentProvider.percent(value: value)
        
        // Clamp.
        if (width.isNaN || width < 0.0) { width = 0.0 }
        if (width > Float(vpipView.bounds.size.width)) { width = Float(vpipView.bounds.size.width) }
        
        // Set.
        vpipBoxWidthConstraint.constant = CGFloat(width)
        
        // Color.
        vpipBox.fillColor = ColorRanges.VPIP.color(for: Double(value))
        
        // Text.
        vpipTextField.floatValue = value
        vpipTextField.toolTip = "\(Int.random(in: 0...100))/\(Int.random(in: 0...100))"
    }
    
    func layoutPfr(for value: Float)
    {
         // Size.
       var width = Float(pfrView.bounds.size.width) * pfrPercentProvider.percent(value: value)
       
       // Clamp.
       if (width.isNaN || width < 0.0) { width = 0.0 }
       if (width > Float(pfrView.bounds.size.width)) { width = Float(pfrView.bounds.size.width) }
       
       // Set.
       pfrBoxWidthConstraint.constant = CGFloat(width)
        
        // Color.
        let color = ColorRanges.PFR.color(for: Double(value))
        pfrBox.fillColor = color
        
        // Text.
        pfrTextField.floatValue = value
        pfrTextField.toolTip = "\(Int.random(in: 0...100))/\(Int.random(in: 0...100))"
    }
    
    func layoutBars()
    {
        // Recalculate widths using current UI data.
        layoutVpip(for: vpipTextField.floatValue)
        layoutPfr(for: pfrTextField.floatValue)
    }
    
    
    // MARK: - Layout Scale
    
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
            tablesBox : tablesBox.cornerRadius,
            vpipBox : vpipBox.cornerRadius,
            pfrBox : pfrBox.cornerRadius
        ]
        
        // Capture font sizes.
        fontSizesForIdentifiers =
        [
            tablesTextField : tablesTextField.fontSize,
            mTextField : mTextField.fontSize,
            vpipTextField : vpipTextField.fontSize,
            pfrTextField : pfrTextField.fontSize,
            handsTextField : handsTextField.fontSize
        ]
    }
    
    func capturedCornerRadius(for box: NSBox) -> CGFloat
    { cornerRadiusesForBoxes[box] ?? box.cornerRadius }
    
    func capturedFontSize(for textField: NSTextField) -> CGFloat
    { fontSizesForIdentifiers[textField] ?? 0.0 }
    
    func scale(to scale: CGFloat)
    {
        // Scale corner radiuses.
        tablesBox.cornerRadius = capturedCornerRadius(for: tablesBox) * scale
        vpipBox.cornerRadius = capturedCornerRadius(for: vpipBox) * scale
        pfrBox.cornerRadius = capturedCornerRadius(for: pfrBox) * scale
        
        // Scale fonts.
        tablesTextField.fontSize = capturedFontSize(for: tablesTextField) * scale
        mTextField.fontSize = capturedFontSize(for: mTextField) * scale
        vpipTextField.fontSize = capturedFontSize(for: vpipTextField) * scale
        pfrTextField.fontSize = capturedFontSize(for: pfrTextField) * scale
        handsTextField.fontSize = capturedFontSize(for: handsTextField) * scale
    }
}
