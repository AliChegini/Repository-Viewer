//
//  RepoViewerClient.swift
//  RepositoryViewer
//
//  Created by Ehsan on 12/08/2018.
//  Copyright © 2018 Ali C. All rights reserved.
//

import Foundation

// Client class to be used in Extractor ----

class RepoViewerAPIClient {
    
    // Example of API call
    // https://api.github.com/repositories?client_id=bf645279e7f46a051182&client_secret=b8b7c8ecd5dd75c56c99d54810c1591a661e3a53
    
    
    // DUE TO API LIMITATION totalRepos we can only make 5000 request per hour with basic authentication,
    // refer to https://developer.github.com/v3/#rate-limiting
    // setting the number of desired repositories
    static let totalRepos = 500
    // Each request to https://api.github.com/repositories will return 100 repositories at each page due to API limitation, endpoint only accept one paramter known as "since" to return pack of 100 repos per page
    // Note: because since=0 will include the first hundred, that's why pageNumberOfHundredPack is decreamented by 1
    let pageNumberOfHundredPack = (RepoViewerAPIClient.totalRepos / 100) - 1
    
    fileprivate static let clientIDAndSecret = "?client_id=bf645279e7f46a051182&client_secret=b8b7c8ecd5dd75c56c99d54810c1591a661e3a53"
    
    static let urlForHundredPack = "https://api.github.com/repositories\(clientIDAndSecret)"
    
    let downloader = JSONDownloader()
    
    // method to construct and prepare string urls with since parameter appended to them
    func constructStringURLs() -> [String] {
        var urlsWithSinceParam: [String] = []
        
        for pageNumber in 0...pageNumberOfHundredPack {
            // endpoint only accept one paramter known as "since" to return pack of 100 repos
            // phrase "&since=pageNumber*100" should be appended to the url to get the next 100 repos
            var since = 0
            if pageNumber == 0 {
                // since=0 will give repos from 1 to 101 because IDs starts @ 1
                since = 0
            } else {
                // since=101 will give 101 to 201, and so on
                since = pageNumber * 100 + 1
            }
            
            let phrase = "&since=\(since)"
            
            var urlToString = RepoViewerAPIClient.urlForHundredPack
            urlToString.append(phrase)
            urlsWithSinceParam.append(urlToString)
        }
        
        return urlsWithSinceParam
    }
    
    
    // method to get urls of 100 pack of repositories in each request
    // will be used as outer asynch call in Extractor class
    func getHundredPackOfURLs(completionHandler completion: @escaping (Data?, RepoViewerErrors?) -> Void) {
        let array = constructStringURLs()
        
        for element in array {
            guard let url = URL(string: element) else {
                print("URL is not constructed properly")
                return
            }
            
            let request = URLRequest(url: url)
            let task = downloader.dataTask(with: request) { data, error in
                guard let data = data else {
                    print("Error from getHundredPackOfURLs(): \(error.debugDescription)")
                    completion(nil, error)
                    return
                }
                completion(data, nil)
            }
            task.resume()
        }
        
    }
    
    
    // method to get full info for a single repository using its url
    // will be used as inner asynch call in Extractor class
    func getSingleRepositoryInfo(url: RepositoryURL, completionHandler completion: @escaping (Data?, RepoViewerErrors?) -> Void) {
        guard let stringURLUnwrapped = url.url else {
            print("from getSingleRepositoryInfo() string url is empty")
            return
        }
        // appending clientIDAndSecret to the url of each repo
        var stringURLWithSecret = stringURLUnwrapped
        stringURLWithSecret.append(RepoViewerAPIClient.clientIDAndSecret)
        
        guard let finalUrl = URL(string: stringURLWithSecret) else {
            print("URL is not constructed properly")
            return
        }
        
        let request = URLRequest(url: finalUrl)
        let task = downloader.dataTask(with: request) { data, error in
            guard let data = data else {
                print("Error from getSingleRepositoryInfo() \(error.debugDescription)")
                completion(nil, error)
                return
            }
            completion(data, nil)
        }
        task.resume()
    }
    
    
}



