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
    func extractProperties() {
        client.getFullPack() { data, error in
            let decoder = JSONDecoder()
            guard let data = data else {
                print("data is empty")
                return
            }
            
            let fullPack = try? decoder.decode([RepositoryURL].self, from: data)
            if let fullPackUnwrapped = fullPack {
                for url in fullPackUnwrapped {
                    self.allURLs.append(url)
                    
                    // Second asynch call to extract required properties
                    self.client.getSinglePack(url: url) { data, error in
                        guard let data = data else {
                            print("data is empty")
                            return
                        }
                        let singlePack = try? decoder.decode(SingleRepository.self, from: data)
                        if let singlePackUnwrapped = singlePack {
                            self.allRepositories.append(singlePackUnwrapped)
                        }
                        // TODO: Find a way to pass an array when function is done
                    }
                    
                }
            }
            
        }
        
    }
    
    
}






