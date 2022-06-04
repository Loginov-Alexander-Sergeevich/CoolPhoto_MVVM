//
//  PhotoDetailsRequest.swift
//  CoolPhotosMVVM
//
//  Created by Александр Александров on 02.06.2022.
//

import Foundation

protocol PhotoDetailsRequestProtocol {
    func requestStatistics(byId: String, completion: @escaping (Data?, Error?) -> ())
    func apiAccessKey() -> [String: String]?
    func dataTask(from request: URLRequest, completion: @escaping (Data?, Error?) -> ()) -> URLSessionDataTask
}

final class PhotoDetailsRequest: PhotoDetailsRequestProtocol {
    
    func requestStatistics(byId: String, completion: @escaping (Data?, Error?) -> ()) {
        
        let url = create(url: byId)
        var reguest = URLRequest(url: url)
        reguest.allHTTPHeaderFields = apiAccessKey()
        reguest.httpMethod = "get"

        let task = dataTask(from: reguest, completion: completion)
        task.resume()
        
    }
    
    private func create(url idPhoto: String) -> URL {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "api.unsplash.com"
        components.path = "/photos/\(idPhoto)/statistics"
        return components.url!
    }
}

extension PhotoDetailsRequestProtocol {
    func dataTask(from request: URLRequest, completion: @escaping (Data?, Error?) -> ()) -> URLSessionDataTask {
        return URLSession.shared.dataTask(with: request) { data, respons, error in
            // Получил данные вернись в основной поток
            DispatchQueue.main.async {
                completion(data, error)
            }
        }
    }
    
    /// Ключь доступа к API
    internal func apiAccessKey() -> [String: String]? {
        var heders = [String: String]()
        heders["Authorization"] = "Client-ID kqt3g0t07hMvFbYA45ojbPnMzOV6eSZBDYnlwCyugDA"
        return heders
    }
}
