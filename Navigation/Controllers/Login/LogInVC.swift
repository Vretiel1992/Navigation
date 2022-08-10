//
//  LogInVC.swift
//  Navigation
//
//  Created by Антон Денисюк on 31.03.2022.
//

import UIKit

final class LogInVC: UIViewController {

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
        stackView.backgroundColor = .systemGray6
        stackView.layer.borderWidth = 0.5
        stackView.layer.borderColor = UIColor.lightGray.cgColor
        stackView.layer.cornerRadius = 10
        stackView.distribution = .fillEqually
        stackView.clipsToBounds = true
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()

    private lazy var separatorView: UIView = {
        let view = UIView()
        view.backgroundColor = .lightGray
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private lazy var loginTextField: UITextField = {
        let textField = UITextField()
        textField.backgroundColor = .systemGray6
        textField.font = UIFont.systemFont(ofSize: 16)
        textField.indent(size: 10)
        textField.tintColor = UIColor(named: "colorLogoButton")
        textField.placeholder = "Введите email"
        textField.clearButtonMode = .always
        textField.autocapitalizationType = .none
        textField.delegate = self
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
        textField.delegate = self
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

    private lazy var invalidLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.textColor = .lightGray
        label.font = .systemFont(ofSize: 12)
        label.numberOfLines = 8
        label.contentMode = .scaleToFill
        label.textAlignment = .center
        label.isHidden = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var validationData = ValidationData()

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
        contentView.addSubview(invalidLabel)
        textFieldStackView.addArrangedSubview(loginTextField)
        textFieldStackView.addArrangedSubview(passwordTextField)
        textFieldStackView.addSubview(separatorView)
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

            separatorView.centerXAnchor.constraint(equalTo: textFieldStackView.centerXAnchor),
            separatorView.centerYAnchor.constraint(equalTo: textFieldStackView.centerYAnchor),
            separatorView.leadingAnchor.constraint(equalTo: textFieldStackView.leadingAnchor),
            separatorView.trailingAnchor.constraint(equalTo: textFieldStackView.trailingAnchor),
            separatorView.heightAnchor.constraint(equalToConstant: 0.5),

            displayButton.topAnchor.constraint(equalTo: textFieldStackView.bottomAnchor, constant: 30),
            displayButton.leadingAnchor.constraint(equalTo: textFieldStackView.leadingAnchor),
            displayButton.trailingAnchor.constraint(equalTo: textFieldStackView.trailingAnchor),
            displayButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            displayButton.heightAnchor.constraint(equalToConstant: 50),

            invalidLabel.topAnchor.constraint(equalTo: displayButton.bottomAnchor),
            invalidLabel.leadingAnchor.constraint(equalTo: displayButton.leadingAnchor),
            invalidLabel.trailingAnchor.constraint(equalTo: displayButton.trailingAnchor)
        ])
    }

    private func setupGesture() {
        let tapGesture = UITapGestureRecognizer(target: self,
                                                action: #selector(self.tap(gesture:)))
        view.addGestureRecognizer(tapGesture)
    }

    private func validEmail(email: String) -> Bool {
        let emailReg = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let validEmail = NSPredicate(format: "SELF MATCHES %@", emailReg)
        return validEmail.evaluate(with: email)
    }

    private func validPassword(password: String) -> Bool {
        let passwordReg =  ("(?=.*[A-Z])(?=.*[0-9])(?=.*[a-z])(?=.*[@#$%^&*]).{8,}")
        let passwordTesting = NSPredicate(format: "SELF MATCHES %@", passwordReg)
        return passwordTesting.evaluate(with: password) && password.count > 6
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
        guard let email = loginTextField.text else {return}
        guard let password = passwordTextField.text else {return}
        let enteredEmail = validEmail(email: email)
        let enteredPassword = validPassword(password: password)

        if email.isEmpty && password.isEmpty {
            loginTextField.shake()
            passwordTextField.shake()
        } else if email.isEmpty {
            loginTextField.shake()
        } else if password.isEmpty {
            passwordTextField.shake()
        } else {
            if !enteredPassword && !enteredEmail {
                invalidLabel.text = validationData.invalidEmailAndPassword
                invalidLabel.isHidden = false
                passwordTextField.shake()
                loginTextField.shake()
            } else if !enteredPassword {
                invalidLabel.text = validationData.invalidPassword
                invalidLabel.isHidden = false
                passwordTextField.shake()
            } else if !enteredEmail {
                invalidLabel.text = validationData.invalidEmail
                invalidLabel.isHidden = false
                loginTextField.shake()
            } else {
                SceneDelegate.shared?.rootViewController.switchToMainTabBarController()
                invalidLabel.isHidden = true
            }
        }
    }
}

// MARK: - UITextFieldDelegate

extension LogInVC: UITextFieldDelegate {

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        loginTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
        return true
    }
}
