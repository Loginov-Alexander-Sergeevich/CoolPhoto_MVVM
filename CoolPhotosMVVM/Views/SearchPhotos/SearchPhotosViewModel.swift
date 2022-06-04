//
//  SearchPhotosViewModel.swift
//  CoolPhotosMVVM
//
//  Created by Александр Александров on 02.06.2022.
//

import Foundation

protocol SearchPhotosViewModelProtocol: AnyObject {
    var searchPhotosResultsRequest: [ResultsRequest] { get }
    var title: String { get set }
    var timer: Timer? { get set }
    
    func searchPhoto(name: String, completion: @escaping() -> ())

    func onSelect(at indexPath: IndexPath) -> PhotoDetailsViewModelProtocol
}

final class SearchPhotosViewModel: SearchPhotosViewModelProtocol {
    
    var searchPhotosResultsRequest: [ResultsRequest] = []
    
    var timer: Timer?
    
    var title: String = "Коллекция фотографий"
    
    func onSelect(at indexPath: IndexPath) -> PhotoDetailsViewModelProtocol {
        let searchPhotosResultsRequest = searchPhotosResultsRequest[indexPath.item]
        return PhotoDetailsViewModel(searchPhotosResultsRequest: searchPhotosResultsRequest)
    }
    
    func searchPhoto(name: String, completion: @escaping () -> ()) {
        NetworkManadger.shared.requestPhoto(searchName: name) { [weak self] serchResults in
            
            guard let results = serchResults?.results else {return}
            
            self?.searchPhotosResultsRequest = results
            completion()
        }
    }
}
