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


class PokerTracker
{
    
    
    var connection:Connection?
    
    var liveTourneyTableCollection:LiveTourneyTableCollection?
    var liveTourneyPlayerCollection:LiveTourneyPlayerCollection?
    var basicPlayerStatisticsCollection:BasicPlayerStatisticsCollection?
    

    init()
    {
        liveTourneyPlayerCollection = LiveTourneyPlayerCollection()
        liveTourneyTableCollection = LiveTourneyTableCollection()
        basicPlayerStatisticsCollection = BasicPlayerStatisticsCollection()
        
        connect()
    }
    
    func connect()
    {
        // Load configuration.
        let configuration = PokerTracker.Configuration.load()
        
        // Set configuration.
        var connectionConfiguration = PostgresClientKit.ConnectionConfiguration()
        connectionConfiguration.host = configuration.host
        connectionConfiguration.database = configuration.database + " Snapshot"
        connectionConfiguration.port = configuration.port
        connectionConfiguration.user = configuration.user
        connectionConfiguration.ssl = configuration.ssl
        connectionConfiguration.credential = .md5Password(password: configuration.password)
        
        // Log.
        // Postgres.logger.level = .all

        // Connect.
        do
        {
            connection = try PostgresClientKit.Connection(configuration: connectionConfiguration)
        }
        catch let error as NSError
        {
            print("Connection error: \(error)")
            connection?.close()
        }
        
        print("Connected to database.")
    }
    
    func fetchLiveData() throws
    {
        try liveTourneyPlayerCollection?.fetch(connection:connection)
        try liveTourneyTableCollection?.fetch(connection:connection)
        try basicPlayerStatisticsCollection?.fetch(connection:connection)
    }
    
    func fetchLiveTourneyPlayerCollection() throws
    { try liveTourneyPlayerCollection?.fetch(connection:connection) }
    
    func fetchLiveTourneyTableCollection() throws
    { try liveTourneyTableCollection?.fetch(connection:connection) }
    
    func fetchBasicPlayerStatisticsCollection() throws
    { try basicPlayerStatisticsCollection?.fetch(connection:connection) }
    
    func log()
    {
        liveTourneyPlayerCollection?.log()
        liveTourneyTableCollection?.log()
        basicPlayerStatisticsCollection?.log()
    }
}

