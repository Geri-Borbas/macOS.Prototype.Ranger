//
//  TourneyViewController.swift
//  Ranger
//
//  Created by Geri Borbás on 2019. 12. 02..
//  Copyright © 2019. Geri Borbás. All rights reserved.
//

import Cocoa
import CoreGraphics


class PlayersViewController: NSViewController,
    
    PlayersTableViewControllerDelegate
{

    
    // MARK: - UI
    
    @IBOutlet weak var playersTablePlaceholderView: NSView!
    var playersTableViewController: PlayersTableViewController!
    @IBOutlet weak var statusLabel: NSTextField!
    
    
    // MARK: - Lifecycle
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        // Instantiate table.
        let storyboard = NSStoryboard(name: "Main", bundle: nil)
        playersTableViewController = storyboard.instantiateController(withIdentifier: "PlayersTableViewController") as? PlayersTableViewController
        
        // Get updates.
        playersTableViewController.delegate = self
        
        // Add to placeholder.
        playersTableViewController.view.frame = playersTablePlaceholderView.bounds
        playersTablePlaceholderView.addSubview(playersTableViewController.view)
    }
    
    public func update(with players: [Model.Player])
    { playersTableViewController.update(with: players) }
    
    public func hideColumns(columnIdentifiers: [String])
    {
        columnIdentifiers.forEach
        {
            eachColumnIdentifier in
            playersTableViewController.tableView.tableColumn(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: eachColumnIdentifier))?.isHidden = true
        }
        
    }
    
    
    // MARK: - User Events
    
    @IBAction func fetchAllDidClick(_ sender: AnyObject)
    {
        // Fetch SharkScope for all (gonna push changes back each).
        for eachRow in 0...playersTableViewController.tableView.numberOfRows
        { playersTableViewController.viewModel.fetchSharkScopeStatisticsForPlayer(inRow: eachRow) }
    }
    
    
    // MARK: - Players Table Events
    
    func fetchCompletedTournementsRequested(for playerName: String)
    { playersTableViewController.viewModel.fetchCompletedTournamentsForPlayer(withName: playerName) }
    
    
    // MARK: - Layout
    
    func playersTableDidChange()
    {
        // Status.
        statusLabel.stringValue = "\(playersTableViewController.viewModel.players.count) players. \(playersTableViewController.viewModel.sharkScopeStatus)"
    }
}

