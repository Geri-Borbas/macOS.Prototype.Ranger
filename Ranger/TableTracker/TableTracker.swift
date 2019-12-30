//
//  Watcher.swift
//  Ranger
//
//  Created by Geri Borbás on 2019. 12. 15..
//  Copyright © 2019. Geri Borbás. All rights reserved.
//

import Foundation
import SwiftUI


protocol TableTrackerDelegate: AnyObject
{
    
    
    func windowTrackerDidStartTrackingTable(tableWindowInfo: TableWindowInfo)
    func windowTrackerDidUpdateTableWindowInfo(tableWindowInfo: TableWindowInfo)
    func windowTrackerDidStopTrackingTable(tableWindowInfo: TableWindowInfo)
}


class TableTracker
{
    
    
    public var tickCount: Int = 0
    public var firstTableWindowInfo: TableWindowInfo?
    {
        didSet
        {
            let newValue = firstTableWindowInfo
            
            if (oldValue == newValue)
            { return }
            
            if (oldValue == nil && newValue != nil)
            { delegate?.windowTrackerDidStartTrackingTable(tableWindowInfo: newValue!) }
            
            if (oldValue != nil && newValue == nil)
            { delegate?.windowTrackerDidStopTrackingTable(tableWindowInfo: oldValue!) }
        }
    }
    weak var delegate: TableTrackerDelegate?
    
    
    // MARK: - Lifecycle
        
    func start()
    {
        // Invoke Screen Recording Privacy dialog.
        CGWindowListCreateImage(CGRect.zero, .optionOnScreenOnly, kCGNullWindowID, .nominalResolution)
        
        // Kickoff timer.
        let interval = 1.0 / 60.0
        let timer = Timer(timeInterval: interval, target: self, selector: #selector(self.tick), userInfo: nil, repeats: true)
        RunLoop.current.add(timer, forMode: RunLoop.Mode.common)
    }
    
    
    // MARK: - Window lookup
    
    func searchFirstTableWindowInfo() -> TableWindowInfo?
    {
        // Get windows.
        let windowInfoList = CGWindowListCopyWindowInfo(
            CGWindowListOption(arrayLiteral: .excludeDesktopElements, .optionOnScreenOnly),
            kCGNullWindowID
        ) as! [[String:Any]]
        
        // Filter PokerStars Tournament Table windows.
        let tourneyWindows = windowInfoList.filter
        {
            (eachWindowInfo: [String:Any]) in
            isLobbyWindowInfo(eachWindowInfo)
        }
        .map
        {
            eachPokerStarsWindowInfo in
            TableWindowInfo(
                name: eachPokerStarsWindowInfo["kCGWindowName"] as! String,
                number: eachPokerStarsWindowInfo["kCGWindowNumber"] as! Int,
                bounds: CGRect.init(dictionaryRepresentation:(eachPokerStarsWindowInfo["kCGWindowBounds"] as! CFDictionary)) ?? CGRect()
            )
        }
        
        // Only with Tournament Table Window.
        guard let firstWindowInfo = tourneyWindows.first
        else { return nil }
        
        return firstWindowInfo
    }
    
    func isLobbyWindowInfo(_ windowInfoDictionary: [String:Any]) -> Bool
    {
        (
            (windowInfoDictionary["kCGWindowOwnerName"] as? String) == "PokerStarsEU" &&
            (windowInfoDictionary["kCGWindowName"] as? String)?.contains("Tournament") ?? false &&
            (windowInfoDictionary["kCGWindowName"] as? String)?.contains("Lobby") ?? false
        )
    }
    
    func isTableWindowInfo(_ windowInfoDictionary: [String:Any]) -> Bool
    {
        (
            (windowInfoDictionary["kCGWindowOwnerName"] as? String) == "PokerStarsEU" &&
            (windowInfoDictionary["kCGWindowName"] as? String)?.contains("Tournament") ?? false &&
            (windowInfoDictionary["kCGWindowName"] as? String)?.contains("Table") ?? false &&
            (windowInfoDictionary["kCGWindowName"] as? String)?.contains("Logged In") ?? false
        )
    }
    
    @objc func tick()
    {
        // Set (invoke `didSet`).
        firstTableWindowInfo = searchFirstTableWindowInfo()
        
        // Update if any
        if let tableWindowInfo = firstTableWindowInfo
        {
            // Callback.
            delegate?.windowTrackerDidUpdateTableWindowInfo(tableWindowInfo: tableWindowInfo)
        }
    }
}
