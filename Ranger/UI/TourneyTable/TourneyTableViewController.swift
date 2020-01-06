//
//  ViewController.swift
//  Ranger
//
//  Created by Geri Borbás on 2019. 12. 02..
//  Copyright © 2019. Geri Borbás. All rights reserved.
//

import Cocoa
import CoreGraphics


class TourneyTableViewController: NSViewController,
    
    TourneyTableHeaderViewDelegate
    
{

    
    // MARK: - UI
    
    @IBOutlet weak var blindsLabel: NSTextField!
    @IBOutlet weak var stacksLabel: NSTextField!
    @IBOutlet weak var playersTableView: NSTableView!
    @IBOutlet weak var statusLabel: NSTextField!
    @IBOutlet weak var sharkScopeStatusLabel: NSTextField!
    
    
    // MARK: - Model
    
    @IBOutlet weak var viewModel: TourneyTableViewModel!
    
    
    // MARK: - Lifecycle
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        // Fetch SharkScope status at start.
        viewModel.fetchSharkScopeStatus
        {
            status in
            self.sharkScopeStatusLabel.stringValue = status
        }
        
        // Double click.
        playersTableView.doubleAction = #selector(tableDidDoubleClick)
    }
    
    func track(_ tableWindowInfo: TableWindowInfo)
    {
        // Setup for table info.
        self.view.window?.title = tableWindowInfo.name
        
        // Inject into view model.
        viewModel.track(tableWindowInfo, onChange: viewModelDidChange)
        
    }
    
    func update(with tableWindowInfo: TableWindowInfo)
    {
        // Inject into view model (may push back changes if any).
        viewModel.update(with: tableWindowInfo)
        
        // UI.
        if (App.configuration.isLiveMode)
        { alignWindow(to: tableWindowInfo) }
    }
    
    func alignWindow(to tableWindowInfo: TableWindowInfo)
    {
        // Only if any.
        guard let window = self.view.window
        else { return }
        
        // Update blinds.
        window.title = tableWindowInfo.name
        
        // Align.
        window.setFrame(
            NSRect(
                x: tableWindowInfo.UIKitBounds.origin.x,
                y: tableWindowInfo.UIKitBounds.origin.y - window.frame.size.height,
                width: tableWindowInfo.UIKitBounds.size.width,
                height: window.frame.size.height
            ),
            display: true
        )
         
        // Put above.
        window.order(NSWindow.OrderingMode.above, relativeTo: tableWindowInfo.number)
        
        // Disable drag.
        window.isMovable = false
    }
    
    
    // MARK: - Events
    
    @IBAction func fetchAllDidClick(_ sender: AnyObject)
    {
        // Fetch SharkScope for all (gonna push changes back each).
        for eachRow in 0...playersTableView.numberOfRows
        { viewModel.fetchSharkScopeStatisticsForPlayer(inRow: eachRow) }
    }
    
    @objc func tableDidDoubleClick()
    {
        // Skip header row double click.
        guard playersTableView.clickedRow > -1 else { return }
        
        // Fetch SharkScope (gonna push changes back).
        viewModel.fetchSharkScopeStatisticsForPlayer(inRow: playersTableView.clickedRow)
    }
    
    func tableHeaderContextMenu(for column: NSTableColumn) -> NSMenu?
    { return viewModel.tableHeaderContextMenu(for: column) }
    
    
    // MARK: - Layout
    
    func viewModelDidChange()
    {
        // Summary.
        let summary = viewModel.summary(with: blindsLabel.font!)
        blindsLabel.attributedStringValue = summary.blinds
        stacksLabel.attributedStringValue = summary.stacks
        
        // Players.
        playersTableView.reloadData()
        
        // Status.
        statusLabel.stringValue = "Hand #\(viewModel.latestProcessedHandNumber) processed."
    }
}

