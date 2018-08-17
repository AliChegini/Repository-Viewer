//
//  Extractor.swift
//  RepositoryViewer
//
//  Created by Ehsan on 14/08/2018.
//  Copyright © 2018 Ali C. All rights reserved.
//

import Foundation


// Class to extract the required properties and
// provide ready to use object for ViewController
class Extractor {
    private let client = RepoViewerAPIClient()
    private var allURLs: [RepositoryURL] = []
    var allRepositories: [SingleRepository] = []
    
    
    // Method to extract all the required properties
    // compromising of 2 asynchrounous call, (nested asynch call)
    // one to get the urls and another call within the first call to extract all the propreties
    func extractProperties(completionHandler: @escaping ([SingleRepository]?, RepoViewerErrors?) -> () ) {
        
        // Outer asynch call to extract urls of all repos
        client.getFullPack() { data, error in
            let decoder = JSONDecoder()
            guard let data = data else {
                print("data is empty from getFullPack()")
                completionHandler(nil, error)
                return
            }
            let urlsPack = try? decoder.decode([RepositoryURL].self, from: data)
            if let urlsPackUnwrapped = urlsPack {
                
                var counter = 0
                var singlePackCounter = 0
                
                for url in urlsPackUnwrapped {
                    counter += 1
                    //print("loop counter is: \(counter)")
                    //print("URL pack unwrapped size: \(urlsPackUnwrapped.count)")
                    //url.url?.append("?client_id=bf645279e7f46a051182&client_secret=b8b7c8ecd5dd75c56c99d54810c1591a661e3a53")
                    self.allURLs.append(url)
                    print("size of all urls: \(self.allURLs.count) \(url)")
                    
                    
                    //TODO: URL have to be appended with secret id and client id due to the rate limit
                    
                    // Inner asynch call to extract required properties for each repo
                    self.client.getSinglePack(url: url) { data, error in
                        singlePackCounter += 1
                        
                        guard let data = data else {
                            print("data is empty from getSinglePack(): \(singlePackCounter)")
                            completionHandler(nil, error)
                            return
                        }
                        let singlePack = try? decoder.decode(SingleRepository.self, from: data)
                        if let singlePackUnwrapped = singlePack {
                            self.allRepositories.append(singlePackUnwrapped)
                            print("size of all repositories: \(self.allRepositories.count)")
                            completionHandler(self.allRepositories, nil)
                        }
                    } // End of inner asynch call scope
                    
                } // End of loop
            }
            
        } // End of outer asynch call scope
        
    }
    
    
}

//TOOD:
// loop through 10 pages to get 1000 result back
// UI should be button "Get full overview" -> numbers and languages -> find a way to load the cells as they come
// taping on each language should show list of result for that language in new page
//




