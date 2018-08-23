//
//  LanguageCountController.swift
//  RepositoryViewer
//
//  Created by Ehsan on 23/08/2018.
//  Copyright © 2018 Ali C. All rights reserved.
//

import UIKit

class LanguageCountController: UIViewController {

    // array to hold the groupedDictionaries received from MainViewController
    var groupedDictionaries: [String : [SingleRepository]]?
    // var groupedDictionariesUnwrapped: [String : [SingleRepository]] = [:]
    
    //TODO: make a language cell like MyCustomCell
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let groupedDictionariesUnwrapped = groupedDictionaries {
            // array to hold the language counts
            var counts: [String: Int] = [:]
            
            // Forming a dictionary ,the keys are language names, and values are occurences
            for element in groupedDictionariesUnwrapped {
                counts[element.key] = element.value.count
            }
            // ---------------------------------------------------
        }

        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    
    
    
    
    

}
