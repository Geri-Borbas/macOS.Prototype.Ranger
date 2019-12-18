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
    
    
    static var log: Bool = false
    public var user: UserInfo?
    
    
    public func fetch<RequestType: Request>(_ request: RequestType,
                                            completion: @escaping (Result<RequestType.RootResponseType, RequestError>) -> Void) where RequestType.RootResponseType: RootResponse
    {
        // Lookup cache first.
        let cache = RequestCache()
        if let cachedResponse: RequestType.RootResponseType = cache.cachedResponse(for: request.path, parameters: request.parameters), request.useCache
        {
            print("Found JSON cache, skip request.")
            return completion(.success(cachedResponse))
        }
        else
        {
            print("Don't use JSON cache.")
        }
        
        // Create URL Components.
        var urlComponents = URLComponents()
            urlComponents.scheme = "https"
            urlComponents.host = "sharkscope.com"
            urlComponents.path = "/api/searcher/" + request.path
            urlComponents.queryItems = request.parameters.map { eachElement in URLQueryItem(name: eachElement.key, value: eachElement.value) }
        
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
            catch { return completion(.failure(RequestError.jsonSerializationError(error))) }
            
            // Log.
            if (SharkScope.log)
            {
                print("JSON: \(JSON)")
            }

            // Cache.
            if let cacheFileURL = cache.cacheFileURL(for: request.path, parameters: request.parameters)
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
            {
                let decoder = JSONDecoder()
                    decoder.keyDecodingStrategy = .convertFromBadgerFish
                    decoder.dateDecodingStrategy = .millisecondsSince1970
                _decodedResponse = try decoder.decode(RequestType.RootResponseType.self, from: data)
            }
            catch { return completion(.failure(RequestError.jsonDecodingError(error))) }
            
            // Only with JSON data.
            guard let decodedResponse = _decodedResponse
            else { return completion(.failure(RequestError.noJSONData)) }
            
            // Retain latest `UserInfo`.
            self.user = decodedResponse.Response.UserInfo
            
            // Return on the main thread.
            DispatchQueue.main.async()
            {
                completion(.success(decodedResponse))
            }
        }

        task.resume()
    }
    
    public func test()
    {
        testRequest()
    }
    
    func testRequest()
    {
        let request = PlayerSummaryRequest(network: "PokerStars", player: "Borbas.Geri")
        fetch(request, completion:
        {
            result in
            
            switch result
            {
                case .success(let response):
                    
                    let playerSummaryResponse = response.Response
                    let statistics = playerSummaryResponse.PlayerResponse.PlayerView.Player.Statistics
                    
                    // Player.
                    print("metadataHash: \(playerSummaryResponse.metadataHash)")
                    print("Username: \(playerSummaryResponse.UserInfo.Username)")
                    print("freeSearchesRemaining: \(playerSummaryResponse.UserInfo.Subscriptions.freeSearchesRemaining.value)")
                    print("totalSearchesRemaining: \(playerSummaryResponse.UserInfo.Subscriptions.totalSearchesRemaining.value)")
                    print("expirationDate: \(playerSummaryResponse.UserInfo.Subscriptions.Subscription.expirationDate.value)")
                    print("Regions.first.name: \(playerSummaryResponse.UserInfo.Regions.first?.name ?? "")")
                    
                    // Statistics.
                    print("Ability: \(statistics.Ability)")
                    print("AchievementPoints: \(statistics.AchievementPoints)")
                    print("ActiveDayCount: \(statistics.ActiveDayCount)")
                    print("AvEntrants: \(statistics.AvEntrants)")
                    print("AvGameDuration: \(statistics.AvGameDuration)")
                    print("AvGamesPerDay: \(statistics.AvGamesPerDay)")
                    print("AvProfit: \(statistics.AvProfit)")
                    print("AvROI: \(statistics.AvROI)")
                    print("AvStake: \(statistics.AvStake)")
                    print("Bankroll: \(statistics.Bankroll)")
                    print("Best100StreakAvProfit: \(statistics.Best100StreakAvProfit)")
                    print("Best500StreakAvProfit: \(statistics.Best500StreakAvProfit)")
                    print("BreakEvenDays: \(statistics.BreakEvenDays)")
                    print("Cashes: \(statistics.Cashes)")
                    print("Count: \(statistics.Count)")
                    print("FinshesEarly: \(statistics.FinshesEarly)")
                    print("FinshesEarlyMiddle: \(statistics.FinshesEarlyMiddle)")
                    print("FinshesLate: \(statistics.FinshesLate)")
                    print("FinshesMiddle: \(statistics.FinshesMiddle)")
                    print("FinshesMiddleLate: \(statistics.FinshesMiddleLate)")
                    print("FirstGameDate: \(statistics.FirstGameDate)")
                    print("ITM: \(statistics.ITM)")
                    print("LastGameDate: \(statistics.LastGameDate)")
                    print("LosingDays: \(statistics.LosingDays)")
                    print("MaxCashingStreak: \(statistics.MaxCashingStreak)")
                    print("MaxLosingStreak: \(statistics.MaxLosingStreak)")
                    print("MaxWinningStreak: \(statistics.MaxWinningStreak)")
                    print("MostGamesInDay: \(statistics.MostGamesInDay)")
                    print("PTLBPoints: \(statistics.PTLBPoints)")
                    print("PercentFieldBeaten: \(statistics.PercentFieldBeaten)")
                    print("Profit: \(statistics.Profit)")
                    print("Rake: \(statistics.Rake)")
                    print("Stake: \(statistics.Stake)")
                    print("TotalROI: \(statistics.TotalROI)")
                    print("Stake: \(statistics.Stake)")
                    print("TournamentWins: \(statistics.TournamentWins)")
                    print("TurboRatio: \(statistics.TurboRatio)")
                    print("UserNote: \(statistics.UserNote)")
                    print("WinningDays: \(statistics.WinningDays)")
                    print("Worst100StreakAvProfit: \(statistics.Worst100StreakAvProfit)")
                    
                    // Computed statistics.
                    print("EstimatedStake: \(statistics.EstimatedStake)")
                    print("AvHoursPerDay: \(statistics.AvHoursPerDay)")
                    
                    break
                
                case .failure(let error):
                
                    print("error: \(error)")
                    
                    break
            }
        })
    }
}
