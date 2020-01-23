//
//  CountriesTests.swift
//  RangerTests
//
//  Created by Geri Borbás on 2020. 01. 10..
//  Copyright © 2020. Geri Borbás. All rights reserved.
//

import XCTest


class CountriesTests: XCTestCase
{

    
    func decodeCountries() throws -> Countries
    {
        let path = Bundle.main.path(forResource: "Countries", ofType: "json") ?? ""
        let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
        return try JSONDecoder().decode(Countries.self, from: data)
    }
    
    func copy(string: String?)
    {
        // Copy to clipboard (for easy inspection).
        NSPasteboard.general.declareTypes([NSPasteboard.PasteboardType.string], owner: nil)
        NSPasteboard.general.setString(string ?? "", forType: NSPasteboard.PasteboardType.string)
    }
    
    func testDecoding()
    {
        do
        { let _ = try decodeCountries() }
        catch
        { XCTFail(String(describing: error)) }
    }

    func testCoding()
    {
        do
        {
            // Decode.
            let countries = Countries.load()
            
            // Encode.
            let encoder = JSONEncoder()
                encoder.outputFormatting = [.sortedKeys, .prettyPrinted]
            let encodedData = try encoder.encode(countries)
            let encodedString = String(data: encodedData, encoding: .utf8)
            
            // Copy to clipboard (for easy inspection).
            copy(string: encodedString)
        }
        catch
        {
            XCTFail(String(describing: error))
        }
    }
    
    func testTimezoneIdentifiers()
    {
        // Decode.
        let countries = Countries.load()
        
        var log = ""
        countries.countries.forEach
        {
            eachCountry in
            
            log += "\(eachCountry.name)\n"
            eachCountry.timezoneIdentifiers.forEach
            {
                eachTimezoneIdentifier in
                
                // Assert.
                guard let eachTimezone = TimeZone(identifier: eachTimezoneIdentifier)
                else
                {
                    XCTFail("TimeZone(identifier: \"\(eachTimezoneIdentifier)\") failed.")
                    return
                }
                
                log += "\(eachTimezoneIdentifier): \(eachTimezone.secondsFromGMT())\n"
            }
            
        }

        // Copy to clipboard (for easy inspection).
        copy(string: log)
        
    }
    
    func testCountryForCode()
    {
        guard let countries = try? decodeCountries()
        else { return }
        
        XCTAssertNotNil(countries.country(for: "US"))
        XCTAssertNil(countries.country(for: "-"))
    }
    
    func testAverageTimezones()
    {
        // Decode.
        let countries = Countries.load()
        
        XCTAssertEqual(
            18720,
            countries.country(for: "KZ")!.averageTimezone?.secondsFromGMT()
        )
        
        XCTAssertEqual(
            48180, // Actual average is 48150, `TimeZone(secondsFromGMT:)` seems to do some additional rounding
            countries.country(for: "NZ")!.averageTimezone?.secondsFromGMT()
        )
        
        XCTAssertEqual(
            -23220, // Actual average is -23236, `TimeZone(secondsFromGMT:)` seems to do some additional rounding
            countries.country(for: "MX")!.averageTimezone?.secondsFromGMT()
        )
        
        XCTAssertEqual(
            12180, //  Actual average is 12150, `TimeZone(secondsFromGMT:)` seems to do some additional rounding
            countries.country(for: "RU")!.averageTimezone?.secondsFromGMT()
        )
    }
}
