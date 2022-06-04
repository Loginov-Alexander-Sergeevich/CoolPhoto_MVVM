//
//  NetworkManadger.swift
//  CoolPhotosMVVM
//
//  Created by Александр Александров on 02.06.2022.
//

import Foundation

protocol NetworkManadgerProtocol {
    func decodeJSON<T: Decodable>(type: T.Type, data: Data?) -> T?
}

final class NetworkManadger: NetworkManadgerProtocol {
    
    static let shared = NetworkManadger()
    private init(){}
    
    private var photoDetailsRequest = PhotoDetailsRequest()
    private var searchPhotosRequest = SearchPhotosRequest()
    
    func requestPhoto(searchName: String, completion: @escaping (PhotoSearchResultModel?) -> ()) {

        
        searchPhotosRequest.requestPhoto(searchName: searchName) { data, error in
            if let error = error {
                print("Error received requesting data: \(error.localizedDescription)")
                completion(nil)
            }
            let decode = self.decodeJSON(type: PhotoSearchResultModel.self, data: data)

            completion(decode)
        }
    }
    
    func requestPhoto(id: String, completion: @escaping (PhotoStatisticsModel?) -> ()) {

        
        photoDetailsRequest.requestStatistics(byId: id) { data, error in
            if let error = error {
                print("Не смог получить данные: \(error.localizedDescription)")
                completion(nil)
            }

            let decode = self.decodeJSON(type: PhotoStatisticsModel.self, data: data)

            completion(decode)
        }
    }
}

extension NetworkManadgerProtocol {

    func decodeJSON<T: Decodable>(type: T.Type, data: Data?) -> T? {
        let decoder = JSONDecoder()

        guard let data = data else { fatalError("Не смог получить данные") }
        do {
            let objects = try decoder.decode(type.self, from: data)
            return objects

        } catch let jsonError {
            print("Не смог распарсить данные по твоей модели", jsonError)
            return nil
        }
    }
}
