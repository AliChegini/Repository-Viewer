//
//  DetailViewController.swift
//  RepositoryViewer
//
//  Created by Ehsan on 26/08/2018.
//  Copyright © 2018 Ali C. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    
    @IBOutlet weak var detailLabel: UILabel!
    
    
    var detail: SingleRepository?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let detailUnwrapped = detail {
            if let fullNameUnwrapped = detailUnwrapped.fullName, let descriptionUnwrapped = detailUnwrapped.description, let starsUnwrapped = detailUnwrapped.stars, let forkUnwrapped = detailUnwrapped.forks, let lastUpdateUnwrapped = detailUnwrapped.lastUpdate, let languageUnwrapped = detailUnwrapped.language, let idUnwrapped = detailUnwrapped.id {
                detailLabel.text = "Full Name: \(fullNameUnwrapped)\n\nID: \(idUnwrapped)\nLanguage: \(languageUnwrapped)\nDescription\(descriptionUnwrapped) \nStars: \(starsUnwrapped)      Forks: \(forkUnwrapped)\nUpdated: \(lastUpdateUnwrapped)"
            }
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    

}
