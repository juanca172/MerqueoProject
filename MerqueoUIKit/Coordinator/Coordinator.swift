//
//  Coordinator.swift
//  MerqueoUIKit
//
//  Created by Juan Camilo Fonseca Gomez on 14/12/23.
//

import Foundation
import UIKit

protocol Coordinator: AnyObject {
    var getRootViewController: UIViewController { get }
    func presentViewController(viewController: UIViewController)
    func pushViewController(ViewController: UIViewController)
}

final class NavContollerViews {
    
}
