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
    
    
    var tableWindowInfos: [TableWindowInfo] = []
    weak var delegate: TableTrackerDelegate?
    
    
    // MARK: - Lifecycle
        
    func start()
    {
        // Invoke Screen Recording Privacy dialog (if not bypassed by simulation mode).
        if (true)
        { CGWindowListCreateImage(CGRect.zero, .optionOnScreenOnly, kCGNullWindowID, .nominalResolution) }
        
        // Kickoff timer.
        let interval = 1.0 / 60.0
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
        }.sorted()
    }
    
    func isLobbyWindowInfo(_ windowInfoDictionary: [String:Any]) -> Bool
    {
        let ownerName = windowInfoDictionary["kCGWindowOwnerName"] as? String
        let name = (windowInfoDictionary["kCGWindowName"] as? String)
        
        return (
            (ownerName == "PokerStarsEU" || ownerName == "Ranger") &&
            name?.contains("Tournament") ?? false &&
            name?.contains("Lobby") ?? false
        )
    }
    
    func isTableWindowInfo(_ windowInfoDictionary: [String:Any]) -> Bool
    {
        let ownerName = windowInfoDictionary["kCGWindowOwnerName"] as? String
        let name = (windowInfoDictionary["kCGWindowName"] as? String)
        
        return (
            (ownerName == "PokerStarsEU" || ownerName == "Ranger") &&
            name?.contains("Tournament") ?? false &&
            name?.contains("Table") ?? false // &&
            // name?.contains("Logged In") ?? false
        )
    }
    
    @objc func tick()
    {
        // Lookup.
        let currentTableWindowInfos = lookupTableWindowInfos()
        
        // Report any change.
        currentTableWindowInfos.difference(from: tableWindowInfos).forEach
        {
            eachChange in
            switch eachChange
            {
                case .insert(_, let eachTableWindowInfo, _):
                    delegate?.windowTrackerDidStartTrackingTable(tableWindowInfo: eachTableWindowInfo)
                
                case .remove(_, let eachTableWindowInfo, _):
                    delegate?.windowTrackerDidStopTrackingTable(tableWindowInfo: eachTableWindowInfo)
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
