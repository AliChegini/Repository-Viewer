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
    
    enum CodingKeys: String, CodingKey {
        case name
    }
}


//struct AllRepos: Codable {
//    let allRepositories: [Repository]
//}
