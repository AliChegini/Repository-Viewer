//
//  ResultViewController.swift
//  RepositoryViewer
//
//  Created by Ehsan on 20/08/2018.
//  Copyright © 2018 Ali C. All rights reserved.
//

import UIKit

class ResultViewController: UIViewController, UISearchBarDelegate {

    var finalArray: [SingleRepository]?
    var phrase = ""
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // setting delegate for search bar
        searchBar.delegate = self
        
        guard let finalArrayUnwrapped = finalArray else {
            print("final array is empty")
            return
        }
        
        
        
        // Do any additional setup after loading the view.
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
            let filteredArray = finalArray?.filter { $0.name == searchBarTextUnwrapped }
            print(filteredArray)
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
