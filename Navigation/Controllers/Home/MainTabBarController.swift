//
//  MainTabBarController.swift
//  Navigation
//
//  Created by Антон Денисюк on 20.02.2022.
//

import UIKit

final class MainTabBarController: UITabBarController {

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTabBar()
        setupBorder()
    }

    // MARK: - Private Methods

    private func setupTabBar() {
        view.backgroundColor = .systemBackground
        let profileViewController = createNavController(viewController: ProfileVC(),
                                                        itemName: "Профиль",
                                                        itemImage: "person.circle")
        let feedViewController = createNavController(viewController: FeedVC(),
                                                     itemName: "Лента",
                                                     itemImage: "house")
        viewControllers = [profileViewController, feedViewController]
    }

    private func setupBorder() {
        let thickness = 0.5
        let borderTabbar = CALayer()
        borderTabbar.frame = CGRect(x: 0.0, y: 0.0, width: UIScreen.main.bounds.width, height: thickness)
        borderTabbar.backgroundColor = UIColor.darkGray.cgColor
        tabBar.layer.addSublayer(borderTabbar)
    }

    private func createNavController(viewController: UIViewController, itemName: String,
                                     itemImage: String) -> UINavigationController {
        let item = UITabBarItem(title: itemName, image: UIImage(systemName: itemImage), tag: 0)
        let navController = UINavigationController(rootViewController: viewController)
        navController.tabBarItem = item
        return navController
    }
}
