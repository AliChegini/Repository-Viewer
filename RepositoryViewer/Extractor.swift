//
//  Extractor.swift
//  RepositoryViewer
//
//  Created by Ehsan on 14/08/2018.
//  Copyright © 2018 Ali C. All rights reserved.
//

import Foundation


// Class to extract the required properties and
// provide ready to use arrays for MainViewController
class Extractor {
    private let client = RepoViewerAPIClient()
    private var allURLs: [RepositoryURL] = []
    var allRepositories: [SingleRepository] = []
    
    
    // Method to extract all the required properties
    // compromising of 2 asynchrounous call, (nested asynch call)
    // one to get the urls of each repo and another call within the first call to extract all the propreties of each repo
    func extractProperties(completionHandler: @escaping (SingleRepository?, RepoViewerErrors?) -> Void) {
        
        // Outer asynch call to extract urls of all repos
        client.getHundredPackOfURLs() { data, error in
            let decoder = JSONDecoder()
            guard let data = data else {
                print("data is empty from getHundredPackOfURLs()")
                completionHandler(nil, error)
                return
            }
            
            // with try? if an error is thrown while decoding, it will be handled by turning into optional value, threfore no need to wrap it in do-catch block
            let urlsPack = try? decoder.decode([RepositoryURL].self, from: data)
            
            if let urlsPackUnwrapped = urlsPack {
                for url in urlsPackUnwrapped {
                    self.allURLs.append(url)
                    
                    // Inner asynch call to extract required properties for each repo
                    self.client.getSingleRepositoryInfo(url: url) { data, error in
                        guard let data = data else {
                            print("data is empty from getSingleRepositoryInfo()")
                            completionHandler(nil, error)
                            return
                        }
                        // decoding info of each repo
                        let singlePack = try? decoder.decode(SingleRepository.self, from: data)
                        if let singlePackUnwrapped = singlePack {
                            self.allRepositories.append(singlePackUnwrapped)
                            completionHandler(singlePackUnwrapped, nil)
                        } else {
                            print("single pack is empty")
                        }
                    } // End of inner asynch call scope
                    
                } // End of loop
            } else {
                print("urlsPack is empty")
            }
            
        } // End of outer asynch call scope
        
    }
    
    
}





