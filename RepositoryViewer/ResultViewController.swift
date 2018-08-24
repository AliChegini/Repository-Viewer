//
//  ResultViewController.swift
//  RepositoryViewer
//
//  Created by Ehsan on 20/08/2018.
//  Copyright © 2018 Ali C. All rights reserved.
//

import UIKit

class ResultViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    // array to hold the passed result from main view controller
    var finalArray: [SingleRepository]?
    var finalArrayUnwrapped: [SingleRepository] = []
    
    // array to hold the groupedDictionaries received from MainViewController
    var groupedDictionaries: [String : [SingleRepository]]?
    var groupedDictionariesUnwrapped: [String : [SingleRepository]] = [:]
    
    // 2D array to hold the grouped language and use it to form sections and rows
    var groupedLanguage: [[SingleRepository]] = [[]]
    
    @IBOutlet weak var tableView: UITableView!
    
   
    override func viewDidLoad() {
        super.viewDidLoad()

        
        self.tableView.estimatedRowHeight = 100
        self.tableView.rowHeight = UITableViewAutomaticDimension
        
        // Unwrapping the finalArray
        finalArrayUnwrapped = unwrapFinalArray(finalArray: finalArray)
        
        // Unwrapping the groupedDictionaries
        groupedDictionariesUnwrapped = unwrapGroupDictionaries(groupedDictionaries: groupedDictionaries)
        
        
        // sorting the array of dictionaries with descending order based on size of array containing the values (number of repositories in each language)
        let sortedGroupedDictionary =  groupedDictionariesUnwrapped.sorted(by: { ($0.value.count) > ($1.value.count) })
        
        // Getting all the keys
        let keys = sortedGroupedDictionary.map{ $0.key }
        
        
        // Forming the sections
        // each key represent name of a language as String
        for key in keys {
            if var groupedDictionariesValueUnwrapped = groupedDictionariesUnwrapped[key] {
                // sorting each language array based on most stars
                groupedDictionariesValueUnwrapped.sort(by: { $0.stars! > $1.stars! })
                // appending the sorted array to groupedLanguage
                groupedLanguage.append(groupedDictionariesValueUnwrapped)
            }
        }
        
        
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // function to unwrap the finalArray(passed from MainViewController)
    func unwrapFinalArray(finalArray: [SingleRepository]?) -> [SingleRepository] {
        var final: [SingleRepository] = []
        if let finalArrayUnwrapped = finalArray {
            final = finalArrayUnwrapped
        }
        return final
    }
    
    // function to unwrap the groupedDictionaries(passed from MainViewController)
    func unwrapGroupDictionaries(groupedDictionaries: [String : [SingleRepository]]?) -> [String : [SingleRepository]] {
        var final: [String : [SingleRepository]] = [:]
        if let groupedDictionariesUnwrapped = groupedDictionaries {
            final = groupedDictionariesUnwrapped
        }
        return final
    }
    
    
    // Table view functions -------------------------------------
    
    func numberOfSections(in tableView: UITableView) -> Int {
        // Ternary operator --- question ? answer1 : answer2
        // if count is bigger than 0 return it, otherwise return 1
        return groupedLanguage.count > 0 ? groupedLanguage.count : 1
    }

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // when groupedLanguage is empty, finalArrayUnwrapped is used for tableView
        if groupedLanguage.count > 0 {
            return groupedLanguage[section].count
        }
        return finalArrayUnwrapped.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: MyCustomCell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! MyCustomCell
        let singleRepository: SingleRepository
        
        // when groupedLanguage is empty populate the cells with finalArrayUnwrapped
        if groupedLanguage.count > 0 {
            singleRepository = groupedLanguage[indexPath.section][indexPath.row]
        } else {
            singleRepository = finalArrayUnwrapped[indexPath.row]
        }
    
        if let fullNameUnwrapped = singleRepository.fullName, let descriptionUnwrapped = singleRepository.description, let starsUnwrapped = singleRepository.stars, let forkUnwrapped = singleRepository.forks, let lastUpdateUnwrapped = singleRepository.lastUpdate {
            cell.myCellLabel.text = "\(fullNameUnwrapped)\n\n\(descriptionUnwrapped) \nStars: \(starsUnwrapped)      Forks: \(forkUnwrapped)\nUpdated: \(lastUpdateUnwrapped)"
        }
        return cell
    }
    
    // setting header for sections
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let label = UILabel()
        label.backgroundColor = UIColor.lightGray
        var header = ""
        
        if groupedLanguage.count == 0 {
            return nil
        } else if (groupedLanguage[section].first?.language == nil) && (section != 0) {
            header = "Unknown to GitHub"
        }
        
        if let languageUnwrapped = groupedLanguage[section].first?.language {
            header = languageUnwrapped
        }
        label.text = header
        
        return label
    }
    
}
