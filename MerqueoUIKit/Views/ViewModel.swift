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
}
final class ViewModel {
    var informacion: [[Info]] = []
    let publisherData = PassthroughSubject<[Info], Never>()
    let dataManager: MovieDataManagerProtocol
    var anyPublisher: AnyPublisher<[Info], Never> {
        publisherData.eraseToAnyPublisher()
    }
    var snapShot = NSDiffableDataSourceSnapshot<Int, Info>()
    init(DataManager: MovieDataManagerProtocol = MovieDataManager(networkProvider: NetworkProvider())) {
        self.dataManager = DataManager
        start()
    }
    func getData(page: Int) {
        Task {
            let data: MovieModel = await dataManager.getDataFromMoview()
            informacion.append(data.results)
        }
    }
}
extension ViewModel: ViewModelProtocol {
    func start() {
        getData(page: 1)
    }
    
    func getNumberOfSections() -> Int {
        return informacion.count
    }
    
    func getNumberOfRows(_ sections: Int) -> Int {
        return informacion[sections].count
    }
    
    func snapshotToApply() {
        var sections: [Int] = []
        for i in 1..<getNumberOfSections() {
            sections.append(i)
        }
        snapShot.appendSections(sections)
        for i in sections {
            snapShot.appendItems(informacion[i], toSection: i)
            publisherData.send(informacion[i])
        }
    }
}
