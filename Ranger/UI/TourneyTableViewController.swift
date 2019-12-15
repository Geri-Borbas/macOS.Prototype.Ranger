//
//  ViewController.swift
//  Ranger
//
//  Created by Geri Borbás on 2019. 12. 02..
//  Copyright © 2019. Geri Borbás. All rights reserved.
//

import Cocoa
import CoreGraphics
// import SwiftUI


class TourneyTableViewController: NSViewController, NSComboBoxDelegate
{

    
    // MARK: - UI Outlets
    
    @IBOutlet weak var tablesComboBox: NSComboBox!
    @IBOutlet weak var blindsLabel: NSTextField!
    @IBOutlet weak var stacksLabel: NSTextField!
    @IBOutlet weak var playersTableView: NSTableView!
    
    
    // MARK: - Model Outlets
    
    @IBOutlet weak var viewModel: TourneyTableViewModel!
    
    
    // MARK: - Events
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        // Kick off updates.
        viewModel.start(onChange: layout)
    }
    
    func comboBoxSelectionDidChange(_ notification: Notification)
    {
        // Unwrap sender.
        guard let comboBox: NSComboBox = (notification.object as? NSComboBox)
        else { return }
        
        // Select model.
        viewModel.selectedLiveTourneyTableIndex = comboBox.indexOfSelectedItem
    }
    
    
    // MARK: - Layout
    
    func layout()
    {
        print("TourneyTableViewController.layout()")
        
        tablesComboBox.reloadData()
        tablesComboBox.selectItem(at: viewModel.selectedLiveTourneyTableIndex)
        
        let tableSummary = viewModel.tableSummary(for: viewModel.selectedLiveTourneyTableIndex, font: blindsLabel.font!)
        blindsLabel.attributedStringValue = tableSummary.blinds
        stacksLabel.attributedStringValue = tableSummary.stacks
        
        playersTableView.reloadData()
    }
}

