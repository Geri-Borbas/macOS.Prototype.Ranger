//
//  JsonResponse.swift
//  SharkScope
//
//  Created by Geri Borbás on 2020. 01. 19..
//  Copyright © 2020. Geri Borbás. All rights reserved.
//

import Foundation


public protocol JsonResponse: ApiResponse
{ }

extension JsonResponse
{
    
    
    public init(from jsonString: String) throws
    {
        // Convert to bytes.
        let jsonData = jsonString.data(using: .utf8)!
        
        // Create JSON decoder.
        let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromBadgerFish
            decoder.dateDecodingStrategy = .millisecondsSince1970
        
        // Try to decode error response, and throw if any.
        if let decodedErrorResponse = try? decoder.decode(ApiError.self, from: jsonData)
        { throw decodedErrorResponse.NSError(domain: Service.errorDomain) }
        
        // Decode.
        self = try decoder.decode(Self.self, from: jsonData)
    }
    
    public func stringRepresentation(from data: Data) throws -> String
    {
        // Decode JSON to generic dictionary.
        var JSON: Dictionary<String, AnyObject> = [:]
        do { JSON = try JSONSerialization.jsonObject(with: data) as! Dictionary<String, AnyObject> }
        catch { throw SharkScope.Error.jsonSerializationError(error) }

        // Log.
        if (Service.log)
        { print("JSON: \(JSON)") }
        
        // Create pretty JSON from generic dictionary.
        var _JSONdata: Data?
        do { _JSONdata = try JSONSerialization.data(withJSONObject: JSON, options: [.prettyPrinted]) }
        catch { print("Could not serialize JSON. \(error)") }
        
        // Create String (if any JSON).
        let JSONdata = _JSONdata ?? Data()
        let JSONstring = String(data: JSONdata, encoding: String.Encoding.utf8)!
        
        // Spit up.
        return JSONstring
    }
}
