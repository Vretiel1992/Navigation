//
//  LogInViewController.swift
//  Navigation
//
//  Created by Антон Денисюк on 31.03.2022.
//

import UIKit

final class LogInViewController: UIViewController {

    // MARK: - Private Properties

    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.backgroundColor = .systemBackground
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()

    private lazy var contentView: UIView = {
        let contentView = UIView()
        contentView.backgroundColor = .systemBackground
        contentView.translatesAutoresizingMaskIntoConstraints = false
        return contentView
    }()

    private lazy var logoImage: UIImageView = {
        let imageView = UIImageView()
        let logoImage = UIImage(named: "logo")
        imageView.image = logoImage
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    private lazy var textFieldStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.layer.borderWidth = 0.5
        stackView.layer.borderColor = UIColor.lightGray.cgColor
        stackView.layer.cornerRadius = 10
        stackView.distribution = .fillEqually
        stackView.clipsToBounds = true
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()

    private lazy var loginTextField: UITextField = {
        let textField = UITextField()
        textField.backgroundColor = .systemGray6
        textField.font = UIFont.systemFont(ofSize: 16)
        textField.indent(size: 10)
        textField.tintColor = UIColor(named: "colorLogoButton")
        textField.placeholder = "Введите email"
        textField.layer.borderWidth = 0.5
        textField.layer.borderColor = UIColor.lightGray.cgColor
        textField.clearButtonMode = .always
        textField.autocapitalizationType = .none
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()

    private lazy var passwordTextField: UITextField = {
        let textField = UITextField()
        textField.backgroundColor = .systemGray6
        textField.font = UIFont.systemFont(ofSize: 16)
        textField.indent(size: 10)
        textField.tintColor = UIColor(named: "colorLogoButton")
        textField.placeholder = "Введите пароль"
        textField.clearButtonMode = .always
        textField.autocapitalizationType = .none
        textField.isSecureTextEntry = true
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()

    private lazy var displayButton: UIButton = {
        let button = UIButton()
        button.setBackgroundImage(UIImage(named: "blue_pixel")?.copy(alpha: 1), for: .normal)
        button.setBackgroundImage(UIImage(named: "blue_pixel")?.copy(alpha: 0.8), for: .selected)
        button.setBackgroundImage(UIImage(named: "blue_pixel")?.copy(alpha: 0.8), for: .highlighted)
        button.setBackgroundImage(UIImage(named: "blue_pixel")?.copy(alpha: 0.8), for: .disabled)
        button.setTitle("Войти", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 10
        button.clipsToBounds = true
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self,
                         action: #selector(switchToMainTabBarController(parameterSender:)),
                         for: .touchUpInside)
        return button
    }()

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupConstraints()
        setupGesture()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = true
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(kbdShow), name:
                        UIResponder.keyboardWillShowNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(kbdHide), name:
                        UIResponder.keyboardWillHideNotification, object: nil)
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        let notificationCenter = NotificationCenter.default
        notificationCenter.removeObserver(self, name:
                            UIResponder.keyboardWillShowNotification, object: nil)
        notificationCenter.removeObserver(self, name:
                            UIResponder.keyboardWillHideNotification, object: nil)
    }

    // MARK: - Private Methods

    private func setupViews() {
        view.backgroundColor = .systemBackground
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubview(logoImage)
        contentView.addSubview(textFieldStackView)
        contentView.addSubview(displayButton)
        textFieldStackView.addArrangedSubview(loginTextField)
        textFieldStackView.addArrangedSubview(passwordTextField)
        loginTextField.delegate = self
        passwordTextField.delegate = self
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),

            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),

            logoImage.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 120),
            logoImage.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            logoImage.heightAnchor.constraint(equalToConstant: 100),
            logoImage.heightAnchor.constraint(equalTo: logoImage.widthAnchor, multiplier: 1.0),

            textFieldStackView.topAnchor.constraint(equalTo: logoImage.bottomAnchor, constant: 120),
            textFieldStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            textFieldStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            textFieldStackView.heightAnchor.constraint(equalToConstant: 100),

            displayButton.topAnchor.constraint(equalTo: textFieldStackView.bottomAnchor, constant: 30),
            displayButton.leadingAnchor.constraint(equalTo: textFieldStackView.leadingAnchor),
            displayButton.trailingAnchor.constraint(equalTo: textFieldStackView.trailingAnchor),
            displayButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            displayButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }

    private func setupGesture() {
        let tapGesture = UITapGestureRecognizer(target: self,
                                                action: #selector(self.tap(gesture:)))
        view.addGestureRecognizer(tapGesture)
    }

    // MARK: - Object Methods

    @objc private func kbdShow(notification: NSNotification) {
        guard let keyboardFrameValue = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)
        else { return }
        let keyboardFrame = view.convert(keyboardFrameValue.cgRectValue, from: nil)
        if loginTextField.isFirstResponder {
            scrollView.contentInset.bottom = keyboardFrame.size.height + 110
            scrollView.scrollIndicatorInsets = scrollView.contentInset
        } else if passwordTextField.isFirstResponder {
            scrollView.contentInset.bottom = keyboardFrame.size.height + 60
            scrollView.scrollIndicatorInsets = scrollView.contentInset
        }
    }

    @objc private func kbdHide(notification: NSNotification) {
        scrollView.contentInset = .zero
        scrollView.scrollIndicatorInsets = scrollView.contentInset
    }

    @objc private func tap(gesture: UITapGestureRecognizer) {
        loginTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
    }

    @objc private func switchToMainTabBarController(parameterSender: Any) {
        SceneDelegate.shared?.rootViewController.switchToMainTabBarController()
    }
}

// MARK: - UITextFieldDelegate

extension LogInViewController: UITextFieldDelegate {

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        loginTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
        return true
    }
}
