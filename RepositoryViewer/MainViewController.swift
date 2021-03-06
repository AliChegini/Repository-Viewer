//
//  MainViewController.swift
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
    @IBOutlet weak var progressView: UIProgressView!
    
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
                let fractionalProgress = Float(counter) / Float(RepoViewerAPIClient.totalRepos) * 100
                DispatchQueue.main.async {
                    self.percentage.text = ("\(fractionalProgress) %")
                    self.progressView.setProgress(fractionalProgress/100, animated: true)
                }
            }
        }
        
        // check for Network Connection at the beginning
        if NetworkChecker.Connection() == true {
            // body of the closure is wrapped into another closure executed through a serial queue
            // making sure the shared resources finalArray and counter are accessed safely
            extractor.extractProperties { object, error in
                serialQueue.async { [weak self] in
                    counter += 1
                    print("Request count is: \(counter)")
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
        // when device is offline, reads data from UserDefaults
        } else {
            // Reading the user defaults to extract available data
            if let data = UserDefaults.standard.value(forKey: "finalArrayWithNoDuplicate") as? Data {
                let offlineArray = try? PropertyListDecoder().decode([SingleRepository].self, from: data)
                if let offlineArrayUnwrapped = offlineArray {
                    // populating the array from UserDefaults
                    finalArrayWithNoDuplicate = offlineArrayUnwrapped
                }
            }
            
            // updating the UI from main thread
            DispatchQueue.main.async {
                self.label.text = "Device is Offline, but you can see the cached result"
                self.percentage.text = ("100 %")
                self.progressView.setProgress(100/100, animated: true)
                self.enableButtons()
            }
            
        }
        
    }
    
    
    func didCompletePopulation() {
        print("Final array is populated and may have duplicates \(self.finalArray.count)")
        
        // removing duplicates --- for uniqueElements definition refer to Extensions
        finalArrayWithNoDuplicate = finalArray.uniqueElements
        print("Size of the array after removing duplicates \(self.finalArrayWithNoDuplicate.count)")
        
        // Store prepared array in user defaults for offline use
        UserDefaults.standard.set(try? PropertyListEncoder().encode(finalArrayWithNoDuplicate), forKey:"finalArrayWithNoDuplicate")
        print("finalArrayWithNoDuplicate is saved into UserDefaults for offline use")
    
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
        // sending data via segues to other controllers
        switch segue.identifier {
        case "resultSegue":
            if let vc = segue.destination as? ResultViewController {
                vc.finalArray = finalArrayWithNoDuplicate
                prepareGroupedDictionaries()
                vc.groupedDictionaries = groupedDictionaries
            }
        case "quickCountSegue":
            if let vc = segue.destination as? LanguageCountController {
                prepareGroupedDictionaries()
                vc.groupedDictionaries = groupedDictionaries
            }
        case "searchSegue":
            if let vc = segue.destination as? SearchViewController {
                vc.finalArray = finalArrayWithNoDuplicate
            }
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



