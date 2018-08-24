//
//  ViewController.swift
//  RepositoryViewer
//
//  Created by Ehsan on 11/08/2018.
//  Copyright © 2018 Ali C. All rights reserved.
//

import UIKit


class MainViewController: UIViewController {
    
    var finalArray: [SingleRepository] = []
    var finalArrayWithNoDuplicate: [SingleRepository] = []
    // array to hold the grouped dictionaries ---
    // keys are language names, values are repos
    var groupedDictionaries: [String : [SingleRepository]] = [:]
    
    let extractor = Extractor()
    
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var percentage: UILabel!
    
    @IBOutlet weak var languageCountButton: UIButton!
    @IBOutlet weak var searchRepoButton: UIButton!
    @IBOutlet weak var viewResultButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        disableButtons()
        print("Starting the program...")
        
        let serialQueue = DispatchQueue(label: "serialQueue")
        
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
        // making sure the shared resources finalArray and counter are accessed safely
        extractor.extractProperties { object, error in
            serialQueue.async { [weak self] in
                counter += 1
                print("Counter is: \(counter), Object ID: \(object?.id) ")
                guard counter < RepoViewerAPIClient.totalRepos else  {
                    self?.didCompletePopulation()
                    return
                }
                
                guard let object = object else {
                    print("Extractor did not reutrn data --- Main View Controller")
                    return
                }
                self?.finalArray.append(object)
            }
        }
        
    }
    
    
    func didCompletePopulation() {
        print("Final array is populated and may have duplicates \(self.finalArray.count)")
        
        // removing duplicates --- for uniqueElements definition refer to Extensions
        finalArrayWithNoDuplicate = finalArray.uniqueElements
        print("Size of the array after removing duplicates \(self.finalArrayWithNoDuplicate.count)")
        
        // updating the UI from main thread
        DispatchQueue.main.async {
            self.label.text = "Data downloaded successfully!"
            self.enableButtons()
        }
    }
    
    
    // function to prepare groupedDictionaries to send to ResultViewController and LanguageViewController
    func prepareGroupedDictionaries() {
        // Grouping tha unwrapped final array, so it can be sorted and used to form sections
        groupedDictionaries = Dictionary(grouping: finalArrayWithNoDuplicate) { (object) -> String in
            var language = ""
            if let languageUnwrapped = object.language {
                language = languageUnwrapped
            }
            return language
        }
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // sending needed data via segues to other controllers
        switch segue.identifier {
        case "resultSegue":
            let vc = segue.destination as! ResultViewController
            vc.finalArray = finalArrayWithNoDuplicate
            prepareGroupedDictionaries()
            vc.groupedDictionaries = groupedDictionaries
        case "quickCountSegue":
            let vc = segue.destination as! LanguageCountController
            prepareGroupedDictionaries()
            vc.groupedDictionaries = groupedDictionaries
        case "searchSegue":
            let vc = segue.destination as! SearchViewController
            vc.finalArray = finalArrayWithNoDuplicate
        default:
            return
        }
        
        
    }
    
    
    func enableButtons() {
        languageCountButton.isEnabled = true
        searchRepoButton.isEnabled = true
        viewResultButton.isEnabled = true
    }
    
    func disableButtons() {
        languageCountButton.isEnabled = false
        searchRepoButton.isEnabled = false
        viewResultButton.isEnabled = false
    }

    
}



