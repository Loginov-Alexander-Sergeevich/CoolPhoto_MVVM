//
//  SearchPhotosRequest.swift
//  CoolPhotosMVVM
//
//  Created by Александр Александров on 02.06.2022.
//

import Foundation

protocol SearchPhotosRequestProtocol {
    func requestPhoto(searchName: String, completion: @escaping (Data?, Error?) -> ())
    func apiAccessKey() -> [String: String]?
    func dataTask(from request: URLRequest, completion: @escaping (Data?, Error?) -> ()) -> URLSessionDataTask
}

final class SearchPhotosRequest: SearchPhotosRequestProtocol {
    
    /// Запрос к серверу для поска фотографий
    /// - Parameters:
    ///   - serchPhotoName: Имя искомой фото
    ///   - completion: Функция для получения данных
    func requestPhoto(searchName: String, completion: @escaping (Data?, Error?) -> ()) {

        let parameters = ready(params: searchName)
        let url = create(url: parameters)
        var reguest = URLRequest(url: url)
        reguest.allHTTPHeaderFields = apiAccessKey()
        reguest.httpMethod = "get"

        let task = dataTask(from: reguest, completion: completion)
        task.resume()
    }
    
    /// Параметры запроса (Сохраняет словарь параметров запроса)
    /// - Parameter namePhoto: Название искомой фотографии
    /// - Returns: Параметры запроса
    private func ready(params name: String?) -> [String: String] {
        
        var parameters = [String: String]()
        parameters["query"] = name
        parameters["page"] = String(1)
        parameters["per_page"] = String(30)
        
        return parameters
    }
    
    /// Содай URL
    /// - Parameter params: Кусочки URL
    /// - Returns: Готовый URL
    private func create(url: [String: String]) -> URL {
        
        var components = URLComponents()
        components.scheme = "https"
        components.host = "api.unsplash.com"
        components.path = "/search/photos"
        components.queryItems = url.map{ URLQueryItem(name: $0, value: $1) }
        
        return components.url!
    }
}

extension SearchPhotosRequestProtocol {
    func dataTask(from request: URLRequest, completion: @escaping (Data?, Error?) -> ()) -> URLSessionDataTask {
        return URLSession.shared.dataTask(with: request) { data, respons, error in

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
