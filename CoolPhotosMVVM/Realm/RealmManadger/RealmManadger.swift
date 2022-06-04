//
//  RealmManadger.swift
//  CoolPhotosMVVM
//
//  Created by Александр Александров on 02.06.2022.
//

import RealmSwift

final class RealmManadger {
    
    static let shared = RealmManadger()
    private init(){}
    
    let realm = try! Realm()
    var photoDataBase: Results<PhotoInfoDB>!
    let itemPhotoDataBase = PhotoInfoDB()
    
    func items() -> [PhotoInfoDB] {
        photoDataBase = realm.objects(PhotoInfoDB.self)
        let items = self.photoDataBase
        return Array(items!)
    }
    
    func addItem(photoUrl: String, nameAvtor: String, creatDate: String, location: String, numberOfDownloads: String) {
        
        let item = PhotoInfoDB(photoUrl: photoUrl, nameAvtor: nameAvtor, creatDate: creatDate, location: location, numberOfDownloads: numberOfDownloads)
        
        do {
            try self.realm.write{
                self.realm.add(item)
            }
        } catch {
            print(error.localizedDescription)
        }
        print(Realm.Configuration.defaultConfiguration.fileURL!)
    }
    
    func deleteItem(at id: ObjectId) {
        
        photoDataBase = realm.objects(PhotoInfoDB.self)
        
        if let objct = photoDataBase.filter("_id = %@", id as Any).first {
            try! realm.write {
                realm.delete(objct)
            }
        }
    }
    
    
}
