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
    var fullName: String?
    var stars: Int?
    var forks: Int?
    var lastUpdate: String?
    var language: String?
    var description: String?
    
    enum CodingKeys: String, CodingKey {
        case fullName = "full_name"
        case stars = "stargazers_count"
        case forks
        case lastUpdate = "updated_at"
        case language
        case description
    }
    
//    init(name: String?, stars: Int?, forks: Int?, lastUpdate: String?, language: String?, description: String?) {
//        if let nameUnwrapped = name {
//            self.name = nameUnwrapped
//        }
//
//        if let starsUnwrapped = stars {
//            self.stars = starsUnwrapped
//        }
//
//        if let forksUnwrapped = forks {
//            self.forks = forksUnwrapped
//        }
//
//        if let lastUpdateUnwrapped = lastUpdate {
//            self.lastUpdate = lastUpdateUnwrapped
//        }
//
//        if let languageUnwrapped = language {
//            self.language = languageUnwrapped
//        }
//
//        if let descriptionUnwrapped = description {
//            self.description = descriptionUnwrapped
//        }
//    }
}




