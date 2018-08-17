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
    
    // array to hold constructed string urls for 10 * 100(API limit) repos
    
    // 10 * 100 = 1000
    let numberOfHundredPacks = 0     // 10 - 1 = 9 because of Zero
    
    fileprivate let clientIDAndSecret = "client_id=bf645279e7f46a051182&client_secret=b8b7c8ecd5dd75c56c99d54810c1591a661e3a53"
    
    
    lazy var fullPackURL: URL = {
        return URL(string: "https://api.github.com/repositories?\(clientIDAndSecret)")!
    }()
    
    
    let downloader = JSONDownloader()
    
    
    // Each request to https://api.github.com/repositories will give 100 repositories at max due to API limitation
    // Assumption I made is to work with only 1000 repos, hence the endpoint should be called 10 times
    func constructStringURLs() -> [String] {
        var superArray: [String] = []
        
        for pageNumber in 0...numberOfHundredPacks {
            // endpoint only accept one paramter known as "since" to return pack of 100 repos
            // phrase "&since=pageNumber*100" should be appended to the url to get more than 100 repos
            // since=0 will give 0 to 100 repos, since=100 will give 101 to 200 and so on
            let since = pageNumber * 100
            let phrase = "&since=\(since)"
            
            var urlToString = fullPackURL.absoluteString
            urlToString.append(phrase)
            superArray.append(urlToString)
        }
        return superArray
    }
    
    
    
    // method to get full pack of repositories
    func getFullPack(completionHandler completion: @escaping (Data?, RepoViewerErrors?) -> Void) {
        let array = constructStringURLs()
        
        for element in array {
            guard let url = URL(string: element) else {
                print("URL is not constructed properly")
                fatalError()
            }
            
            let request = URLRequest(url: url)
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
    
    
    // method to get full info for a single repository using its url
    func getSinglePack(url: RepositoryURL, completionHandler completion: @escaping (Data?, RepoViewerErrors?) -> Void) {
        guard let readyStringURL = url.url else {
            return
        }
        let readyURL = URL(string: readyStringURL)!
        print("url from inside getSinglePAck(): \(readyURL) ")
        
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






