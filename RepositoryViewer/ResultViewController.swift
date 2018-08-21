//
//  ResultViewController.swift
//  RepositoryViewer
//
//  Created by Ehsan on 20/08/2018.
//  Copyright © 2018 Ali C. All rights reserved.
//

import UIKit

class ResultViewController: UIViewController, UISearchBarDelegate, UITableViewDelegate, UITableViewDataSource {

    var finalArray: [SingleRepository]?
    // result array after filter applied
    var finalArrayUnwrapped: [SingleRepository] = []
    var groupedLanguage: [[SingleRepository]] = [[]]
    
    
    @IBOutlet weak var searchBar: UISearchBar!    
    @IBOutlet weak var tableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // setting delegate for search bar
        searchBar.delegate = self
        
        // Table view setup
        //self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        finalArrayUnwrapped = unwrapFinalArray(finalArray: finalArray)
        
        let groupedDictionary = Dictionary(grouping: finalArrayUnwrapped) { (object) -> String in
            var language = ""
            if let languageUnwrapped = object.language {
                language = languageUnwrapped
            }
            return language
        }
        
        let keys = groupedDictionary.keys
        
        for key in keys {
            groupedLanguage.append(groupedDictionary[key]!)
        }
        
        // calculate count of each ocuurences
        // https://gist.github.com/adamloving/1a3226eed53eeb9baa39
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
        let filteredArray = finalArray?.filter { $0.name == userInput }
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let singleRepository: SingleRepository
        
        if groupedLanguage.count > 0 {
            singleRepository = groupedLanguage[indexPath.section][indexPath.row]
        } else {
            singleRepository = finalArrayUnwrapped[indexPath.row]
        }
    
        if let descriptionUnwrapped = singleRepository.description {
            cell.textLabel?.text = "Description: \(descriptionUnwrapped)"
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
