//
//  ViewModel.swift
//  MerqueoUIKit
//
//  Created by Juan Camilo Fonseca Gomez on 7/12/23.
//

import Foundation
import Combine
import UIKit
protocol ViewModelProtocol {
    func start()
    func getNumberOfSections() -> Int
    func getNumberOfRows(_ sections: Int)-> Int
    func snapshotToApply()
    var anyPublisher: AnyPublisher<NSDiffableDataSourceSnapshot<Int, Info>, Never> { get }
    func loadNextPage()
    func infoForDetail(index: IndexPath) -> Info
    func updateSearchData(searchBarText: String?)
}
final class ViewModel {
    var informacion: [[Info]] = [] {
        didSet {
            snapshotToApply() 
        }
    }
    var filteredInformation: [[Info]] = [] {
        didSet {
            inSearchMode = true
            snapshotToApply()
        }
    }
    var page = 1
    let publisherData = PassthroughSubject<NSDiffableDataSourceSnapshot<Int, Info>, Never>()
    let dataManager: MovieDataManagerProtocol
    var anyPublisher: AnyPublisher<NSDiffableDataSourceSnapshot<Int, Info>, Never> {
        publisherData.eraseToAnyPublisher()
    }
    var inSearchMode = false
    init(DataManager: MovieDataManagerProtocol = MovieDataManager(networkProvider: NetworkProvider())) {
        self.dataManager = DataManager
    }
    func getData(page: Int) {
        Task {
            do {
                let data: MovieModel = try await dataManager.getDataFromMoview(pageToFectch: page)
                informacion.append(data.results)
                inSearchMode = false
            } catch {
                print("Error \(error.localizedDescription)")
            }
        }
    }
}
extension ViewModel: ViewModelProtocol {
    func infoForDetail(index: IndexPath) -> Info {
        if !inSearchMode {
            let data = informacion[index.section][index.row]
            return data
        } else {
            let data = filteredInformation[index.section][index.row]
            return data
        }
    }
    func loadNextPage() {
        page += 1
        getData(page: page)
    }
    func start() {
        getData(page: page)
    }
    func getNumberOfSections() -> Int {
        return informacion.count
    }
    func getNumberOfRows(_ sections: Int) -> Int {
        return informacion[sections].count
    }
    func getNumberOfSectionFilter() -> Int {
        filteredInformation.count
    }
    func getNumberOfRowsFilter(section: Int) -> Int {
        return filteredInformation[section].count
    }
    func snapshotToApply() {
        if !inSearchMode {
            var snapShot = NSDiffableDataSourceSnapshot<Int, Info>()
            var sections: [Int] = []
            for i in 0..<getNumberOfSections() {
                sections.append(i)
            }
            snapShot.appendSections(sections)
            for i in sections {
                snapShot.appendItems(informacion[i], toSection: i)
                publisherData.send(snapShot)
            }
        } else {
            var snapShot = NSDiffableDataSourceSnapshot<Int, Info>()
            var sections: [Int] = []
            for i in 0..<getNumberOfSectionFilter() {
                sections.append(i)
            }
            snapShot.appendSections(sections)
            for i in sections {
                snapShot.appendItems(filteredInformation[i], toSection: i)
                publisherData.send(snapShot)
            }
        }
    }
}
//MARK: filterLogic
extension ViewModel {
    func updateSearchData(searchBarText: String?) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.filteredInformation = []
            if let searchText = searchBarText?.lowercased() {
                guard !searchText.isEmpty else { self.inSearchMode = false;self.snapshotToApply();return }
                for i in 0..<self.getNumberOfSections() {
                    self.filteredInformation.append( self.informacion[i].filter({ info in
                        info.title.lowercased().contains(searchText)
                    }))
                }
            }
        }
    }
}
