//
//  JSONParser.swift
//  RepositoryViewer
//
//  Created by Ehsan on 12/08/2018.
//  Copyright © 2018 Ali C. All rights reserved.
//

import Foundation

// Struct to hold the url of each repository
struct RepositoryURL: Codable {
    var url: String?
    
    enum CodingKeys: String, CodingKey {
        case url
    }
}


// struct to hold the needed properties of a single repository
struct SingleRepository: Codable {
    var name: String?
    var stars: Int?
    var forks: Int?
    var lastUpdate: String?
    var language: String?
    var description: String?
    
    enum CodingKeys: String, CodingKey {
        case name
        case stars = "stargazers_count"
        case forks
        case lastUpdate = "updated_at"
        case language
        case description
    }
}




