//
//  ViewController.swift
//  RepositoryViewer
//
//  Created by Ehsan on 11/08/2018.
//  Copyright © 2018 Ali C. All rights reserved.
//

import UIKit


class ViewController: UIViewController {
    
    var finalArray: [SingleRepository] = []
    
    let extractor = Extractor()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("Starting the program...")
        
        let serialQueue = DispatchQueue(label: "serialQueue")
        var count = 0
        
        extractor.extractProperties { object, error in
            serialQueue.async { [weak self] in
                count += 1
                print(count)
                if count == 300  {
                    print("did complete")
                    self?.didCompletePopulation()
                    return
                }
                
                guard let object = object else {
                    print("Extractor did not reutrn data")
                    return
                }
                
                if let error = error {
                    print("Error is \(error)")
                }
                
                self?.finalArray.append(object)
                
            }
        }
        
    }
    
    
    func didCompletePopulation() {
        // be aware, this is not called on the main thread
        // if you need to update the UI from here then use the main thread
        print("Final array is populated \(self.finalArray.count)")
    }
    
    
    func constructingFinalArray(completionBlock: @escaping ([SingleRepository]) -> Void) {
        var fArrray: [SingleRepository] = []
        extractor.extractProperties { data, error in
            guard let data = data else {
                print("Extractor did not reutrn data")
                return
            }
            fArrray.append(data)
            completionBlock(fArrray)
        }
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
}



