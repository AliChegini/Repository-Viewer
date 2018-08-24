//
//  LanguageCountController.swift
//  RepositoryViewer
//
//  Created by Ehsan on 23/08/2018.
//  Copyright © 2018 Ali C. All rights reserved.
//

import UIKit

class LanguageCountController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    // array to hold the groupedDictionaries received from MainViewController
    var groupedDictionaries: [String : [SingleRepository]]?
    
    // array to hold the language counts
    var languageCounts: [String: Int] = [:]
    var sortedCounts: [(key: String, value: Int)] = []
    
    @IBOutlet weak var tableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let groupedDictionariesUnwrapped = groupedDictionaries {
            // Forming a dictionary to hold language names and count
            // the keys are language names, and values are frequencies
            for element in groupedDictionariesUnwrapped {
                languageCounts[element.key] = element.value.count
            }
        }
        
        // sorted(by:) returns an array of tuple such (key = languageName, value = count)
        // Sorting based on language counts (values)
        sortedCounts = languageCounts.sorted(by: { $0.value > $1.value })

        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sortedCounts.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: MyLanguageCell = tableView.dequeueReusableCell(withIdentifier: "languageCell", for: indexPath) as! MyLanguageCell
        

        if sortedCounts.count > 0 {
            // [(key: String, value: Int)]
            let names = sortedCounts.map { $0.key }
            let lCounts = sortedCounts.map { $0.value }
            
            let languageObject = LanguageObject(language: names[indexPath.row], count: lCounts[indexPath.row])
            
            if languageObject.language == "" {
                cell.language.text = "Unknown to Github"
            } else {
                cell.language.text = "\(languageObject.language)"
            }
            
            cell.count.text = "\(languageObject.count)"
        }

        return cell
    }
    
    

}
