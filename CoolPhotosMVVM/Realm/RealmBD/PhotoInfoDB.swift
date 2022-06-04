//
//  PhotoDataBase.swift
//  CoolPhotosMVVM
//
//  Created by Александр Александров on 02.06.2022.
//

import RealmSwift

final class PhotoInfoDB: Object {
    @Persisted(primaryKey: true) var _id: ObjectId
    @Persisted var photoUrl: String
    @Persisted var nameAvtor: String
    @Persisted var creatDate: String
    @Persisted var location: String
    @Persisted var numberOfDownloads: String
    
    convenience init(photoUrl: String, nameAvtor: String, creatDate: String, location: String, numberOfDownloads: String) {
        self.init()
        self.photoUrl = photoUrl
        self.nameAvtor = nameAvtor
        self.creatDate = creatDate
        self.location = location
        self.numberOfDownloads = numberOfDownloads
    }
}
