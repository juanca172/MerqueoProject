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
        Task {
            guard let url = url else {
                self.image = UIImage(systemName: "square")
                return
            }
            let cache = NSCache<NSString, UIImage>()
            let nsString = NSString(string: url.absoluteString)
            if let cacheImage = cache.object(forKey:nsString) {
                self.image = cacheImage
            } else {
                guard let (data,_) = try? await urlSession.data(from: url) else {
                    return
                }
                let image = UIImage(data: data)
                self.image = image
                if let image {
                    cache.setObject(image, forKey: nsString)
                }
            }
        }
    }
}
