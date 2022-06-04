//
//  SearchPhotosCollectionViewCell.swift
//  CoolPhotosMVVM
//
//  Created by Александр Александров on 02.06.2022.
//

import UIKit

protocol SearchPhotosCollectionViewCellProtocol {
    static var reuseIdentifier: String { get }
    func configure(with app: ResultsRequest)
}

final class SearchPhotosCollectionViewCell: UICollectionViewCell, SearchPhotosCollectionViewCellProtocol {
    static var reuseIdentifier: String = "SearchPhotosCollectionViewCell"
    
    private let photoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.clipsToBounds = true
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
    
    func configure(with app: ResultsRequest) {
        let photoURL = app.urls["regular"]
        
        guard let imageUrl = photoURL else { return }
        
        let url = URL(string: imageUrl!)
        
        photoImageView.sd_setImage(with: url, completed: nil)
    }
}
