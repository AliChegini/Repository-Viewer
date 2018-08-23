//
//  ResultViewController.swift
//  RepositoryViewer
//
//  Created by Ehsan on 20/08/2018.
//  Copyright © 2018 Ali C. All rights reserved.
//

import UIKit

class ResultViewController: UIViewController, UISearchBarDelegate, UITableViewDelegate, UITableViewDataSource {

    // array to hold the passed result from main view controller
    var finalArray: [SingleRepository]?
    var finalArrayUnwrapped: [SingleRepository] = []
    
    // 2D array to hold the grouped language and use it to form sections and rows
    var groupedLanguage: [[SingleRepository]] = [[]]
    
    
    @IBOutlet weak var searchBar: UISearchBar!    
    @IBOutlet weak var tableView: UITableView!
    
   
    override func viewDidLoad() {
        super.viewDidLoad()

        // setting delegate for search bar
        searchBar.delegate = self
        
        self.tableView.estimatedRowHeight = 100
        self.tableView.rowHeight = UITableViewAutomaticDimension
        
        // Unwrapping the final array
        finalArrayUnwrapped = unwrapFinalArray(finalArray: finalArray)
        
        
        // Grouping tha unwrapped final array, so it can be sorted and used to form sections
        let groupedDictionaries = Dictionary(grouping: finalArrayUnwrapped) { (object) -> String in
            var language = "Not Known to GitHub"
            if let languageUnwrapped = object.language {
                language = languageUnwrapped
            }
            return language
        }
        
        
        // sorting the array of dictionaries with descending order based on size of array containing the values
        let sortedGroupedDictionary =  groupedDictionaries.sorted(by: { ($0.value.count) > ($1.value.count) })
        
        // Getting all the keys
        let keys = sortedGroupedDictionary.map{ $0.key }
        
       
        
        // -----------  should be moved to another controller
        // array to hold the language counts
        var counts: [String: Int] = [:]
        
        // Forming a dictionary ,the keys are language names, and values are occurences
        for element in groupedDictionaries {
            counts[element.key] = element.value.count
        }
        // ---------------------------------------------------
        
        
        // Forming the sections
        // each key represent name of a language as String
        for key in keys {
            if var groupedDictionariesValueUnwrapped = groupedDictionaries[key] {
                // sorting groupedLanguage based on most stars
                groupedDictionariesValueUnwrapped.sort(by: { $0.stars! > $1.stars! })
                groupedLanguage.append(groupedDictionariesValueUnwrapped)
            }
        }
        
        
        //groupedLanguage.sort(by: { $0[0].stars! < $1[0].stars! })
        //print(groupedLanguage)
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
//    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
//        print("searchText \(searchText)")
//    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let searchBarTextUnwrapped = searchBar.text {
            let filteredArray = filter(userInput: searchBarTextUnwrapped)
            if let filteredArrayUnwrapped  = filteredArray {
                //resultArray = filteredArrayUnwrapped
                
            }
        }
    }
    
    
    func filter(userInput: String) -> [SingleRepository]? {
        // TODO: have to be fixed later
        let filteredArray = finalArray?.filter { ($0.fullName?.contains(userInput))! }
        return filteredArray
    }
    
    // unwrapping final array
    func unwrapFinalArray(finalArray: [SingleRepository]?) -> [SingleRepository] {
        var final: [SingleRepository] = []
        if let finalArrayUnwrapped = finalArray {
            final = finalArrayUnwrapped
        }
        return final
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return groupedLanguage.count > 0 ? groupedLanguage.count : 1
    }
    
    // Table view functions ------
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if groupedLanguage.count > 0 {
            return groupedLanguage[section].count
        }
        return finalArrayUnwrapped.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: MyCustomCell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! MyCustomCell
        let singleRepository: SingleRepository
        
        if groupedLanguage.count > 0 {
            singleRepository = groupedLanguage[indexPath.section][indexPath.row]
        } else {
            singleRepository = finalArrayUnwrapped[indexPath.row]
        }
    
        if let fullNameUnwrapped = singleRepository.fullName, let descriptionUnwrapped = singleRepository.description, let starsUnwrapped = singleRepository.stars, let forkUnwrapped = singleRepository.forks, let lastUpdateUnwrapped = singleRepository.lastUpdate, let idUnwrapped = singleRepository.id {
            cell.myCellLabel.text = "\(fullNameUnwrapped)\n\n\(descriptionUnwrapped) \nStars: \(starsUnwrapped)      Forks: \(forkUnwrapped)\nupdated: \(lastUpdateUnwrapped)\n\(idUnwrapped)"
        }
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if groupedLanguage.count == 0 {
            return nil
        }
        
        let label = UILabel()
        label.text = groupedLanguage[section].first?.language
        label.backgroundColor = UIColor.lightGray
        
        return label
    }
    
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return UITableViewAutomaticDimension
//    }
//    
//    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
//        return 100
//    }
    
    
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let cell = tableView.cellForRow(at: indexPath)
//
//    }
    
    
//    override func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
//        let cell = tableView.cellForRow(at: indexPath)
//
//    }
    
    // Table view override functions ------
}
