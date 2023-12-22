//
//  MovieCell.swift
//  MerqueoUIKit
//
//  Created by Juan Camilo Fonseca Gomez on 9/12/23.
//

import UIKit

class MovieCell: UICollectionViewCell {
    
    private var container: UIView!
    private var label: UILabel!
    static var reuseIdetifier: String = "MoviewCell"
    private var uiImage: UIImageView!
    private var uiStack: UIStackView!
    private var containerForImage: UIView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addContainer()
        addImage()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func prepareForReuse() {
        uiImage.image = UIImage(systemName: "square")
    }
    func setUp(viewModelCell: MoviewCellViewModelProtocol ) {
        guard let viewModel = viewModelCell as? MovieCellViewModel else{ return }
        uiImage.getImageFromData(url: viewModel.image)
    }
}
extension MovieCell {
    private func addContainer() {
        container = UIView()
        addSubview(container)
        container.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            container.centerXAnchor.constraint(equalTo: centerXAnchor),
            container.centerYAnchor.constraint(equalTo: centerYAnchor),
            container.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            container.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
            container.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            container.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10)
            
        ])
        container.backgroundColor = .white
        container.layer.cornerRadius = 20
    }
    private func addImage() {
        uiImage = UIImageView()
        container.addSubview(uiImage)
        uiImage.translatesAutoresizingMaskIntoConstraints = false
        uiImage.image = UIImage(systemName: "multiply.circle.fill")
        uiImage.contentMode = .scaleAspectFit
        NSLayoutConstraint.activate([
            uiImage.centerYAnchor.constraint(equalTo: container.centerYAnchor),
            uiImage.centerXAnchor.constraint(equalTo: container.centerXAnchor),
            uiImage.widthAnchor.constraint(equalTo: container.widthAnchor, multiplier: 1.0),
            uiImage.topAnchor.constraint(equalTo: container.topAnchor, constant: 0)
        ])

        uiImage.layer.cornerRadius = 20
        uiImage.layer.borderWidth = 2
        uiImage.clipsToBounds = true
        uiImage.layer.borderColor = UIColor.white.cgColor
    }
}
#Preview(body: {
    MovieCell()
})
