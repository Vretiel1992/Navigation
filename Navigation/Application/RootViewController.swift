//
//  RootViewController.swift
//  Navigation
//
//  Created by Антон Денисюк on 07.07.2022.
//

import UIKit

class RootViewController: UIViewController {

    // MARK: - Private Properties

    private var current: UIViewController

    // MARK: - Initializers

    init() {
        current = LogInViewController()
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        addChild(current)
        current.view.frame = view.bounds
        view.addSubview(current.view)
        current.didMove(toParent: self)
    }

    // MARK: - Public Methods

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

    // MARK: - Private Methods

    private func animateFadeTransition(to new: UIViewController, completion: (() -> Void)? = nil) {
        current.willMove(toParent: nil)
        addChild(new)
        transition(from: current, to: new, duration: 0.3, options: [.transitionCrossDissolve, .curveEaseOut],
                   animations: {
        }) { _ in
            self.current.removeFromParent()
            new.didMove(toParent: self)
            self.current = new
            completion?()
        }
    }

    private func animateDismissTransition(to new: UIViewController, completion: (() -> Void)? = nil) {
        let initialFrame = CGRect(x: -UIScreen.main.bounds.width, y: 0, width: UIScreen.main.bounds.width,
                                  height: UIScreen.main.bounds.height)
        new.view.frame = initialFrame
        self.current.willMove(toParent: nil)
        addChild(new)
        transition(from: current, to: new, duration: 0.3, options: [], animations: {
            new.view.frame = self.view.bounds
        }) { _ in
            self.current.removeFromParent()
            new.didMove(toParent: self)
            self.current = new
            completion?()
        }
    }
}
