//
//  SearchViewController.swift
//  RepositoryViewer
//
//  Created by Ehsan on 23/08/2018.
//  Copyright © 2018 Ali C. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController, UISearchBarDelegate {

    @IBOutlet weak var searchBar: UISearchBar!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // setting delegate for search bar
        searchBar.delegate = self
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    /*
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let searchBarTextUnwrapped = searchBar.text {
            let filteredArray = filter(userInput: searchBarTextUnwrapped)
            if let filteredArrayUnwrapped  = filteredArray {
                //resultArray = filteredArrayUnwrapped
                
            }
        }
    }
    */
    
    //    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
    //        print("searchText \(searchText)")
    //    }
    
    /*
    func filter(userInput: String) -> [SingleRepository]? {
        // TODO: have to be fixed later
        let filteredArray = finalArray?.filter { ($0.fullName?.contains(userInput))! }
        return filteredArray
    }
    */

    
}
