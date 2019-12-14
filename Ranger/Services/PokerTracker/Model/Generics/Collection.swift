//
//  Table.swift
//  Ranger
//
//  Created by Geri Borbás on 2019. 12. 09..
//  Copyright © 2019. Geri Borbás. All rights reserved.
//

import Foundation
import PostgresClientKit


protocol Collection
{
    
    
    associatedtype RowType: RowInitable
    
    
    var queryString: String { get }
    var rows: [RowType] { get set }
    
        
    mutating func fetch(connection: Connection?) throws
    func log()
}


extension Collection
{
    
    
    mutating func fetch(connection: Connection?) throws
    {
        // Only having connection.
        guard let connection = connection else
        {
            print("Can't fetch table, database not connected.")
            return
        }
        
        // Prepare.
        let query = try connection.prepareStatement(text: queryString)
        defer { query.close() }

        // Execute.
        let cursor = try query.execute(parameterValues: [])
        defer { cursor.close() }
        
        // Flush data.
        rows.removeAll()
        
        // Iterate rows.
        for eachResult in cursor
        {
            // Get.
            guard let eachRow = try? eachResult.get() else
            {
                print("Row is missing.")
                continue
            }
           
            // Parse.
            guard let eachRowInitable = try? RowType.init(row:eachRow) else
            {
                print("Could not parse LiveTourneyPlayer from row.")
                continue
            }
            
            // Collect.
            rows.append(eachRowInitable)
        }
    }
    
    func log()
    {
        // Log.
        for eachRow in rows
        { print(String(describing: eachRow)) }
    }
}
