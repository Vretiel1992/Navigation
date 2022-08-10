//
//  InfoVC.swift
//  Navigation
//
//  Created by Антон Денисюк on 10.03.2022.
//

import UIKit

final class InfoVC: UIViewController {

    // MARK: - Private Properties

    private lazy var displayButtons: UIButton = {
        let button = UIButton()
        button.setTitle("Показать алерт", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .systemYellow
        button.layer.cornerRadius = 12
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self,
                         action: #selector(performAlert(parameterSender:)),
                         for: .touchUpInside)
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
        view.backgroundColor = .systemGreen
        view.addSubview(displayButtons)
    }

    private func setConstraints() {
        NSLayoutConstraint.activate([
            displayButtons.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20),
            displayButtons.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20),
            displayButtons.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -30),
            displayButtons.heightAnchor.constraint(equalToConstant: 50)
        ])
    }

    // MARK: - Object Methods

    @objc func performAlert(parameterSender: Any) {
        let alert = UIAlertController(title: "Внимание, что-то важное",
                                      message: "Какое-то сообщение всплывающего окна",
                                      preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "ОК", style: .default, handler: { _ in
            print("Нажата кнопка ОК")
        }))
        alert.addAction(UIAlertAction(title: "Отмена", style: .cancel, handler: { _ in
            print("Нажата кнопка Отмена")
        }))
        present(alert, animated: true, completion: nil)
    }
}
