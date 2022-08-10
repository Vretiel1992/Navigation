//
//  FeedVC.swift
//  Navigation
//
//  Created by Антон Денисюк on 07.03.2022.
//

import UIKit

final class FeedVC: UIViewController {

    // MARK: - Private Properties

    private lazy var displayButton: UIButton = {
        let button = UIButton()
        button.setTitle("Перейти на пост", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .systemBlue
        button.layer.cornerRadius = 12
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setConstraints()
    }

    // MARK: - Private Methods

    private func setupViews() {
        view.backgroundColor = .systemBackground
        navigationController?.navigationBar.prefersLargeTitles = true
        title = "Лента"
        navigationItem.backButtonTitle = ""
        view.addSubview(displayButton)
        displayButton.addTarget(self,
                                action: #selector(performDisplayVC(parameterSender:)),
                                for: .touchUpInside)
    }

    private func setConstraints() {
        NSLayoutConstraint.activate([
            displayButton.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            displayButton.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor),
            displayButton.heightAnchor.constraint(equalToConstant: 50),
            displayButton.leadingAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            displayButton.trailingAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20)
        ])
    }

    // MARK: - Object Methods

    @objc func performDisplayVC(parameterSender: Any) {
        let postViewController = PostVC()
        navigationController?.pushViewController(postViewController, animated: true)
    }
}
