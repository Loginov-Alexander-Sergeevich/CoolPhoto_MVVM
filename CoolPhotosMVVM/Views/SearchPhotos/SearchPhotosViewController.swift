//
//  SearchPhotosViewController.swift
//  CoolPhotosMVVM
//
//  Created by Александр Александров on 02.06.2022.
//

import UIKit

protocol SearchPhotosViewControllerProtocol: AnyObject {
    func onSelect(resultsRequest: ResultsRequest)
}

final class SearchPhotosViewController: UIViewController {
    
    private var viewModel: SearchPhotosViewModelProtocol! 
    var photoCollectionDataSource: UICollectionViewDiffableDataSource<SearchPhotoSection, ResultsRequest>?
    
    private lazy var searchContriller: UISearchController = {
        let search = UISearchController()
        search.searchBar.sizeToFit()
        search.searchBar.placeholder = "Поиск фото"
        search.hidesNavigationBarDuringPresentation = false
        search.obscuresBackgroundDuringPresentation = false
        search.searchBar.delegate = self
        return search
    }()
    
    private lazy var photoCollectionCollectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: createCompositionalLayout())
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        collectionView.backgroundColor = .clear
        collectionView.register(SearchPhotosCollectionViewCell.self, forCellWithReuseIdentifier: SearchPhotosCollectionViewCell.reuseIdentifier)
        
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
        viewModel = SearchPhotosViewModel()
        setView()
        cofigurationConstraints()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configurationNavigationController()
    }
    
    private func configurationNavigationController() {
        navigationItem.searchController = searchContriller
        navigationItem.title = viewModel.title
    }
    
    private func setView() {
        view.addSubviews([photoCollectionCollectionView, activityIndicator])
    }
    
    private func cofigurationConstraints() {
        activityIndicator.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
    
    private func configure<T: SearchPhotosCollectionViewCellProtocol>(_ CellId: T.Type, with resultsRequest: ResultsRequest, for indexPath: IndexPath) -> T {
        guard let cell = photoCollectionCollectionView.dequeueReusableCell(withReuseIdentifier: CellId.reuseIdentifier, for: indexPath) as? T else {
            fatalError("\(CellId)")
        }
        cell.configure(with: resultsRequest)
        return cell
    }
    
    private func createDataSource() {
        photoCollectionDataSource = UICollectionViewDiffableDataSource<SearchPhotoSection, ResultsRequest>(collectionView: photoCollectionCollectionView){ collectionView, indexPath, itemIdentifier in
            let section = SearchPhotoSection(rawValue: indexPath.section)
            
            switch section {
            default:
                return self.configure(SearchPhotosCollectionViewCell.self, with: itemIdentifier, for: indexPath)
            }
        }
    }
    
    private func reloadData() {
        var snapshot = NSDiffableDataSourceSnapshot<SearchPhotoSection, ResultsRequest>()
        
        SearchPhotoSection.allCases.forEach { section in
            snapshot.appendSections([section])
            snapshot.appendItems(viewModel!.searchPhotosResultsRequest, toSection: section)
        }
        photoCollectionDataSource?.apply(snapshot)
    }
    
    private func createCompositionalLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { sectionIndex, layoutEnvironment in
            let section = SearchPhotoSection(rawValue: sectionIndex)!

            switch section {
            case .searchPhoto:
                return self.createPhotoCollectionSection(using: section)
            }
        }
        
        let config = UICollectionViewCompositionalLayoutConfiguration()
        config.interSectionSpacing = 5
        layout.configuration = config
        return layout
    }
    
    private func createPhotoCollectionSection(using section: SearchPhotoSection) -> NSCollectionLayoutSection {
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

extension SearchPhotosViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        self.activityIndicator.startAnimating()
        viewModel.timer?.invalidate()
        viewModel.timer = Timer.scheduledTimer(withTimeInterval: 0.9, repeats: false, block: {[weak self] _ in
            
            self?.viewModel.searchPhoto(name: searchText, completion: {
                DispatchQueue.main.async {
                    self?.createDataSource()
                    self?.reloadData()
                    self?.activityIndicator.stopAnimating()
                }
            })
        })
    }
}

extension SearchPhotosViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let dataPhoto = viewModel.onSelect(at: indexPath)
        let photoDetailsViewController = PhotoDetailsViewController()
        photoDetailsViewController.viewModel = dataPhoto
        navigationController?.pushViewController(photoDetailsViewController.self, animated: true)
    }
}
