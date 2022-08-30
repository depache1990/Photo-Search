//
//  SearchResults.swift
//  Photo Search
//
//  Created by Anton Duplin on 25/8/22.
//

import Foundation

struct SearchResults: Decodable {
    let total: Int
    let results: [UnsplashPhoto]
}

struct UnsplashPhoto: Decodable {
    let width: Int
    let height: Int
    let urls: URLS
}

struct URLS: Codable {
    let full: String
    let regular: String
    let small_s3: String
}

