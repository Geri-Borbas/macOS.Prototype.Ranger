//
//  Table.swift
//  Ranger
//
//  Created by Geri Borbás on 2019. 12. 09..
//  Copyright © 2019. Geri Borbás. All rights reserved.
//

import Foundation
import PostgresClientKit


protocol Collection: class
{
    
    
    associatedtype RowType: RowInitable
    
    
    var queryString: String { get }
    var rows: [RowType] { get set }
    
    
    func fetch(connection: Connection?, queryParameters: [String]) throws
    func log()
}


extension Collection
{
    
    
    func fetch(connection: Connection?, queryParameters: [String] = []) throws
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

        print(queryString)
        print(queryParameters)
        
        // Execute.
        let cursor = try query.execute(parameterValues: queryParameters)
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
