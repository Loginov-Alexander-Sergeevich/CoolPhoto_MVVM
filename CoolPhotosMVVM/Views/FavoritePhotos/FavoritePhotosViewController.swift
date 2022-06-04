//
//  FavoritePhotosViewController.swift
//  CoolPhotosMVVM
//
//  Created by Александр Александров on 02.06.2022.
//

import UIKit

final class FavoritePhotosViewController: UIViewController {

    var viewModel: FavoritePhotosViewModelProtocol!
    var favoritePhotosDataSource: UICollectionViewDiffableDataSource<FavoritePhotosSection, PhotoInfoDB>?
    
    private lazy var favoritePhotosCollectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: createCompositionalLayout())
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        collectionView.backgroundColor = .clear
        collectionView.register(FavoritePhotosCollectionViewCell.self, forCellWithReuseIdentifier: FavoritePhotosCollectionViewCell.identifairCell)
        collectionView.delegate = self
        return  collectionView
    }()
    
    private let activityIndicator: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView()
        activityIndicator.color = .systemRed
        activityIndicator.style = UIActivityIndicatorView.Style.large
        return activityIndicator
    }()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        viewModel = FavoritePhotosViewModel()
        setView()
        cofigurationConstraints()
        

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configurationNavigationController()
        
        self.createDataSource()
        self.reloadData()
    }
    
    private func configurationNavigationController() {
        navigationItem.title = viewModel.title
    }
    
    private func setView() {
        view.addSubviews([favoritePhotosCollectionView, activityIndicator])
    }
    
    private func cofigurationConstraints() {
        activityIndicator.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
    
    private func configure<T: FavoritePhotosCollectionViewCellProtocol>(_ cellId: T.Type, with photoInfoDB: PhotoInfoDB, for indexPath: IndexPath) -> T {
        guard let cell = favoritePhotosCollectionView.dequeueReusableCell(withReuseIdentifier: cellId.identifairCell, for: indexPath) as? T else {
            fatalError("\(cellId)")
        }
        cell.configure(with: photoInfoDB)
        return cell
    }
    
    private func createDataSource() {
        favoritePhotosDataSource = UICollectionViewDiffableDataSource<FavoritePhotosSection, PhotoInfoDB>(collectionView: favoritePhotosCollectionView){ collectionView, indexPath, itemIdentifier in
            let section = FavoritePhotosSection(rawValue: indexPath.section)
            
            switch section {
            default:
                return self.configure(FavoritePhotosCollectionViewCell.self, with: itemIdentifier, for: indexPath)
            }
        }
    }
    
    private func reloadData() {
        
        self.activityIndicator.startAnimating()
        viewModel.timer?.invalidate()
        viewModel.timer = Timer.scheduledTimer(withTimeInterval: 0.9, repeats: true, block: { [weak self] _ in
            
            var snapshot = NSDiffableDataSourceSnapshot<FavoritePhotosSection, PhotoInfoDB>()
            let items = RealmManadger.shared.items()
            FavoritePhotosSection.allCases.forEach { section in
                
                snapshot.appendSections([section])
                snapshot.appendItems(Array(items), toSection: section)
            }
            self?.favoritePhotosDataSource?.apply(snapshot)
            self?.activityIndicator.stopAnimating()
        })
        

    }
    
    private func createCompositionalLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { sectionIndex, layoutEnvironment in
            let section = FavoritePhotosSection(rawValue: sectionIndex)!

            switch section {
            case .favoritePhoto:
                return self.createfavoritePhotosSection(using: section)
            }
        }
        
        let config = UICollectionViewCompositionalLayoutConfiguration()
        config.interSectionSpacing = 5
        layout.configuration = config
        return layout
    }
    
    private func createfavoritePhotosSection(using section: FavoritePhotosSection) -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.5), heightDimension: .fractionalHeight(1))
        let layoutItem = NSCollectionLayoutItem(layoutSize: itemSize)
        layoutItem.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 5, bottom: 5, trailing: 0)

        let layoutGroupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalWidth(0.5))
        let layoutGroup = NSCollectionLayoutGroup.horizontal(layoutSize: layoutGroupSize, subitems: [layoutItem])
        layoutGroup.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 5, bottom: 0, trailing: 5)

        let layoutSection = NSCollectionLayoutSection(group: layoutGroup)

        return layoutSection
    }
}

extension FavoritePhotosViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let dataPhoto = viewModel.onSelect(at: indexPath)
        let photoDetailsViewController = PhotoDetailsViewController()
        photoDetailsViewController.viewModel = dataPhoto
        navigationController?.pushViewController(photoDetailsViewController.self, animated: true)
    }
}
