//
//  SharkScope.swift
//  Ranger
//
//  Created by Geri Borbás on 2019. 12. 09..
//  Copyright © 2019. Geri Borbás. All rights reserved.
//

import Foundation
       
    
public indirect enum Error: Swift.Error
{
    case urlCreationError
    case endpointNotExist
    case apiError(_: Swift.Error)
    case responseError
    case noData
    case noStringData
    case jsonSerializationError(_: Swift.Error)
    case decodingError(_: Swift.Error)
    case noDecodedData
}


public struct Service
{
       
    
    static var errorDomain: String = "SharkScope"
    static var basePath: String = "/api/searcher/"
    static var log: Bool = false
    
    
    public init()
    { }
    
    
    // MARK: - Networking
    
    public func fetch<RequestType: ApiRequest>(
        _ request: RequestType,
        completion: @escaping (Result<RequestType.ApiResponseType, SharkScope.Error>) -> Void
    )
    {
        
        // Create URL Components.
        var urlComponents = URLComponents()
            urlComponents.scheme = "https"
            urlComponents.host = "sharkscope.com"
            urlComponents.path = Service.basePath + request.path
            urlComponents.queryItems = request.parameters.map { eachElement in URLQueryItem(name: eachElement.key, value: eachElement.value) }
        
        // Lookup cache first.
        let cache = ApiRequestCache()
        if let cachedResponse: RequestType.ApiResponseType = cache.cachedResponse(for: urlComponents), request.useCache
        {
            print("Found file cache, skip request.")
            return completion(.success(cachedResponse))
        }
        else
        {
            print("Don't use file cache.")
        }
        
        // Create URL.
        guard let url: URL = urlComponents.url
        else { return completion(.failure(SharkScope.Error.urlCreationError)) }
        
        // Request.
        var urlRequest = URLRequest(url: url)
            urlRequest.httpMethod = "GET"
        
        // Load configuration.
        let configuration = Configuration.load()
        
        // Headers.
        urlRequest.setValue(request.contentType.rawValue, forHTTPHeaderField: "Accept")
        urlRequest.setValue(configuration.Username, forHTTPHeaderField: "Username")
        urlRequest.setValue(configuration.Password, forHTTPHeaderField: "Password")
        urlRequest.setValue(configuration.UserAgent, forHTTPHeaderField: "User-Agent")

                   
        // Log.
        if (Service.log)
        {
            print("urlRequest.url: \(urlRequest.url!)")
        }
        
        // Create task.
        let task = URLSession.shared.dataTask(with: urlRequest)
        {
            data, response, error -> Void in
            
            // Only without error.
            if let error = error
            { return completion(.failure(SharkScope.Error.apiError(error))) }
                
            // Only having response.
            guard let response = response as? HTTPURLResponse
            else { return completion(.failure(SharkScope.Error.responseError)) }
                
            // Only having data.
            guard let data = data
            else { return completion(.failure(SharkScope.Error.noData)) }
                
            // Only with string data.
            guard let dataString = String(data: data, encoding: .utf8)
            else { return completion(.failure(SharkScope.Error.noStringData)) }
                       
            // Log.
            if (Service.log)
            {
                print("statusCode: \(response.statusCode)")
                print("dataString: \(dataString)")
            }
            
            // Decode.
            var decodedResponseOrNil: RequestType.ApiResponseType?
            do
            { decodedResponseOrNil = try RequestType.ApiResponseType.self(from: dataString) }
            catch { return completion(.failure(SharkScope.Error.decodingError(error))) }
            
            // Only with decoded data.
            guard let decodedResponse = decodedResponseOrNil
            else { return completion(.failure(SharkScope.Error.noDecodedData)) }
            
            // Cache.
            if let cacheFileURL = cache.cacheFileURL(for: urlComponents)
            {
                // Create string representation (pretty JSON or CSV).
                var stringRepresentation: String?
                do { stringRepresentation = try decodedResponse.stringRepresentation(from: data) }
                catch { print("Could not get string representation. \(error)") }
                
                // Save.
                do { try stringRepresentation?.write(to: cacheFileURL, atomically: true, encoding: String.Encoding.utf8) }
                catch { print("Could not cahce file. \(error)") }
            }
                        
            // Return on the main thread.
            DispatchQueue.main.async()
            { completion(.success(decodedResponse)) }
        }

        task.resume()
    }
    
    
    // MARK: - Requests
    
    public func fetch(player playerName: String,
                      completion: @escaping (Result<(playerSummary: PlayerSummary, activeTournaments: ActiveTournaments), SharkScope.Error>) -> Void)
    {
        let network = "PokerStars"        
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
    
    public var status: String
    { return "No automatic SharkScope status implemented at the moment." }
}
