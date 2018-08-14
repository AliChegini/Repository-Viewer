//
//  ViewController.swift
//  RepositoryViewer
//
//  Created by Ehsan on 11/08/2018.
//  Copyright © 2018 Ali C. All rights reserved.
//

import UIKit


class ViewController: UIViewController {
    
    let extractor = Extractor()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        extractor.extractProperties()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    

}



