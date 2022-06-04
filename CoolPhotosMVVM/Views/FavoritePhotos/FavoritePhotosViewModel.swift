//
//  FavoritePhotosViewModel.swift
//  CoolPhotosMVVM
//
//  Created by Александр Александров on 02.06.2022.
//

import Foundation

protocol FavoritePhotosViewModelProtocol {
    var timer: Timer? {get set}
    var title: String {get set}
    
    func onSelect(at indexPath: IndexPath) -> PhotoDetailsViewModelProtocol
}

final class FavoritePhotosViewModel: FavoritePhotosViewModelProtocol {
    
    var title: String = "Любимые фото"
    
    var timer: Timer?
    
    func onSelect(at indexPath: IndexPath) -> PhotoDetailsViewModelProtocol {
        let photoDB = RealmManadger.shared.items()
        let item = photoDB[indexPath.item]
        return PhotoDetailsViewModel(photoDB: item)
    }
}
