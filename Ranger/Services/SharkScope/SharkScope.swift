//
//  SharkScope.swift
//  Ranger
//
//  Created by Geri Borbás on 2019. 12. 09..
//  Copyright © 2019. Geri Borbás. All rights reserved.
//

import Foundation
import XMLCoder


class SharkScope
{
    
    
    public func test()
    {
        let request = Request()
        request.fetch
        {
            result in
            
            switch result
            {
                case .success(let response):
                    
                    print("response.Response.metadataHash: \(response.Response.metadataHash)")
                    break
                
                case .failure(let error):
                
                    print("error: \(error)")
                    break
            }
        }
    }
    
    public func testXML()
    {
        // Get XML string.
        let xmlFilePath = Bundle.main.path(forResource: "VersionCheckResponse", ofType: "xml")
        guard let xmlString = try? String(contentsOfFile: xmlFilePath!, encoding: String.Encoding.utf8)
        else { return }
        
        print("xmlString: \(xmlString)")
        
        // Get XML data.
        guard let data = xmlString.data(using: .utf8) else { return }
        
        // Decode XML.
        do
        {
            let versionCheckResponse: VersionCheckResponse = try XMLDecoder().decode(VersionCheckResponse.self, from: data)
            
            // Log.
            print("versionCheckResponse.metadataHash: \(versionCheckResponse.metadataHash)")
            print("versionCheckResponse.timestamp: \(versionCheckResponse.timestamp)")
            print("versionCheckResponse.ErrorResponse.Error.id: \(versionCheckResponse.ErrorResponse.Error.id)")
            print("versionCheckResponse.UserInfo.Country: \(versionCheckResponse.UserInfo.Country)")
        }
        catch
        {
            print(error)
        }
        
        // http://www.sharkscope.com/api/searcher/networks/pokerstars/players/Borbas.Geri/
        // Each network name can be URL encoded (UTF-8) if it contains spaces. Skins can also be provided as network names.
        // The “Player name” path parameter must always be URL encoded (UTF-8).
    }
}
