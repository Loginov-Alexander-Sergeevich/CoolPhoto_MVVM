//
//  PhotoDetailsViewController.swift
//  CoolPhotosMVVM
//
//  Created by Александр Александров on 02.06.2022.
//

import UIKit
import SnapKit

final class PhotoDetailsViewController: UIViewController {
    
    var viewModel: PhotoDetailsViewModelProtocol!
    
    private let photoImageView: UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()
    
    private let nameAuthorLabel: UILabel = {
        let label = UILabel()
        label.font = label.font.withSize(20)
        return label
    }()
    
    private let dateOfCreationLabel: UILabel = {
        let label = UILabel()
        label.font = label.font.withSize(20)
        return label
    }()
    
    private let locationLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = label.font.withSize(20)
        return label
    }()
    
    private var numberOfDownloadsThePhotoLabel: UILabel = {
        let label = UILabel()
        label.font = label.font.withSize(20)
        return label
    }()
    
    private let verticalStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .leading
        stackView.spacing = 10
        return stackView
    }()
    
    private let addToFavoritesButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "heart.fill"), for: .normal)
        button.tintColor = .systemGray
        button.backgroundColor = .clear
        button.addTarget(self, action: #selector(addPhotoInPhotoDataBase), for: .touchUpInside)
        return button
    }()
    
    private let activityIndicator: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView()
        activityIndicator.color = .red
        activityIndicator.style = UIActivityIndicatorView.Style.large
        return activityIndicator
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setView()
        cofigurationConstraints()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateViewModel()
    }
    
    private func setView() {
        view.addSubviews([photoImageView, verticalStackView, addToFavoritesButton, activityIndicator])
        verticalStackView.addArrangedSubviews([nameAuthorLabel, UIView(), dateOfCreationLabel, locationLabel, numberOfDownloadsThePhotoLabel])
    }
    
    private func cofigurationConstraints() {
        
        let botomSize = CGSize(width: 50, height: 50)
        
        photoImageView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.bottom.equalTo(self.verticalStackView.snp.top).offset(-10)
            make.width.equalToSuperview()
        }
        
        verticalStackView.snp.makeConstraints { make in
            make.height.equalTo(130)
            make.bottom.equalTo(addToFavoritesButton.snp.top)
            make.leading.trailing.equalToSuperview().inset(10)
        }
        
        addToFavoritesButton.snp.makeConstraints { make in
            make.size.equalTo(botomSize)
            make.bottom.equalTo(self.view.safeAreaLayoutGuide).offset(-10)
            make.centerX.equalToSuperview()
        }
        
        activityIndicator.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
    
    private func updateViewModel() {
        activityIndicator.startAnimating()
        
        viewModel.updateDataFavoritePhoto = { [weak self] viewModel in
            self?.nameAuthorLabel.text = viewModel.photoDataBase?.nameAvtor
            self?.dateOfCreationLabel.text = viewModel.photoDataBase?.creatDate
            self?.locationLabel.text = viewModel.photoDataBase?.location
            self?.numberOfDownloadsThePhotoLabel.text = viewModel.photoDataBase?.numberOfDownloads
            
            guard let urlPhoto = URL(string: viewModel.photoDataBase?.photoUrl ?? "") else { return }
            self?.photoImageView.sd_setImage(with: urlPhoto, completed: nil)
            viewModel.isFavorite = false
            self?.addToFavoritesButton.tintColor = .red
            self?.activityIndicator.stopAnimating()
        }

        viewModel.updateDataSearchPhoto = { [weak self] viewModel in
            self?.nameAuthorLabel.text = viewModel.authorName
            self?.dateOfCreationLabel.text = viewModel.dateOfCreation
            self?.locationLabel.text = viewModel.location
            self?.numberOfDownloadsThePhotoLabel.text = viewModel.numberOfDownloadsThePhoto
            
            guard let urlPhoto = URL(string: viewModel.photoImage ?? "") else { return }
            self?.photoImageView.sd_setImage(with: urlPhoto, completed: nil)
            viewModel.isFavorite = true
            self?.addToFavoritesButton.tintColor = .gray
            self?.activityIndicator.stopAnimating()
        }
        
        viewModel.update()

    }
    
    @objc private func addPhotoInPhotoDataBase() {
        if viewModel.isFavorite! {
            alertAddPhoto()
        } else {
            alertDeletPhoto()
        }
    }
    
    private func alertAddPhoto() {
        let aletr = UIAlertController(title: """
                                     Добавить в "Любимые фото"
                                     """,
                                      message: nil, preferredStyle: .alert)
        let cancel = UIAlertAction(title: "Отмена", style: .destructive, handler: nil)
        let add = UIAlertAction(title: "Добавить", style: .default) { [weak self] _ in
            
            self?.viewModel?.saveDataPhoto()
            self?.navigationController?.popViewController(animated: true)
        }
        
        aletr.addAction(cancel)
        aletr.addAction(add)
        
        self.present(aletr, animated: true, completion: nil)
    }
    
    private func alertDeletPhoto() {
        let aletr = UIAlertController(title: "Удалить фото?",
                                      message: nil, preferredStyle: .alert)
        let cancel = UIAlertAction(title: "Отмена", style: .destructive, handler: nil)
        let delet = UIAlertAction(title: "Удалить", style: .default) { [weak self] _ in

            self?.viewModel?.deletDataPhoto()
            self?.navigationController?.popViewController(animated: true)
        }
        
        aletr.addAction(cancel)
        aletr.addAction(delet)
        
        self.present(aletr, animated: true, completion: nil)
    }
}
