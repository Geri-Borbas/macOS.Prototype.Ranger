//
//  StackBarView.swift
//  Ranger
//
//  Created by Geri Borbás on 2020. 01. 08..
//  Copyright © 2020. Geri Borbás. All rights reserved.
//

import Cocoa



class StackBarView: NSView
{

    
    @IBOutlet weak var percentProvider: PercentProvider?
    @IBOutlet weak var colorRanges: ColorRangeProvider?
    
    
    // Plugs.
    var stack: Float = 1500
    var orbitCost: Float = 57
    
    
    override func draw(_ dirtyRect: NSRect)
    {
        super.draw(dirtyRect)
        
        // Checks.
        guard let percentProvider = percentProvider
        else { return }
        
        // Draw chunks.
        var stackCursor: Float = 0.0
        let radius: CGFloat =  2.0
        let spacing: CGFloat = radius
        let M: Float = stack / orbitCost
        let incrementSize: Float = (M > 6.0) ? 5.0 : 1.0
        let stackIncrement = orbitCost * incrementSize // Draw 5M (or 1M) chunks
        while (true)
        {
            // Get bounds.
            let leftStack = stackCursor
            var rightStack = stackCursor + stackIncrement
            
            // Cap.
            if (rightStack > stack) { rightStack = stack }
            
            let leftPercent = percentProvider.percent(value: leftStack)
            let rightPercent = percentProvider.percent(value: rightStack)
                        
            let leftPosition = CGFloat(leftPercent) * self.bounds.width + spacing / 2.0
            let rightPosition = CGFloat(rightPercent) * self.bounds.width - spacing / 2.0
            var width = rightPosition - leftPosition
            
            // Cap.
            if (width < radius) { width = 0.0 }
            else if (width < radius * 2.0) { width = radius * 2.0 }
            
            // Measure.
            let chunkRect = CGRect(
                x: leftPosition,
                y: self.bounds.origin.y,
                width: width,
                height:  self.bounds.height
            )
            
            // Calculate color.
            let stackM = stack / orbitCost
            // let rightM = rightStack / orbitCost

            // Draw.
            let chunk = NSBezierPath(roundedRect: chunkRect, xRadius: 2.0, yRadius: 2.0)
            (colorRanges?.color(for: stackM) ?? NSColor.white).setFill()
            chunk.fill()
            
            // Step.
            stackCursor = rightStack
            
            // End.
            if (stackCursor >= stack)
            { break }
        }
    }
    
    func drawDebugPaths()
    {
        // Checks.
        guard let percentProvider = percentProvider
        else { return }
        
        NSColor(white: 1.0, alpha: 0.4).setFill()
        NSBezierPath(
            roundedRect: self.bounds,
            xRadius: 2.0,
            yRadius: 2.0
        ).fill()
        
        NSColor(white: 1.0, alpha: 0.6).setFill()
        NSBezierPath(
            roundedRect: CGRect(
                x: self.bounds.origin.x,
                y: self.bounds.origin.y,
                width: self.bounds.width * CGFloat(percentProvider.percent(value: stack)),
                height:  self.bounds.height
            ),
            xRadius: 2.0,
            yRadius: 2.0
        ).fill()
    }
    
}
