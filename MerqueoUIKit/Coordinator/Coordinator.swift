//
//  Coordinator.swift
//  MerqueoUIKit
//
//  Created by Juan Camilo Fonseca Gomez on 14/12/23.
//

import Foundation
import UIKit

protocol Coordinator: AnyObject {
    var getRootViewController: UINavigationController { get }
    func presentViewController(viewController: UIViewController, navigationController: UINavigationController?)
    func pushViewController(ViewController: UIViewController,navigationController: UINavigationController?)
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
    var getRootViewController: UINavigationController {
        let viewControllerMain = ViewController()
        let navigationController = NavigationController(for: viewControllerMain)
        viewControllerMain.navigationItem.title = "Movie"
        viewControllerMain.navBarCoordinator = self
        viewControllerMain.navigationController?.navigationBar.prefersLargeTitles = true
        viewControllerMain.navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.black]
        viewControllerMain.navigationController?.navigationBar.largeTitleTextAttributes = [.foregroundColor: UIColor.red]
        return navigationController
    }
    func presentViewController(viewController: UIViewController, navigationController: UINavigationController?) {
        guard let navigation = navigationController else { return }
        navigation.present(viewController, animated: true)
    }
    func pushViewController(ViewController: UIViewController, navigationController: UINavigationController?) {
        guard let navigation = navigationController else { return }
        navigation.pushViewController(ViewController, animated: true)
    }
}
