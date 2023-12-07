//
//  UIImageExtension.swift
//  MerqueoUIKit
//
//  Created by Juan Camilo Fonseca Gomez on 7/12/23.
//

import Foundation
import UIKit
extension UIImageView {
    @MainActor
    func getImageFromData(url: URL?, urlSession: URLSession = URLSession.shared)  {
        guard let url = url else { return }
        Task {
            guard var (data, _) = try? await urlSession.data(from: url) else { return }
            let image = UIImage(data: data)
            self.image = image
        }
    }
}
