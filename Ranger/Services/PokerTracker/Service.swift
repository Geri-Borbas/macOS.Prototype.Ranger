//
//  PokerTracker.swift
//  Ranger
//
//  Created by Geri Borbás on 2019. 12. 08..
//  Copyright © 2019. Geri Borbás. All rights reserved.
//

import Foundation
import PostgresClientKit


// https://codewinsdotcom.github.io/PostgresClientKit/Docs/API/index.html

enum PokerTrackerError: Error
{
    case databaseNotConnected
    case rowIsMissing
}


enum PokerTracker
{

    
    class Service
    {
        
        
        var connection:Connection?
        

        init()
        { connect() }
        
        func connect()
        {
            // Load configuration.
            let configuration = Configuration.load()
            
            // Set configuration.
            var connectionConfiguration = PostgresClientKit.ConnectionConfiguration()
            connectionConfiguration.host = configuration.host
            connectionConfiguration.database = configuration.database
            connectionConfiguration.port = configuration.port
            connectionConfiguration.user = configuration.user
            connectionConfiguration.ssl = configuration.ssl
            connectionConfiguration.credential = .md5Password(password: configuration.password)
            
            // Log.
            // Postgres.logger.level = .all

            // Connect.
            do
            { connection = try PostgresClientKit.Connection(configuration: connectionConfiguration) }
            catch
            {
                print("Connection error: \(error)")
                connection?.close()
            }
        }
        
        func fetch<QueryType: Query>(_ query: QueryType) throws -> [QueryType.EntryType]
        {
            // Only having connection.
            guard let connection = connection else
            { throw PokerTrackerError.databaseNotConnected }
            
            // Prepare.
            let query = try connection.prepareStatement(text: query.string)
            defer { query.close() }
            
            // Execute.
            let cursor = try query.execute(parameterValues: [])
            defer { cursor.close() }
            
            // Flush data.
            var rows: [QueryType.EntryType] = []
            
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
                var eachRowInitable: QueryType.EntryType
                do
                { eachRowInitable = try QueryType.EntryType.init(row:eachRow) }
                catch
                {
                    print("Could not parse Entry from row. \(error)")
                    continue
                }
                
                // Collect.
                rows.append(eachRowInitable)
            }
            
            return rows
        }
    }

}
