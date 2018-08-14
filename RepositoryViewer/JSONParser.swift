//
//  JSONParser.swift
//  RepositoryViewer
//
//  Created by Ehsan on 12/08/2018.
//  Copyright © 2018 Ali C. All rights reserved.
//

import Foundation

struct Repository: Codable {
    var name: String?
    var url: String?
    
    enum CodingKeys: String, CodingKey {
        case name
        case url
    }
}

// TODO :
// parse the required field for stars, forks and description by parsing the urls



//struct AllRepos: Codable {
//    let allRepositories: [Repository]
//}




