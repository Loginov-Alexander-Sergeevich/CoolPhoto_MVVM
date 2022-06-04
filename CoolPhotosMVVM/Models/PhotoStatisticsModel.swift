//
//  PhotoStatisticsModel.swift
//  CoolPhotosMVVM
//
//  Created by Александр Александров on 02.06.2022.
//

import Foundation

struct PhotoStatisticsModel: Decodable {
    let downloads: Downloads
}

struct Downloads: Decodable {
    let total: Int
}
