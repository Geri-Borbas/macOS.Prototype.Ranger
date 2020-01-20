//
//  RequestCache.swift
//  Ranger
//
//  Created by Geri Borbás on 2019. 12. 12..
//  Copyright © 2019. Geri Borbás. All rights reserved.
//

import Foundation


public struct ApiRequestCache
{
        
    
    public init()
    { }
    
    func cachedResponse<RequestType: ApiRequest>(for request: RequestType) -> RequestType.ApiResponseType?
    {
        // Resolve file name.
        guard let cacheFileURL = cacheFileURL(for: request)
        else { return nil }
        
        // Load / Decode JSON.
        do
        {
            let data = try Data(contentsOf: cacheFileURL)
            let string = String(decoding: data, as: UTF8.self)
            let response = try RequestType.ApiResponseType.self(from: string)
            return response
        }
        catch
        {
            print("Could not load / decode cache. \(error)")
            return nil
        }
    }
    
    func cacheFolderURL<RequestType: ApiRequest>(for request: RequestType) -> URL?
    {
        // Resolve Documents directory.
        guard let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
        else { return nil }
                
        // Append path.
        let path = request.path.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        let pathURL = URL(string: path) ?? URL(string: "")!
        let pathFolder = pathURL.deletingLastPathComponent()
        let cacheFolderURL = documentsDirectory.appendingPathComponent(pathFolder.path, isDirectory: true)
        
        // Create folder (if needed).
        do { try FileManager.default.createDirectory(at: cacheFolderURL, withIntermediateDirectories: true, attributes: nil) }
        catch { print("Could not create cache folder. \(error)") }
        
        return cacheFolderURL
    }
    
    func cacheFileURL<RequestType: ApiRequest>(for request: RequestType) -> URL?
    {
        // Try to resolve folder.
        guard let cacheFolderURL = cacheFolderURL(for: request)
        else { return nil }
        
        // Encode parameters to query.
        let urlComponents = request.urlComponents
        
        // Parse file name.
        let pathURL = URL(string: urlComponents.percentEncodedPath) ?? URL(string: "")!
        
        // Append query if any.
        var querySuffix = ""
        if urlComponents.percentEncodedQuery != ""
        { querySuffix = "?" + (urlComponents.percentEncodedQuery ?? "") }
        
        // Determine extension (CSV has the extension already in path).
        var pathExtension: String = ""
        if (request.contentType == .JSON)
        { pathExtension = "json" }
        
        // Assemble file name.
        let cacheFileURL = cacheFolderURL.appendingPathComponent(pathURL.lastPathComponent + querySuffix).appendingPathExtension(pathExtension)
        
        return cacheFileURL
    }
    
    
    // MARK: - Public
    
    public func deleteTablesCache(for playerName: String)
    {
        // Create (fake) request.
        let request = ActiveTournamentsRequest(network: "PokerStars", player: playerName)
        
        // Resolve file name.
        guard let cacheFileURL = cacheFileURL(for: request)
        else { return }
        
        // Create folder (if needed).
        do { try FileManager.default.removeItem(at: cacheFileURL) }
        catch { print("Could not remove cache file. \(error)") }
    }
    
    public func deleteStatisticsCache(for playerName: String)
    {
        // Create (fake) request.
        let request = PlayerSummaryRequest(network: "PokerStars", player: playerName)
        
        // Resolve file name.
        guard let cacheFileURL = cacheFileURL(for: request)
        else { return }
        
        // Create folder (if needed).
        do { try FileManager.default.removeItem(at: cacheFileURL) }
        catch { print("Could not remove cache file. \(error)") }
    }
    
    public func cachedFiles(at path: String) -> [URL]?
    {
        // Resolve Documents directory.
        guard let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
        else { return [] }
        
        // Append path.
        let cacheFolderURL = documentsDirectory.appendingPathComponent(path, isDirectory: true)
        
        var cachedFileURLs: [URL]?
        do { cachedFileURLs = try FileManager.default.contentsOfDirectory(at: cacheFolderURL, includingPropertiesForKeys: nil) }
        catch { print(error.localizedDescription) }
        
        return cachedFileURLs
    }
}
