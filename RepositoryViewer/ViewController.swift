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
    
    
    @IBOutlet weak var label: UILabel!
    
    @IBOutlet weak var percentage: UILabel!
    
    @IBOutlet weak var viewResultButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewResultButton.isEnabled = false
        print("Starting the program...")
        
        let serialQueue = DispatchQueue(label: "serialQueue")
        //var count = 0
        
        var counter:Int = 0 {
            // Observer to update the percentage progress
            didSet {
                let fractionalProgress = Float(counter) / Float(RepoViewerAPIClient.totalRepos) * 100.0
                DispatchQueue.main.async {
                    self.percentage.text = ("\(fractionalProgress) %")
                }
            }
        }
        
    
        // body of the closure is wrapped into another closure executed through a serial queue
        // making sure the shared resources finalArray and count are accessed safely
        extractor.extractProperties { object, error in
            serialQueue.async { [weak self] in
                counter += 1
                print(counter)
                guard counter < RepoViewerAPIClient.totalRepos else  {
                    print("Array is fully populated...")
                    self?.didCompletePopulation()
                    return
                }
                
                guard let object = object else {
                    print("Extractor did not reutrn data --- View Controller")
                    return
                }
                self?.finalArray.append(object)
            }
        }
        
    }
    
    
    func didCompletePopulation() {
        print("Final array is populated \(self.finalArray.count)")
        // updating the UI from main thread
        DispatchQueue.main.async {
            self.label.text = "Data downloaded successfully!"
            self.viewResultButton.isEnabled = true
        }
        
        // filter
        //let filteredArray = finalArray.filter { $0.language == "Ruby" }
        //print(filteredArray)
    }
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let vc = segue.destination as! ResultViewController
        vc.finalArray = finalArray
    }

    
}



