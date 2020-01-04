//
//  RowView.swift
//  Ranger
//
//  Created by Geri Borbás on 2020. 01. 04..
//  Copyright © 2020. Geri Borbás. All rights reserved.
//

import Cocoa

class RowView: NSTableRowView
{

    
    override func draw(_ dirtyRect: NSRect)
    {
        super.draw(dirtyRect)
    }
    
    override func drawSelection(in dirtyRect: NSRect)
    {
        // Only if needed.
        guard self.selectionHighlightStyle != .none
        else { return }
        
        // Draw.
        NSColor(white: 1, alpha: 0.1).setFill()
        NSBezierPath.init(
            roundedRect: self.bounds.shorter(by: 1),
            xRadius: 2,
            yRadius: 2
        ).fill()
    }
}

extension NSRect
{
    
    
    func shorter(by height: CGFloat) -> NSRect
    {
        return NSRect(
            x: self.origin.x,
            y: self.origin.y,
            width: self.size.width,
            height: self.size.height - height
        )
    }
}
