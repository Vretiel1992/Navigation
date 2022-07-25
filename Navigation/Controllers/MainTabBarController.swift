//
//  MainTabBarController.swift
//  Navigation
//
//  Created by Антон Денисюк on 20.02.2022.
//

import UIKit

class MainTabBarController: UITabBarController {
    
//    override var prefersStatusBarHidden: Bool {
//        return true
//    }
    
//    override var childForStatusBarHidden: UIViewController? {
//        return ProfileViewController()
//    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .systemBackground
        let thickness = 0.5
        let borderTabbar = CALayer()
        borderTabbar.frame = CGRect(x: 0.0, y: 0.0, width: UIScreen.main.bounds.width, height: thickness)
        borderTabbar.backgroundColor = UIColor.darkGray.cgColor
        self.tabBar.layer.addSublayer(borderTabbar)
        setupTabBar()
    }
    
    private func setupTabBar() {
        let profileViewController = createNavController(vc: ProfileViewController(), itemName: "Профиль", itemImage: "person.circle")
        
        let feedViewController = createNavController(vc: FeedViewController(), itemName: "Лента", itemImage: "house")
        viewControllers = [profileViewController, feedViewController]
    }
    
    private func createNavController(vc: UIViewController, itemName: String, itemImage: String) -> UINavigationController {
        let item = UITabBarItem(title: itemName, image: UIImage(systemName: itemImage), tag: 0)
        let navController = UINavigationController(rootViewController: vc)
        navController.tabBarItem = item
        return navController
    }
}

