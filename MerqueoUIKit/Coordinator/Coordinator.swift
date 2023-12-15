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

final class NavigationController: UINavigationController {
    init(for viewController: UIViewController) {
        super.init(rootViewController: viewController)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
final class ViewToPresent: Coordinator {
    var getRootViewController: UIViewController {
        let viewControllerMain = ViewController()
        let navigationController = NavigationController(for: viewControllerMain)
        viewControllerMain.navigationItem.title = "Moview"
        viewControllerMain.navigationController?.navigationBar.prefersLargeTitles = true
        viewControllerMain.navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.black]
        viewControllerMain.navigationController?.navigationBar.largeTitleTextAttributes = [.foregroundColor: UIColor.red]
        return navigationController
    }
    func presentViewController(viewController: UIViewController) {
        let view = getRootViewController
        view.children.first?.navigationController?.present(viewController, animated: true)
    }
    func pushViewController(ViewController: UIViewController) {
        let view = getRootViewController
        view.children.first?.navigationController?.pushViewController(ViewController, animated: true)
    }
}
