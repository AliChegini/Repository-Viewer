//
//  RepoViewerClient.swift
//  RepositoryViewer
//
//  Created by Ehsan on 12/08/2018.
//  Copyright © 2018 Ali C. All rights reserved.
//

import Foundation

class RepoViewerAPIClient {
    
    // Example API call
    // https://api.github.com/repositories?client_id=bf645279e7f46a051182&client_secret=b8b7c8ecd5dd75c56c99d54810c1591a661e3a53
    // Client ID: bf645279e7f46a051182
    // Client Secret: b8b7c8ecd5dd75c56c99d54810c1591a661e3a53
    
    
    lazy var fullPackURL: URL = {
        return URL(string: "https://api.github.com/repositories?client_id=bf645279e7f46a051182&client_secret=b8b7c8ecd5dd75c56c99d54810c1591a661e3a53")!
        // I used the bang operator to force unwrap intentionally, becasue
        // I want the app to crash at this point if URL is not constructed correctly
    }()
    
    lazy var singlePackURL: URL = {
        return URL(string: "https://api.github.com/repositories?client_id=bf645279e7f46a051182&client_secret=b8b7c8ecd5dd75c56c99d54810c1591a661e3a53")!
        // I used the bang operator to force unwrap intentionally, becasue
        // I want the app to crash at this point if URL is not constructed correctly
    }()
    
    
    
    let downloader = JSONDownloader()
    
    // method to get full pack of repositories
    func getFullPack(completionHandler completion: @escaping (Data?, RepoViewerErrors?) -> Void) {
        let request = URLRequest(url: fullPackURL)
        let task = downloader.dataTask(with: request) { data, error in
            guard let data = data else {
                completion(nil, error)
                return
            }
            completion(data, nil)
        }
        task.resume()
    }
    
    // method to get full info for a single repository using its url
    func getSinglePack(url: RepositoryURL, completionHandler completion: @escaping (Data?, RepoViewerErrors?) -> Void) {
        guard let readyStringURL = url.url else {
            return
        }
        let readyURL = URL(string: readyStringURL)!
        
        let request = URLRequest(url: readyURL)
        let task = downloader.dataTask(with: request) { data, error in
            guard let data = data else {
                completion(nil, error)
                return
            }
            completion(data, nil)
        }
        task.resume()
    }
    
    
}






