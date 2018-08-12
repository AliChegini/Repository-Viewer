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

    override func viewDidLoad() {
        super.viewDidLoad()
        
        client.getObjects() { data, error in
            let decoder = JSONDecoder()
            guard let data = data else {
                print("data is empty")
                return
            }
            
            let allResult = try? decoder.decode([Repository].self, from: data)
            if let allResultUnwrapped = allResult {
                print(allResultUnwrapped)
            }
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    

}



