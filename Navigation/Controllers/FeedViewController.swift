//
//  FeedViewController.swift
//  Navigation
//
//  Created by Антон Денисюк on 07.03.2022.
//

import UIKit

class FeedViewController: UIViewController {
//    override var prefersStatusBarHidden: Bool {
//        return true
//    }
    
    var post = PostTitlePostVC(title: "Мой пост")
    
    private lazy var displayButton: UIButton = {
        let button = UIButton()
        button.setTitle("Перейти на пост", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .systemBlue
        button.layer.cornerRadius = 12
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        setConstraints()
    }
    
    private func setupView() {
        self.view.backgroundColor = .systemBackground
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.title = "Лента"
        self.navigationItem.backButtonTitle = ""
        self.view.addSubview(self.displayButton)
        self.displayButton.addTarget(self,
                                      action: #selector(performDisplayVC(parameterSender:)),
                                      for: .touchUpInside)
    }
    
    @objc func performDisplayVC(parameterSender: Any) {
        let postViewController = PostViewController()
        postViewController.titlePost = post.title
        self.navigationController?.pushViewController(postViewController, animated: true)
    }
    
    private func setConstraints() {
        NSLayoutConstraint.activate([
            self.displayButton.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            self.displayButton.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor),
            self.displayButton.heightAnchor.constraint(equalToConstant: 50),
            self.displayButton.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            self.displayButton.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: -20)
        ])
    }
}

