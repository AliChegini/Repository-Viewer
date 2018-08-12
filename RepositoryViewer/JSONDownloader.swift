//
//  JSONDownloader.swift
//  RepositoryViewer
//
//  Created by Ehsan on 12/08/2018.
//  Copyright © 2018 Ali C. All rights reserved.
//


import UIKit

class JSONDownloader {
    let session: URLSession
    
    init(configuration: URLSessionConfiguration) {
        self.session = URLSession(configuration: configuration)
    }
    
    convenience init() {
        self.init(configuration: .default)
    }
    
    
    // Asynchronous networking call to download json from the API
    func dataTask(with request: URLRequest, completionHandler completion: @escaping (Data?, RepoViewerErrors?) -> Void) -> URLSessionDataTask {
        let task = session.dataTask(with: request) { data, response, error in
            
            // Alert the user for connection related errors
            if let urlError = error as? URLError {
                switch urlError.code {
                case .notConnectedToInternet:
                    self.showAlert()
                case .networkConnectionLost:
                    self.showAlert()
                default: break
                }
            }
            
            // Convert to HTTP Response
            guard let httpResponse = response as? HTTPURLResponse else {
                completion(nil, .requestFailed)
                return
            }
            
            // The request has succeeded - 200 OK
            if httpResponse.statusCode == 200 {
                if let data = data {
                    completion(data, nil)
                } else {
                    completion(nil, .invalidData)
                }
            } else {  // The request has not succeeded - NOT OK
                completion(nil, .responseUnsuccessful)
            }
            
        }
        return task
    }
    
    
    // helper method to alert the user about connection lost, to show the cached data later
    func showAlert(){
        let alert = UIAlertController(title: "Error", message: "No Internet Connection \n You can see the cached result...", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        alert.presentInOwnWindow(animated: true, completion: nil)
    }
    
}





