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
    func extractProperties(completionHandler: @escaping (SingleRepository?, RepoViewerErrors?) -> Void) {
        
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
                for url in urlsPackUnwrapped {
                    self.allURLs.append(url)
                    
                    // Inner asynch call to extract required properties for each repo
                    self.client.getSinglePack(url: url) { data, error in
                        guard let data = data else {
                            print("data is empty from getSinglePack()")
                            completionHandler(nil, error)
                            return
                        }
                        let singlePack = try? decoder.decode(SingleRepository.self, from: data)
                        if let singlePackUnwrapped = singlePack {
                            self.allRepositories.append(singlePackUnwrapped)
                            //print("size of all repositories: \(self.allRepositories.count)")
                            completionHandler(singlePackUnwrapped, nil)
                        } else {
                            print("single pack is empty")
                        }
                    } // End of inner asynch call scope
                    
                } // End of loop
            } else {
                print("get url is empty")
            }
            
        } // End of outer asynch call scope
        
    }
    
    
}

//TOOD:
// loop through 10 pages to get 1000 result back
// UI should be button "Get full overview" -> numbers and languages -> find a way to load the cells as they come
// taping on each language should show list of result for that language in new page
//




