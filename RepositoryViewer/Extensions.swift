//
//  Extension.swift
//  RepositoryViewer
//
//  Created by Ehsan on 12/08/2018.
//  Copyright © 2018 Ali C. All rights reserved.
//

import UIKit


// extension to alert the user for connection related errors from JSONDownloader
extension UIAlertController {
    func presentInOwnWindow(animated: Bool, completion: (() -> Void)?) {
        guard let rootVC = UIApplication.shared.keyWindow?.rootViewController else { return }
        rootVC.present(self, animated: animated, completion: completion)
    }
}

extension JSONDownloader {
    // helper method to alert the user about connection lost, to show the cached data later
    func showAlert(){
        let alert = UIAlertController(title: "Error", message: "No Internet Connection \n You can see the cached result...", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        alert.presentInOwnWindow(animated: true, completion: nil)
    }
}



// Extensions to remove duplicates
extension SingleRepository: Equatable {
    static func == (lhs: SingleRepository, rhs: SingleRepository) -> Bool {
        return lhs.id == rhs.id
    }
}


public extension Sequence where Element: Equatable {
    var uniqueElements: [Element] {
        return self.reduce(into: []) {
            uniqueElements, element in
            
            if !uniqueElements.contains(element) {
                uniqueElements.append(element)
            }
        }
    }
}







