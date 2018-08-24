//
//  SearchViewController.swift
//  RepositoryViewer
//
//  Created by Ehsan on 23/08/2018.
//  Copyright © 2018 Ali C. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController, UISearchBarDelegate, UITableViewDelegate, UITableViewDataSource {

    // array to hold the finalArray recevied from MainViewController
    var finalArray: [SingleRepository]?
    var finalArrayUnwrapped: [SingleRepository] = []
    
    // array to hold filteredResult based on user input
    var filteredResult: [SingleRepository] = []
    
    var lowerCasedUserInput = ""
    
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // setting delegate for search bar
        searchBar.delegate = self
        searchBar.placeholder = "Search for owner or project name"
        
        self.tableView.estimatedRowHeight = 100
        self.tableView.rowHeight = UITableViewAutomaticDimension
        
        if let fAUnwrapped = finalArray {
            finalArrayUnwrapped = fAUnwrapped
        }
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // function to filter array based on userInput
    func filter(userInput: String, array: [SingleRepository] ) -> [SingleRepository] {
         let filteredArray = array.filter { ($0.fullName?.contains(userInput))! }
         return filteredArray
     }
    
    
    // will only be called when user tap on search
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let searchBarTextUnwrapped = searchBar.text {
            self.lowerCasedUserInput = searchBarTextUnwrapped.lowercased()
            
            filteredResult = filter(userInput: self.lowerCasedUserInput, array: finalArrayUnwrapped)
            
            // reloading data for tableView
            tableView.reloadData()
            searchBar.endEditing(true)
        }
    }
    
    
    //    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
    //        print("searchText \(searchText)")
    //    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // when filteredResult is empty, non filtered array is used for tableView
        if filteredResult.count > 0 {
            return filteredResult.count
        }
        return finalArrayUnwrapped.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: MySearchCell = tableView.dequeueReusableCell(withIdentifier: "searchCell", for: indexPath) as! MySearchCell
        
        let singleRepository: SingleRepository
        
        // when filteredResult is empty populate the cells with non filtered array
        if filteredResult.count > 0 {
            singleRepository = filteredResult[indexPath.row]
        } else {
            singleRepository = finalArrayUnwrapped[indexPath.row]
        }
        
        
        if let fullNameUnwrapped = singleRepository.fullName, let descriptionUnwrapped = singleRepository.description, let starsUnwrapped = singleRepository.stars, let forkUnwrapped = singleRepository.forks, let lastUpdateUnwrapped = singleRepository.lastUpdate, let languageUnwrapped = singleRepository.language {
            cell.myResultLabel.text = "\(fullNameUnwrapped)\n\n\(languageUnwrapped)\n\(descriptionUnwrapped) \nStars: \(starsUnwrapped)      Forks: \(forkUnwrapped)\nUpdated: \(lastUpdateUnwrapped)"
        }
        
        return cell
    }

    
}
