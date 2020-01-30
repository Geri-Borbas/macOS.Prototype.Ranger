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
    
    
    let updatesPerSecond = 60.0
    let trackedProcesses: [String] =
    [
        "Ranger",
        "PokerStarsEU"
    ]
    
    
    var tableWindowInfos: [TableWindowInfo] = []
    weak var delegate: TableTrackerDelegate?
    
    
    // MARK: - Lifecycle
        
    func start()
    {
        // Invoke Screen Recording Privacy dialog (if not bypassed by simulation mode).
        if (true)
        { CGWindowListCreateImage(CGRect.zero, .optionOnScreenOnly, kCGNullWindowID, .nominalResolution) }
        
        // Kickoff timer.
        let interval = 1.0 / updatesPerSecond
        let timer = Timer(timeInterval: interval, target: self, selector: #selector(self.tick), userInfo: nil, repeats: true)
        RunLoop.current.add(timer, forMode: RunLoop.Mode.common)
    }
    
    
    // MARK: - Window lookup
    
    func lookupTableWindowInfos() -> [TableWindowInfo]
    {
        // Get window info list.
        let windowInfoList = CGWindowListCopyWindowInfo(
            CGWindowListOption(arrayLiteral: .excludeDesktopElements, .optionOnScreenOnly),
            kCGNullWindowID
        ) as! [[String:Any]]
        
        // Filter to table windows.
        return windowInfoList.filter
        {
            (eachWindowInfo: [String:Any]) in
            isTableWindowInfo(eachWindowInfo)
        }
        .map
        {
            eachPokerStarsWindowInfo in
            
            // Get index in window info list.
            let eachIndex = windowInfoList.firstIndex
            {
                eachWindowInfo in
                eachWindowInfo["kCGWindowNumber"] as! Int == eachPokerStarsWindowInfo["kCGWindowNumber"] as! Int
            } ?? -1
            
            return TableWindowInfo(
                name: eachPokerStarsWindowInfo["kCGWindowName"] as! String,
                number: eachPokerStarsWindowInfo["kCGWindowNumber"] as! Int,
                index: eachIndex,
                bounds: CGRect.init(dictionaryRepresentation:(eachPokerStarsWindowInfo["kCGWindowBounds"] as! CFDictionary)) ?? CGRect()
            )
        }
    }
    
    func isLobbyWindowInfo(_ windowInfoDictionary: [String:Any]) -> Bool
    {
        guard
            let ownerName = windowInfoDictionary["kCGWindowOwnerName"] as? String,
            let name = (windowInfoDictionary["kCGWindowName"] as? String)
        else { return false }
        
        return (
            ownerName.contained(in: trackedProcesses) &&
            name.contains(each: ["Tournament", "Lobby"])
        )
    }
    
    func isTableWindowInfo(_ windowInfoDictionary: [String:Any]) -> Bool
    {
        guard
            let ownerName = windowInfoDictionary["kCGWindowOwnerName"] as? String,
            let name = (windowInfoDictionary["kCGWindowName"] as? String)
        else { return false }
        
        return (
            ownerName.contained(in: trackedProcesses) &&
            name.contains(each: ["Tournament", "Table", "Logged In"])
        )
    }
    
    @objc func tick()
    {
        // Lookup.
        let currentTableWindowInfos = lookupTableWindowInfos()
        
        // Lookup removals.
        tableWindowInfos.forEach
        {
            eachTableWindowInfo in
            guard currentTableWindowInfos.contains(eachTableWindowInfo)
            else
            {
                // Not contained anymore, tracking stopped.
                delegate?.windowTrackerDidStopTrackingTable(tableWindowInfo: eachTableWindowInfo)
                return
            }
        }
        
        // Lookup insertation.
        currentTableWindowInfos.forEach
        {
            eachCurrentTableWindowInfo in
            guard tableWindowInfos.contains(eachCurrentTableWindowInfo)
            else
            {
                // Not yet contained, start tracking.
                delegate?.windowTrackerDidStartTrackingTable(tableWindowInfo: eachCurrentTableWindowInfo)
                return
            }
        }
        
        // Update if any.
        tableWindowInfos.forEach
        {
            eachTableWindowInfo in
            if
                let eachCurrentTableWindowInfo = currentTableWindowInfos.filter({ $0 == eachTableWindowInfo }).first,
                eachCurrentTableWindowInfo.isUpdated(comparedTo: eachTableWindowInfo)
            { delegate?.windowTrackerDidUpdateTableWindowInfo(tableWindowInfo: eachCurrentTableWindowInfo) }
        }
        
        // Set.
        tableWindowInfos = currentTableWindowInfos
    }
}
