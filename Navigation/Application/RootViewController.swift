//
//  RootViewController.swift
//  Navigation
//
//  Created by Антон Денисюк on 07.07.2022.
//

import UIKit

class RootViewController: UIViewController {
    
    private var current: UIViewController
    
    init() {
        self.current = LogInViewController()
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addChild(self.current)
        self.current.view.frame = view.bounds
        view.addSubview(self.current.view)
        self.current.didMove(toParent: self)
    }
    
    func switchToMainTabBarController() {
        let mainTabBarController = MainTabBarController()
        let new = mainTabBarController
        animateFadeTransition(to: new)
    }
    
    func switchToLogInViewController() {
        let logInViewController = LogInViewController()
        let new = UINavigationController(rootViewController: logInViewController)
        animateDismissTransition(to: new)
    }
    
    private func animateFadeTransition(to new: UIViewController, completion: (() -> Void)? = nil) {
        self.current.willMove(toParent: nil)
        addChild(new)
        transition(from: current, to: new, duration: 0.3, options: [.transitionCrossDissolve, .curveEaseOut], animations: {
        }) { completed in
            self.current.removeFromParent()
            new.didMove(toParent: self)
            self.current = new
            completion?()
        }
    }
    
    private func animateDismissTransition(to new: UIViewController, completion: (() -> Void)? = nil) {
        let initialFrame = CGRect(x: -UIScreen.main.bounds.width, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        new.view.frame = initialFrame
        self.current.willMove(toParent: nil)
        addChild(new)
        transition(from: current, to: new, duration: 0.3, options: [], animations: {
            new.view.frame = self.view.bounds
        }) { completed in
            self.current.removeFromParent()
            new.didMove(toParent: self)
            self.current = new
            completion?()
        }
    }
}
