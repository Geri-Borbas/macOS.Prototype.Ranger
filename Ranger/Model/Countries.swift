//
//  Model.Timezones.swift
//  Ranger
//
//  Created by Geri Borbás on 2020. 01. 23..
//  Copyright © 2020. Geri Borbás. All rights reserved.
//

import Foundation

    
struct Countries: Codable
{
    
    
    let countries: [Country]
    
    
    struct Country: Codable
    {
                
        
        let code: String
        let name: String
        let capital: String?
        let latitude: Double
        let longitude: Double
        let timezoneIdentifiers: [String]
        
        
        var averageTimezone: TimeZone?
        {
            let timezones = timezoneIdentifiers.map{ eachTimezoneIdentifier in TimeZone(identifier: eachTimezoneIdentifier) }
            let averageSecondsFromGMT = timezones.reduce(0.0,
            {
                average, eachTimezone in
                average + Double(eachTimezone?.secondsFromGMT() ?? 0) * (1.0 / Double(timezones.count))
            })
            return TimeZone(secondsFromGMT: Int(averageSecondsFromGMT))
        }
    }
    
    
    func country(for code: String) -> Country?
    { countries.filter{ eachCountry in eachCountry.code == code }.first }
    
    static func load() -> Countries
    {
        let path = Bundle.main.path(forResource: "Countries", ofType: "json") ?? ""
        let data = try! Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
        return try! JSONDecoder().decode(Countries.self, from: data)
    }
}
