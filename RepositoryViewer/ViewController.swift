//
//  ViewController.swift
//  RepositoryViewer
//
//  Created by Ehsan on 11/08/2018.
//  Copyright © 2018 Ali C. All rights reserved.
//

import UIKit


class ViewController: UIViewController {
    
    let client = RepoViewerAPIClient()
    var allRepos: [Repository] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        client.getFullPack() { data, error in
            let decoder = JSONDecoder()
            guard let data = data else {
                print("data is empty")
                return
            }
            
            let fullPack = try? decoder.decode([Repository].self, from: data)
            if let fullPackUnwrapped = fullPack {
                for element in fullPackUnwrapped {
                    self.allRepos.append(element)
                }
            }
        }
        
        // TODO: thinnking about a way to request all the urls and parse them
        // Not sure where to do the following, maybe a new class?!
        for repo in self.allRepos {
            if let urlUnwrapped = repo.url {
                client.getSinglePack(url: URL(string: urlUnwrapped)!) { data, error in
                    
                    guard let data = data else {
                        print("data is empty")
                        return
                    }
                    print(data)
                }
            }
            
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    

}



