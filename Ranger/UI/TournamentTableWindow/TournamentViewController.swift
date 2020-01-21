//
//  TourneyViewController.swift
//  Ranger
//
//  Created by Geri Borbás on 2019. 12. 02..
//  Copyright © 2019. Geri Borbás. All rights reserved.
//

import Cocoa
import CoreGraphics


class TournamentViewController: NSViewController
{

    
    // MARK: - UI
    
    @IBOutlet weak var playersTablePlaceholderView: NSView!
    var playersTableViewController: PlayersTableViewController!
    
    @IBOutlet weak var summaryLabel: NSTextField!
    @IBOutlet weak var statusLabel: NSTextField!
    
    
    // MARK: - Model
    
    @IBOutlet weak var viewModel: TournamentViewModel!
    
    
    // MARK: - Lifecycle
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        // Fetch SharkScope status at start.
        viewModel.fetchSharkScopeStatus
        {
            status in
            self.statusLabel.stringValue = status
        }
        
        // Instantiate table.
        let storyboard = NSStoryboard(name: "Main", bundle: nil)
        playersTableViewController = storyboard.instantiateController(withIdentifier: "PlayersTableViewController") as? PlayersTableViewController
        playersTableViewController.delegate = self
                
        // Add to placeholder.
        playersTableViewController.view.frame = playersTablePlaceholderView.bounds
        playersTablePlaceholderView.addSubview(playersTableViewController.view)
    }
    
    func track(_ tableWindowInfo: TableWindowInfo)
    {
        // Setup for table info.
        self.view.window?.title = ""
        
        // Inject into view model.
        viewModel.track(tableWindowInfo, delegate: self)
        
        // UI.
        alignWindow(to: tableWindowInfo)
    }
    
    func update(with tableWindowInfo: TableWindowInfo)
    {
        // Inject into view model (may push back changes if any).
        viewModel.update(with: tableWindowInfo)
        
        // UI.
        alignWindow(to: tableWindowInfo)
    }
    
    func alignWindow(to tableWindowInfo: TableWindowInfo)
    {        
        // Only if any.
        guard let window = self.view.window
        else { return }
        
        // Update blinds.
        window.title = ""
        
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
    
    
    // MARK: - User Events
    
    @IBAction func fetchAllDidClick(_ sender: AnyObject)
    {
        // Fetch SharkScope for all (gonna push changes back each).
        for eachRow in 0...playersTableViewController.tableView.numberOfRows
        { playersTableViewController.viewModel.fetchSharkScopeStatisticsForPlayer(inRow: eachRow) }
    }
    
    
    // MARK: - Layout
    
    func layout()
    {
        // Summary.
        let summary = viewModel.summary(with: summaryLabel.font!)
        summaryLabel.attributedStringValue = summary
        
        // Players.
        playersTableViewController.tableView.reloadData()
        
        // Status.
        statusLabel.stringValue = "Hand #\(viewModel.latestProcessedHandNumber) processed. \(playersTableViewController.viewModel.sharkScopeStatus)"
    }
}


// MARK: - Tournament Events
extension TournamentViewController: TournamentViewModelDelegate
{
    
    
    func tournamentPlayersDidChange(tournamentPlayers: [Model.Player])
    { playersTableViewController.update(with: tournamentPlayers) }
    
    func tournamentDidChange(tournamentInfo: TournamentInfo)
    { playersTableViewController.update(with: tournamentInfo) }
}


// MARK: - Players Table View Controller Events
extension TournamentViewController: PlayersTableViewControllerDelegate
{
    
    
    func playersTableDidChange()
    { layout() }
}


// MARK: - Players Table View Events
extension TournamentViewController: PlayersTableViewDelegate
{
    
    
    func fetchTournementsRequested(for playerName: String)
    { playersTableViewController.viewModel.fetchCompletedTournamentsForPlayer(withName: playerName) }
}
