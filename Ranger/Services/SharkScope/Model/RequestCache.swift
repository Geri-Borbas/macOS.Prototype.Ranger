//
//  RequestCache.swift
//  Ranger
//
//  Created by Geri Borbás on 2019. 12. 12..
//  Copyright © 2019. Geri Borbás. All rights reserved.
//

import Foundation


class RequestCache
{
    
    
    func cachedResponse<ResponseType: Decodable>(for urlComponents: URLComponents) -> ResponseType?
    {
        // Resolve file name.
        guard let cacheFileURL = cacheFileURL(for: urlComponents)
        else { return nil }
        
        // Load / Decode JSON.
        do
        {
            let data = try Data(contentsOf: cacheFileURL)
            let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromBadgerFish
                decoder.dateDecodingStrategy = .millisecondsSince1970
            let response = try decoder.decode(ResponseType.self, from: data)
            return response
        }
        catch
        {
            print("Could not load / decode cache. \(error)")
            return nil
        }
    }
    
    func cacheFolderURL(for urlComponents: URLComponents) -> URL?
    {
        // Resolve Documents directory.
        guard let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
            else { return nil }
        
        
        
        // Parse subfolder (or fallback to no subfolder) without api path components.
        let pathURL = URL(string: urlComponents.percentEncodedPath.replacingOccurrences(of: "/api/searcher/", with: "")) ?? URL(string: "")!
        let pathFolder = pathURL.deletingLastPathComponent()
        let cacheFolderURL = documentsDirectory.appendingPathComponent(pathFolder.path, isDirectory: true)
        
        // Create folder (if needed).
        do { try FileManager.default.createDirectory(at: cacheFolderURL, withIntermediateDirectories: true, attributes: nil) }
        catch { print("Could not create cache folder. \(error)") }
        
        return cacheFolderURL
    }
    
    func cacheFileURL(for urlComponents: URLComponents) -> URL?
    {
        // Try to resolve folder.
        guard let cacheFolderURL = cacheFolderURL(for: urlComponents)
        else { return nil }
        
        // Parse file name.
        let pathURL = URL(string: urlComponents.percentEncodedPath) ?? URL(string: "")!
        let pathFileName = pathURL.lastPathComponent + "?" + (urlComponents.percentEncodedQuery ?? "")
        
        // Assemble file name.
        let cacheFileURL = cacheFolderURL.appendingPathComponent(pathFileName).appendingPathExtension("json")
        
        return cacheFileURL
    }
}
