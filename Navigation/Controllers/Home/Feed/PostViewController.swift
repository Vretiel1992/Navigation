//
//  PostViewController.swift
//  Navigation
//
//  Created by Антон Денисюк on 08.03.2022.
//

import UIKit

final class PostViewController: UIViewController {

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }

    // MARK: - Private Methods

    private func setupViews() {
        view.backgroundColor = .systemYellow
        navigationItem.title = "Мой пост"
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "info.circle"),
                                                            style: .plain,
                                                            target: self,
                                                            action: #selector(performDisplayVC(parameterSender:)))
    }

    // MARK: - Object Methods

    @objc func performDisplayVC(parameterSender: Any) {
        let infoViewController = InfoViewController()
        present(infoViewController, animated: true, completion: nil)
    }
}
