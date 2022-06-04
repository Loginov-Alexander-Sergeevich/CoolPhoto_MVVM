//
//  PhotoDetailsViewModel.swift
//  CoolPhotosMVVM
//
//  Created by Александр Александров on 02.06.2022.
//

import Foundation
import SDWebImage

protocol PhotoDetailsViewModelProtocol: AnyObject {
    var photoDataBase: PhotoInfoDB? {get}
    var authorName: String? {get}
    var location: String? {get}
    var photoImage: String? {get}
    var dateOfCreation: String? {get}
    var numberOfDownloadsThePhoto: String {get set}
    var isFavorite: Bool? {get set}
    
    init()
    init(searchPhotosResultsRequest: ResultsRequest)
    init(photoDB: PhotoInfoDB)
    
    
    var updateDataSearchPhoto: ((PhotoDetailsViewModelProtocol) -> ())? {get set}
    var updateDataFavoritePhoto: ((PhotoDetailsViewModelProtocol) -> ())? {get set}
    func update() 
    
    func saveDataPhoto()
    func deletDataPhoto()
    
    func requestStatisticsPhoto(_ id: String)
}

final class PhotoDetailsViewModel: PhotoDetailsViewModelProtocol {
    

    var photoDataBase: PhotoInfoDB?
    
    var photoImage: String? {
        searchPhotosResultsRequest.urls["regular"]!
    }
    
    var authorName: String? {
        "Автор - \(searchPhotosResultsRequest.user.firstName ?? "") \(searchPhotosResultsRequest.user.lastName ?? "")"
    }
    
    var dateOfCreation: String? {
        let date = convertDateFormat(inputDate: searchPhotosResultsRequest.created_at)
        return "Дата создания - \(date)"
    }
    
    var location: String? {
        "Локация - \(searchPhotosResultsRequest.user.location ?? "Неизвестно")"
    }
    
    var numberOfDownloadsThePhoto: String = ""
    
    var isFavorite: Bool?
    
    var updateDataSearchPhoto: ((PhotoDetailsViewModelProtocol) -> ())?
    var updateDataFavoritePhoto: ((PhotoDetailsViewModelProtocol) -> ())?
    
    private var searchPhotosResultsRequest: ResultsRequest
    private var numberDownloadsPhoto: Downloads?
    
    init(){
        self.searchPhotosResultsRequest = ResultsRequest(id: "1", created_at: "", urls: [:], user: User(firstName: "", lastName: "", location: ""))
        self.photoDataBase = PhotoInfoDB()
    }
    
    convenience init(searchPhotosResultsRequest: ResultsRequest) {
        self.init()
        self.searchPhotosResultsRequest = searchPhotosResultsRequest
        
    }
    
    convenience init(photoDB: PhotoInfoDB) {
        self.init()
        self.photoDataBase = photoDB
        
    }
    
    
    func requestStatisticsPhoto(_ id: String) {
        NetworkManadger.shared.requestPhoto(id: id) { [weak self] statistic in
            guard let statistica = statistic?.downloads.total else { return }
            
            self?.numberOfDownloadsThePhoto = "Колличество скачиваний - \(statistica)"
            self?.updateDataSearchPhoto!(self!)
        }
    }
    
    func saveDataPhoto() {
        RealmManadger.shared.addItem(photoUrl: self.photoImage!,
                                     nameAvtor: self.authorName ?? "Неизвестно",
                                     creatDate: self.dateOfCreation ?? "Неизвестно" ,
                                     location: self.location ?? "Неизвестно",
                                     numberOfDownloads: self.numberOfDownloadsThePhoto)
        

    }
    
    func deletDataPhoto() {
        RealmManadger.shared.deleteItem(at: photoDataBase!._id)
        
    }
    
    func update() {
        requestStatisticsPhoto(searchPhotosResultsRequest.id!)
        self.updateDataFavoritePhoto?(self)
    }
    
    private func convertDateFormat(inputDate: String) -> String {
        let dateFormater = DateFormatter()
        dateFormater.dateFormat = "yyyy'-'MM'-'dd'T'HH':'mm':'ss'-'HH':'mm"
        
        guard let asDate = dateFormater.date(from: inputDate) else { return "Не смог получить дату" }
        
        let formateDate = DateFormatter()
        formateDate.dateFormat = "dd.MM.yyyy"
        
        let asString = formateDate.string(from: asDate)
        
        return asString
    }
}
