//
//  MainTabBarController.swift
//  Navigation
//
//  Created by Антон Денисюк on 20.02.2022.
//

import UIKit

class MainTabBarController: UITabBarController {


    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
//        self.tabBar.backgroundColor = .systemGray6
        self.tabBar.layer.borderWidth = 0.5
        self.tabBar.layer.borderColor = UIColor.systemGray4.cgColor
        
        setupTabBar()
    }
    
    private func setupTabBar() {
        let feedViewController = createNavController(vc: FeedViewController(), itemName: "Лента", itemImage: "house")
        
        let logInViewController = createNavController(vc: LogInViewController(), itemName: "Профиль", itemImage: "person.circle")
        
        logInViewController.navigationBar.isHidden = true
        
        viewControllers = [feedViewController, logInViewController]
    }
    
    private func createNavController(vc: UIViewController, itemName: String, itemImage: String) -> UINavigationController {
        let item = UITabBarItem(title: itemName, image: UIImage(systemName: itemImage), tag: 0)
        let navController = UINavigationController(rootViewController: vc)
        navController.navigationBar.prefersLargeTitles = true
        navController.tabBarItem = item
        return navController
    }
}

