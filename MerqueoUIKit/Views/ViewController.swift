//
//  ViewController.swift
//  MerqueoUIKit
//
//  Created by Juan Camilo Fonseca Gomez on 5/12/23.
//

import UIKit
import Combine
import SwiftUI

class ViewController: UIViewController, UIScrollViewDelegate, UICollectionViewDelegate {
    
    var dataSource: UICollectionViewDiffableDataSource<Int, Info>?
    var viewModel: ViewModelProtocol?
    var anyCancellable: AnyCancellable?
    var recharge = false
    weak var navBarCoordinator: Coordinator?
    var searchController: UISearchController!
    
    lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionLayout())
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpSearchBar()
        setUpCollectionView()
        configureViewModel()
        configureDataSource()
        collectionView.delegate = self
        // Do any additional setup after loading the view.
    }
    deinit {
        print("Main View Dealocated")
    }
    private func setUpSearchBar() {
        searchController = UISearchController(searchResultsController: nil)
        self.searchController.searchResultsUpdater = self
        self.searchController.obscuresBackgroundDuringPresentation = false
        self.searchController.hidesNavigationBarDuringPresentation = false
        self.searchController.searchBar.placeholder = "Search Moview"
        self.searchController.searchBar.backgroundColor = .lightText
        self.searchController.tabBarItem.badgeColor = .white
        self.navigationItem.searchController = searchController
        self.definesPresentationContext = false
        self.navigationItem.hidesSearchBarWhenScrolling = false
    }
    private func setUpCollectionView() {
        view.addSubview(collectionView)
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        self.collectionView.register(MovieCell.self, forCellWithReuseIdentifier: MovieCell.reuseIdetifier)
        collectionView.backgroundColor = .black
    }
    private func configureViewModel() {
        viewModel = ViewModel()
        viewModel?.start()
        recharge = false
        anyCancellable = viewModel?.anyPublisher
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { complition in
                switch complition {
                case .finished:
                    print("Finish")
                case .failure(let failure):
                    print("Failure \(failure)")
                }
            }, receiveValue: {[weak self] snapshotFinal in
                guard let self = self else { return }
                self.applySnapshot(snapshot: snapshotFinal)
                self.recharge = true
            })
    }
    private func collectionLayout() -> UICollectionViewLayout {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(180.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(180.0))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = 10
        return UICollectionViewCompositionalLayout(section: section)
    }
    private func applySnapshot(snapshot: NSDiffableDataSourceSnapshot<Int, Info>) {
        dataSource?.apply(snapshot)
    }
    private func configureDataSource() {
        dataSource = UICollectionViewDiffableDataSource<Int, Info>(collectionView: collectionView) { collectionView, indexPath, itemIdentifier in
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MovieCell.reuseIdetifier, for: indexPath) as? MovieCell else { assert(false, "Error to cast") }
            let viewModel: MoviewCellViewModelProtocol = MovieCellViewModel(info: itemIdentifier)
            cell.setUp(viewModelCell: viewModel)
            return cell
        }
    }
}
//MARK: Extension for filter
extension ViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        viewModel?.updateSearchData(searchBarText: searchController.searchBar.text)
    }
}
//MARK: Extension for recharge
extension ViewController {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let height = scrollView.contentOffset.y
        if height > (collectionView.contentSize.height) - scrollView.frame.size.height - 160 {
            if recharge {
                recharge = false
                viewModel?.loadNextPage()
            }
        }
    }
}
extension ViewController {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let dataToShow = viewModel?.infoForDetail(index: indexPath) else { return }
        let detailViewModel = ViewDetailMovieViewModel(info: dataToShow)
        let viewController = UIHostingController(rootView: ViewDetailMovie(viewModel: detailViewModel))
        navBarCoordinator?.pushViewController(ViewController: viewController, navigationController: navigationController)
    }
}

