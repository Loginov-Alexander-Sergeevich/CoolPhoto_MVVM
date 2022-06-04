//
//  PhotoSearchResultModel.swift
//  CoolPhotosMVVM
//
//  Created by Александр Александров on 02.06.2022.
//

import Foundation

struct PhotoSearchResultModel: Decodable, Hashable {
    let total: Int?
    let results: [ResultsRequest]?
}

struct ResultsRequest: Decodable, Hashable {
    let id: String?
    let created_at: String
    let urls: [URLKing.RawValue: String?]
    let user: User

    enum URLKing: String {
        case raw
        case full
        case regular
        case small
        case thumb
    }
}

struct User: Decodable, Hashable {
    let firstName: String?
    let lastName: String?
    let location: String?


    enum CodingKeys: String, CodingKey {
        case firstName = "first_name"
        case lastName = "last_name"
        case location
    }
}
