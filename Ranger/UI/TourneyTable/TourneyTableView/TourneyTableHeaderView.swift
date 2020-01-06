//
//  TourneyTableHeaderView.swift
//  Ranger
//
//  Created by Geri Borbás on 2020. 01. 06..
//  Copyright © 2020. Geri Borbás. All rights reserved.
//

import Cocoa


@objc protocol TourneyTableHeaderViewDelegate
{
    
    
    func tableHeaderContextMenu(for column: NSTableColumn) -> NSMenu?
}


class TourneyTableHeaderView: NSTableHeaderView
{
    
    
    @IBOutlet weak var delegate: TourneyTableHeaderViewDelegate?
    
    
    override func menu(for event: NSEvent) -> NSMenu?
    {
        // Checks.
        guard let tableView = self.tableView
        else { return nil }
        
        // Get column.
        let columnIndex = self.column(at: self.convert(event.locationInWindow, from: nil))
        let column = tableView.tableColumns[columnIndex]
                
        // Ask for menu.
        return self.delegate?.tableHeaderContextMenu(for: column);
    }

    override func draw(_ dirtyRect: NSRect)
    { super.draw(dirtyRect) }
}
