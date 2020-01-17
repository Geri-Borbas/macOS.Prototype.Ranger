//
//  FinishGraphCellView.swift
//  Ranger
//
//  Created by Geri Borbás on 2020. 01. 05..
//  Copyright © 2020. Geri Borbás. All rights reserved.
//

import Foundation
import SwiftUI
import SharkScope


class FinishesGraphCellView: PlayerCellView
{

    
    @IBOutlet weak var barColorRanges: ColorRanges?
    @IBOutlet weak var graphPlaceholderView: NSView!
    
    // Data.
    var byPositionPercentage: GraphData?
    
    // Shortcuts.
    let upperBound = 2.0
    var graphFrame: NSRect { graphPlaceholderView.frame }
    var color: NSColor { barColorRanges?.color(for: Float(byPositionPercentage?.trendLine.slope ?? 0.0)) ?? NSColor.white }
        
    
    override func prepareForReuse()
    {
        // Flush data.
        self.byPositionPercentage = nil
        
        // UI.
        self.textField?.stringValue = "-"
        setNeedsDisplay(self.bounds)
    }
    
    override func setup(with player: Model.Player, in tableColumn: NSTableColumn?)
    {
        // Checks.
        guard let column = tableColumn else { return }
        guard let textField = self.textField else { return }
        guard let byPositionPercentage = player.sharkScope.statistics?.byPositionPercentage else { return }
        
        // Retain data.
        self.byPositionPercentage = byPositionPercentage
        self.textFieldData = player.textFieldDataForColumnIdentifiers[column.identifier.rawValue]!
        
        // Apply text.
        textFieldData.apply(to: textField)
                
        // Don't clip text field.
        textField.wantsLayer = true
        textField.layer?.masksToBounds = false
        
        // Invoke draw.
        setNeedsDisplay(self.bounds)
    }
    
    override func layout()
    {
        super.layout()
        textField?.textColor = color
    }

    override func draw(_ dirtyRect: NSRect)
    {
        super.draw(dirtyRect)

        // Only with data.
        guard let byPositionPercentage = byPositionPercentage
        else
        {
            // Clear cell content.
            NSColor.clear.setFill()
            NSBezierPath(rect: graphFrame).fill()
            return
        }
        
        // Draw bar graph.
        drawBars_1(from: byPositionPercentage, in: graphFrame)
        
        // Draw trend line.
        drawTrendLine(from: byPositionPercentage, in: graphFrame)
    }
    
    private func drawTrendLine(from graphData: GraphData, in rect: CGRect)
    {
        // Constants.
        let unitBarHeight = Double(rect.size.height) / upperBound
        
        // Slope data.
        let left = graphData.trendLine.offset
        let delta = graphData.trendLine.slope * Double(graphData.dataPoints.count)
        let right = left + delta
        
        // Construct.
        let slope = NSBezierPath()
            slope.move(to: NSPoint.zero)
            slope.line(to: NSPoint(x: 0, y: CGFloat(left * unitBarHeight)))
            slope.line(to: NSPoint(x: rect.size.width, y: CGFloat(right * unitBarHeight)))
            slope.line(to: NSPoint(x: rect.size.width, y: 0))
            slope.line(to: NSPoint.zero)
            slope.close()
        
        // Draw.
        color.setFill()
        slope.fill()
    }
    
    private func drawBars_1(from graphData: GraphData, in rect: CGRect)
    {
        // Constants.
        let barWidth = rect.size.width / CGFloat(graphData.dataPoints.count)
        let barHeight = rect.size.height
        let upperBound = graphData.trendLine.max // 3.0
        
        // Draw each bar.
        for (eachIndex, eachDataPoint) in graphData.dataPoints.enumerated()
        {
            // Layout.
            let clampedData = min(eachDataPoint.y, upperBound)
            let normalizedData = clampedData / upperBound
            let eachColumnRect = CGRect(
                x: CGFloat(eachIndex) * barWidth,
                y: 0,
                width: barWidth,
                height: barHeight
            )
            
            // Create bar.
            let eachBar = NSBezierPath(rect: eachColumnRect)
            
            // Pick bar color.
            let drawColor = NSColor.clear.blended(withFraction: CGFloat(normalizedData), of: color) ?? color
            
            // Draw each bar.
            drawColor.setFill()
            eachBar.fill()
        }
    }
    
    private func drawBars_2(from graphData: GraphData, in rect: CGRect)
    {
        // Constants.
        let barWidth = rect.size.width / CGFloat(graphData.dataPoints.count) // 0.8
        let barHeight = rect.size.height // 17
        let unitBarHeight = barHeight / CGFloat(upperBound) // 8.5
        
        let bars = NSBezierPath()
        for (eachIndex, eachDataPoint) in graphData.dataPoints.enumerated()
        {
            // Layout.
            let clampedData = min(eachDataPoint.y, upperBound) // 0...2
            let eachColumnRect = CGRect(
                x: CGFloat(eachIndex) * barWidth,
                y: 0,
                width: barWidth,
                height: CGFloat(clampedData) * unitBarHeight
            )
            
            // Append.
            bars.appendRect(eachColumnRect)
        }
        
        // Draw bars.
        color.setFill()
        bars.fill()
    }
}
