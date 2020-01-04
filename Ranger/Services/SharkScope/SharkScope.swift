//
//  SharkScope.swift
//  Ranger
//
//  Created by Geri Borbás on 2019. 12. 09..
//  Copyright © 2019. Geri Borbás. All rights reserved.
//

import Foundation
import XMLCoder


enum RequestError: Error
{
    case urlCreationError
    case endpointNotExist
    case apiError(_: Error)
    case responseError
    case noData
    case noStringData
    case jsonSerializationError(_: Error)
    case jsonDecodingError(_: Error)
    case noJSONData
}


class SharkScope
{
    
    
    static var errorDomain: String = "SharkScope"
    static var basePath: String = "/api/searcher/"
    static var log: Bool = false
    public var user: UserInfo?
    
    
    // MARK: - Networking
    
    public func fetch<RequestType: Request>(_ request: RequestType,
                                            completion: @escaping (Result<RequestType.RootResponseType, RequestError>) -> Void) where RequestType.RootResponseType: RootResponse
    {
        
        // Create URL Components.
        var urlComponents = URLComponents()
            urlComponents.scheme = "https"
            urlComponents.host = "sharkscope.com"
            urlComponents.path = SharkScope.basePath + request.path
            urlComponents.queryItems = request.parameters.map { eachElement in URLQueryItem(name: eachElement.key, value: eachElement.value) }
        
        // Lookup cache first.
        let cache = RequestCache()
        if let cachedResponse: RequestType.RootResponseType = cache.cachedResponse(for: urlComponents), request.useCache
        {
            // print("Found JSON cache, skip request.")
            return completion(.success(cachedResponse))
        }
        else
        {
            // print("Don't use JSON cache.")
        }
        
        // Create URL.
        guard let url: URL = urlComponents.url
        else { return completion(.failure(RequestError.urlCreationError)) }
        
        // Request.
        var urlRequest = URLRequest(url: url)
            urlRequest.httpMethod = "GET"
        
        // Load configuration.
        let configuration = SharkScope.Configuration.load()
        
        // Headers.
        urlRequest.setValue("application/json", forHTTPHeaderField: "Accept")
        urlRequest.setValue(configuration.Username, forHTTPHeaderField: "Username")
        urlRequest.setValue(configuration.Password, forHTTPHeaderField: "Password")
        urlRequest.setValue(configuration.UserAgent, forHTTPHeaderField: "User-Agent")

                   
        // Log.
        if (SharkScope.log)
        {
            print("urlRequest.url: \(urlRequest.url!)")
        }
        
        // Create task.
        let task = URLSession.shared.dataTask(with: urlRequest)
        {
            data, response, error -> Void in
            
            // Only without error.
            if let error = error
            { return completion(.failure(RequestError.apiError(error))) }
                
            // Only having response.
            guard let response = response as? HTTPURLResponse
            else { return completion(.failure(RequestError.responseError)) }
                
            // Only having data.
            guard let data = data
            else { return completion(.failure(RequestError.noData)) }
                
            // Only with string data.
            guard let dataString = String(data: data, encoding: .utf8)
            else { return completion(.failure(RequestError.noStringData)) }
                       
            // Log.
            if (SharkScope.log)
            {
                print("statusCode: \(response.statusCode)")
                print("dataString: \(dataString)")
            }
            
            // JSON.
            var JSON: Dictionary<String, AnyObject> = [:]
            do { JSON = try JSONSerialization.jsonObject(with: data) as! Dictionary<String, AnyObject> }
            catch
            {
                // Return on the main thread.
                DispatchQueue.main.async()
                { completion(.failure(RequestError.jsonSerializationError(error))) }
                
                return
            }
            
            // Log.
            if (SharkScope.log)
            {
                print("JSON: \(JSON)")
            }
            
            // Create JSON decoder.
            let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromBadgerFish
                decoder.dateDecodingStrategy = .millisecondsSince1970
            
            // Try to decode error response if any.
            if let decodedErrorResponse = try? decoder.decode(ApiError.self, from: data)
            {
                // Return error on the main thread.
                DispatchQueue.main.async()
                { completion(.failure(RequestError.apiError(decodedErrorResponse.NSError(domain: SharkScope.errorDomain)))) }
                return
            }
            
            // Cache.
            if let cacheFileURL = cache.cacheFileURL(for: urlComponents)
            {
                // Create pretty JSON.
                var _JSONdata: Data?
                do { _JSONdata = try JSONSerialization.data(withJSONObject: JSON, options: [.prettyPrinted]) }
                catch { print("Could not serialize JSON. \(error)") }
                
                // Create String (if any JSON).
                let JSONdata = _JSONdata ?? Data()
                let JSONstring = String(data: JSONdata, encoding: String.Encoding.utf8)!
                
                // Save.
                do { try JSONstring.write(to: cacheFileURL, atomically: true, encoding: String.Encoding.utf8) }
                catch { print("Could not cahce file. \(error)") }
            }
            
            // Decode.
            var _decodedResponse: RequestType.RootResponseType?
            do
            { _decodedResponse = try decoder.decode(RequestType.RootResponseType.self, from: data) }
            catch { return completion(.failure(RequestError.jsonDecodingError(error))) }
            
            // Only with JSON data.
            guard let decodedResponse = _decodedResponse
            else { return completion(.failure(RequestError.noJSONData)) }
            
            // Retain latest `UserInfo`.
            self.user = decodedResponse.Response.UserInfo
            
            // Return on the main thread.
            DispatchQueue.main.async()
            { completion(.success(decodedResponse)) }
        }

        task.resume()
    }
    
    
    // MARK: - Requests
    
    func fetch(player playerName: String,
               completion: @escaping (Result<(playerSummary: PlayerSummary, activeTournaments: ActiveTournaments), RequestError>) -> Void)
    {
        let network = "PokerStars"
        // let playerName = "quAAsar"
        // let playerName = "g1anfar"
        // let playerName = "Eset93"
        // let playerName = "ScauHades"
        // let playerName = "Borbas.Geri"
        
        fetch(PlayerSummaryRequest(network: network, player: playerName), completion:
        {
            result in
            
            switch result
            {
                case .success(let playerSummary):
                    
                    self.fetch(ActiveTournamentsRequest(network: network, player: playerName).usingCache(), completion:
                    {
                        result in
                        
                        switch result
                        {
                            case .success(let activeTournaments):
                                
                                // Completion.
                                completion(.success((
                                    playerSummary: playerSummary,
                                    activeTournaments: activeTournaments
                                )))
                                
                                break
                            
                            case .failure(let error):
                            
                                // Error.
                                completion(.failure(error))
                                
                                break
                        }
                    })
                    
                    break
                
                case .failure(let error):
                
                    // Error.
                    completion(.failure(error))
                    
                    break
            }
        })
    }
    
    
    // MARK: - UI
    
    var status: String
    {
        guard let user = user
        else { return "Not logged in." }
        
        return String(format: "%d search remaining (logged in as %@).", user.RemainingSearches, user.Username)
    }
}
