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
}
final class ViewModel {
    var informacion: [[Info]] = [] {
        didSet {
            snapshotToApply() 
        }
    }
    var page = 1
    let publisherData = PassthroughSubject<NSDiffableDataSourceSnapshot<Int, Info>, Never>()
    let dataManager: MovieDataManagerProtocol
    var anyPublisher: AnyPublisher<NSDiffableDataSourceSnapshot<Int, Info>, Never> {
        publisherData.eraseToAnyPublisher()
    }
    init(DataManager: MovieDataManagerProtocol = MovieDataManager(networkProvider: NetworkProvider())) {
        self.dataManager = DataManager
    }
    func getData(page: Int) {
        Task {
            do {
                let data: MovieModel = try await dataManager.getDataFromMoview(pageToFectch: page)
                informacion.append(data.results)
            } catch {
                print("Error \(error.localizedDescription)")
            }
        }
    }
}
extension ViewModel: ViewModelProtocol {
    func infoForDetail(index: IndexPath) -> Info {
        let data = informacion[index.section][index.row]
        return data
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
    func snapshotToApply() {
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
    }
}
