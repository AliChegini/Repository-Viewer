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
    
    // Note: because since=0 will include the first hundred, numberOfHundredPacks should always get decreamented by 1
    // formula to change two following variables: numberOfHundredPacks = (totalRepos / 100) - 1
    // for 1000 repository, numberOfHundredPacks will be 9
    static let totalRepos = 500
    let numberOfHundredPacks = 4
    
    fileprivate let clientIDAndSecret = "?client_id=bf645279e7f46a051182&client_secret=b8b7c8ecd5dd75c56c99d54810c1591a661e3a53"
    
    
    lazy var fullPackURL: URL = {
        return URL(string: "https://api.github.com/repositories\(clientIDAndSecret)")!
    }()
    
    
    let downloader = JSONDownloader()
    
    
    // Each request to https://api.github.com/repositories will return 100 repositories at max due to API limitation
    // Assumption I made is to work with only 1000 repos, hence the endpoint should be called 10 times
    func constructStringURLs() -> [String] {
        var urlsWithSinceParam: [String] = []
        
        for pageNumber in 0...numberOfHundredPacks {
            // endpoint only accept one paramter known as "since" to return pack of 100 repos
            // phrase "&since=pageNumber*100" should be appended to the url to get more than 100 repos
            // since=0 will give 0 to 100 repos, since=100 will give 101 to 200 and so on
            var since = 0
            if pageNumber == 0 {
                since = pageNumber * 100
            } else {
                // there id start at 1
                since = pageNumber * 100 + 1
            }
            
            let phrase = "&since=\(since)"
            print(phrase)
            
            var urlToString = fullPackURL.absoluteString
            urlToString.append(phrase)
            urlsWithSinceParam.append(urlToString)
        }
        
        return urlsWithSinceParam
    }
    
    
    
    // method to get full pack of repositories
    func getFullPack(completionHandler completion: @escaping (Data?, RepoViewerErrors?) -> Void) {
        let array = constructStringURLs()
        
        for element in array {
            guard let url = URL(string: element) else {
                print("URL is not constructed properly")
                return
            }
            
            let request = URLRequest(url: url)
            let task = downloader.dataTask(with: request) { data, error in
                guard let data = data else {
                    print("Error from getFullPack(): \(error.debugDescription)")
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
        guard let stringURLUnwrapped = url.url else {
            print("from getSinglePack() string url is empty")
            return
        }
        var stringURLWithSecret = stringURLUnwrapped
        stringURLWithSecret.append(clientIDAndSecret)
        
        //print("url from inside getSinglePAck(): \(stringURLWithSecret) ")
        
        guard let finalUrl = URL(string: stringURLWithSecret) else {
            print("URL is not constructed properly")
            // I want to halt the program execution if the url is not constructed properly
            fatalError()
        }
        
        let request = URLRequest(url: finalUrl)
        let task = downloader.dataTask(with: request) { data, error in
            guard let data = data else {
                print("Error from getSinglePack() \(error.debugDescription)")
                completion(nil, error)
                return
            }
            completion(data, nil)
        }
        task.resume()
    }
    
    
}






