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
    
    // Names / Tables.
    @IBOutlet weak var nameTextField: NSTextField!
    @IBOutlet weak var tablesTextField: NSTextField!
    @IBOutlet weak var nameImageView: NSImageView!
    
    // M.
    @IBOutlet weak var mTextField: NSTextField!
    @IBOutlet weak var mHandsTextField: NSTextField!
    @IBOutlet weak var mBox: NSBox!
    
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
        mTextField,
        mHandsTextField,
        mBox,
        vpipTextField,
        pfrTextField,
        handsTextField,
        vpipBox,
        pfrBox
    ]
    
    lazy var pokerTrackerStatisticsViews: [NSView] =
    [
        mTextField,
        mHandsTextField,
        mBox,
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
        vpipBoxWidthConstraint.constant = vpipView.bounds.size.width * CGFloat(vpipPercentProvider.percent(value: value))
        
        // Color.
        vpipBox.fillColor = ColorRanges.VPIP.color(for: Double(value))
        
        // Text.
        vpipTextField.floatValue = value
        vpipTextField.toolTip = "\(Int.random(in: 0...100))/\(Int.random(in: 0...100))"
    }
    
    func layoutPfr(for value: Float)
    {
        // Size.
        pfrBoxWidthConstraint.constant = pfrView.bounds.size.width * CGFloat(pfrPercentProvider.percent(value: value))
        
        // Color.
        pfrBox.fillColor = ColorRanges.PFR.color(for: Double(value))
        
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
            mBox : mBox.cornerRadius,
            vpipBox : vpipBox.cornerRadius,
            pfrBox : pfrBox.cornerRadius
        ]
        
        // Capture font sizes.
        fontSizesForIdentifiers =
        [
            nameTextField : nameTextField.fontSize,
            tablesTextField : tablesTextField.fontSize,
            mTextField : mTextField.fontSize,
            mHandsTextField : mHandsTextField.fontSize,
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
        mBox.cornerRadius = capturedCornerRadius(for: mBox) * scale
        vpipBox.cornerRadius = capturedCornerRadius(for: vpipBox) * scale
        pfrBox.cornerRadius = capturedCornerRadius(for: pfrBox) * scale
        
        // Scale fonts.
        nameTextField.fontSize = capturedFontSize(for: nameTextField) * scale
        tablesTextField.fontSize = capturedFontSize(for: tablesTextField) * scale
        mTextField.fontSize = capturedFontSize(for: mTextField) * scale
        mHandsTextField.fontSize = capturedFontSize(for: mHandsTextField) * scale
        vpipTextField.fontSize = capturedFontSize(for: vpipTextField) * scale
        pfrTextField.fontSize = capturedFontSize(for: pfrTextField) * scale
        handsTextField.fontSize = capturedFontSize(for: handsTextField) * scale
    }
}
