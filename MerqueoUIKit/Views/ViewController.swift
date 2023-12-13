//
//  ViewController.swift
//  MerqueoUIKit
//
//  Created by Juan Camilo Fonseca Gomez on 5/12/23.
//

import UIKit
import Combine

class ViewController: UIViewController, UIScrollViewDelegate, UICollectionViewDelegate {
    
    var dataSource: UICollectionViewDiffableDataSource<Int, Info>?
    var viewModel: ViewModelProtocol?
    var anyCancellable: AnyCancellable?
    var recharge = false
    
    lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionLayout())
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(collectionView)
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        collectionView.backgroundColor = .blue
        configureViewModel()
        configureDataSource()
        collectionView.delegate = self
        // Do any additional setup after loading the view.
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
        self.collectionView.register(MovieCell.self, forCellWithReuseIdentifier: MovieCell.reuseIdetifier)
        dataSource = UICollectionViewDiffableDataSource<Int, Info>(collectionView: collectionView) { collectionView, indexPath, itemIdentifier in
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MovieCell.reuseIdetifier, for: indexPath) as? MovieCell else { assert(false, "Error to cast") }
            let viewModel = MovieCellViewModel(info: itemIdentifier)
            cell.setUp(viewModelCell: viewModel)
            return cell
        }
    }
}
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

