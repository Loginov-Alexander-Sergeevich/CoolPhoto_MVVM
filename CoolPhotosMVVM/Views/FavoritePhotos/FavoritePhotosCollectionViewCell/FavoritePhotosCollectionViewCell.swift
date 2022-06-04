//
//  FavoritePhotosCollectionViewCell.swift
//  CoolPhotosMVVM
//
//  Created by Александр Александров on 02.06.2022.
//

import UIKit

protocol FavoritePhotosCollectionViewCellProtocol {
    static var identifairCell: String {get set}
    func configure(with app: PhotoInfoDB)
}

final class FavoritePhotosCollectionViewCell: UICollectionViewCell, FavoritePhotosCollectionViewCellProtocol {
    
    static var identifairCell: String = "FavoritePhotosCollectionViewCell"
    
    private let photoImageView: UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setCell()
        cofigurationConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setCell() {
        contentView.addSubviews([photoImageView])
    }
    
    private func cofigurationConstraints() {
        photoImageView.snp.makeConstraints { make in
            make.width.height.equalTo(100)
            make.edges.equalTo(self.contentView)
        }
    }
    
    func configure(with app: PhotoInfoDB) {
        let urlImage = URL(string: app.photoUrl)
        
        photoImageView.sd_setImage(with: urlImage, completed: nil)
        
    }
    
    
}
