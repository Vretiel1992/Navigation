//
//  ProfileHeaderView.swift
//  Navigation
//
//  Created by Антон Денисюк on 14.03.2022.
//

import UIKit

protocol ProfileHeaderViewProtocol: AnyObject {

    func didTapStatusButton(textFieldIsVisible: Bool, completion: @escaping () -> Void)
    func resizeProfileImage()
}

final class ProfileHeaderView: UITableViewHeaderFooterView {

    // MARK: - Public Properties

    let tapGestureRecognizer = UITapGestureRecognizer()

    weak var delegate: ProfileHeaderViewProtocol?

    // MARK: - Private Properties

    private var buttonTopConstraint: NSLayoutConstraint?
    private var statusText: String = "Установите статус..."

    private lazy var backView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .systemGray3
        return view
    }()

    private lazy var topBorderView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .systemGray5
        return view
    }()

    private lazy var avatarImageView: UIImageView = {
        let imageView = UIImageView()
        let profileImage = UIImage(named: "TimCook")
        imageView.image = profileImage
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = 50
        imageView.clipsToBounds = true
        imageView.layer.borderWidth = 3.0
        imageView.layer.borderColor = UIColor.white.cgColor
        imageView.isUserInteractionEnabled = true
        imageView.addGestureRecognizer(tapGestureRecognizer)
        tapGestureRecognizer.addTarget(self, action: #selector(handleTap(_:)))
        return imageView
    }()

    private lazy var setStatusButton: UIButton = {
        let button = UIButton()
        button.setTitle("Изменить статус", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .systemBlue
        button.layer.cornerRadius = 16
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .bold)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.shadowOffset = CGSize(width: 4, height: 4)
        button.layer.shadowRadius = CGFloat(4.0)
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOpacity = 0.7
        return button
    }()

    private lazy var fullNameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Тим Кук"
        label.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        label.textColor = .label
        return label
    }()

    private lazy var statusLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Установите статус..."
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        label.textColor = .secondaryLabel
        return label
    }()

    private lazy var statusTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        textField.textColor = .label
        textField.tintColor = UIColor(named: "colorLogoButton")
        textField.backgroundColor = UIColor.customBackgroundAppTwo
        textField.textAlignment = .center
        textField.clearButtonMode = .always
        textField.placeholder = "Введите текст"
        textField.layer.cornerRadius = 12
        textField.layer.borderWidth = 1.0
        textField.layer.borderColor = UIColor.darkGray.cgColor
        textField.isHidden = true
        return textField
    }()

    private lazy var labelsStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.spacing = 10
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()

    private lazy var infoStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 20
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()

    // MARK: - Initializers

    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        setupView()
        setupConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Private Methods

    private func setupView() {
        self.addSubview(backView)
        backView.addSubview(topBorderView)
        topBorderView.addSubview(infoStackView)
        topBorderView.addSubview(setStatusButton)
        topBorderView.addSubview(statusTextField)
        infoStackView.addArrangedSubview(avatarImageView)
        infoStackView.addArrangedSubview(labelsStackView)
        labelsStackView.addArrangedSubview(fullNameLabel)
        labelsStackView.addArrangedSubview(statusLabel)

        setStatusButton.addTarget(self,
                                  action: #selector(didTapStatusButton(parameterSender:)),
                                  for: .touchUpInside)
        statusTextField.addTarget(self,
                                  action: #selector(statusTextChanged(parameterSender:)),
                                  for: .editingChanged)
    }

    private func setupConstraints() {
        let topConstraintBackView = backView.topAnchor.constraint(equalTo: self.topAnchor)
        let bottomConstraintBackView = backView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        let leadingConstraintBackView = backView.leadingAnchor.constraint(equalTo: self.leadingAnchor)
        let trailingConstraintBackView = backView.trailingAnchor.constraint(equalTo: self.trailingAnchor)

        let topConstraintBorderView = topBorderView.topAnchor.constraint(
            equalTo: backView.topAnchor, constant: 2)
        let bottomConstraintBorderView = topBorderView.bottomAnchor.constraint(
            equalTo: backView.bottomAnchor)
        let leadingConstraintBorderView = topBorderView.leadingAnchor.constraint(
            equalTo: backView.leadingAnchor)
        let trailingConstraintBorderView = topBorderView.trailingAnchor.constraint(
            equalTo: backView.trailingAnchor)

        let topConstraintInfoStackView = infoStackView.topAnchor.constraint(
            equalTo: topBorderView.topAnchor, constant: 3)
        let leadingConstraintInfoStackView = infoStackView.leadingAnchor.constraint(
            equalTo: topBorderView.leadingAnchor, constant: 20)
        let trailingConstraintInfoStackView = infoStackView.trailingAnchor.constraint(
            equalTo: topBorderView.trailingAnchor, constant: -20)

        let imageViewAspectRatio = avatarImageView.heightAnchor.constraint(
            equalTo: avatarImageView.widthAnchor, multiplier: 1.0)

        self.buttonTopConstraint = setStatusButton.topAnchor.constraint(
            equalTo: infoStackView.bottomAnchor, constant: 20)
        self.buttonTopConstraint?.priority = UILayoutPriority(rawValue: 999)
        let leadingButtonConstraint = setStatusButton.leadingAnchor.constraint(
            equalTo: infoStackView.leadingAnchor)
        let trailingButtonConstraint = setStatusButton.trailingAnchor.constraint(
            equalTo: infoStackView.trailingAnchor)
        let bottomButtonConstraint = setStatusButton.bottomAnchor.constraint(
            equalTo: topBorderView.bottomAnchor, constant: -10)
        let heightButtonConstraint = setStatusButton.heightAnchor.constraint(equalToConstant: 50)

        NSLayoutConstraint.activate([
            topConstraintBackView,
            bottomConstraintBackView,
            leadingConstraintBackView,
            trailingConstraintBackView,
            topConstraintBorderView,
            bottomConstraintBorderView,
            leadingConstraintBorderView,
            trailingConstraintBorderView,
            topConstraintInfoStackView,
            leadingConstraintInfoStackView,
            trailingConstraintInfoStackView,
            imageViewAspectRatio,
            buttonTopConstraint,
            leadingButtonConstraint,
            trailingButtonConstraint,
            bottomButtonConstraint,
            heightButtonConstraint
        ].compactMap({ $0 }))
    }

    // MARK: - Object Methods

    @objc func didTapStatusButton(parameterSender: Any) {
        if statusTextField.isHidden {
            addSubview(statusTextField)
            statusTextField.delegate = self
            buttonTopConstraint?.isActive = false

            let topConstraint = statusTextField.topAnchor.constraint(
                equalTo: infoStackView.bottomAnchor, constant: 10)
            let leadingConstraint = statusTextField.leadingAnchor.constraint(
                equalTo: statusLabel.leadingAnchor)
            let trailingConstraint = statusTextField.trailingAnchor.constraint(
                equalTo: infoStackView.trailingAnchor)
            let heightTextFieldConstraint = statusTextField.heightAnchor.constraint(equalToConstant: 40)
            buttonTopConstraint = setStatusButton.topAnchor.constraint(
                equalTo: statusTextField.bottomAnchor, constant: 20)

            NSLayoutConstraint.activate([
                topConstraint,
                leadingConstraint,
                trailingConstraint,
                heightTextFieldConstraint,
                buttonTopConstraint
            ].compactMap({ $0 }))

            setStatusButton.setTitle("Применить статус", for: .normal)
        } else {
            if !statusText.isEmpty {
                statusLabel.text = statusText.trimmingCharacters(in: .whitespaces)
            }
            statusTextField.text = nil

            buttonTopConstraint?.isActive = false

            buttonTopConstraint = setStatusButton.topAnchor.constraint(
                equalTo: infoStackView.bottomAnchor, constant: 20)

            NSLayoutConstraint.activate([
                buttonTopConstraint
            ].compactMap({ $0 }))

            statusTextField.removeFromSuperview()
            setStatusButton.setTitle("Изменить статус", for: .normal)
        }
        delegate?.didTapStatusButton(textFieldIsVisible: self.statusTextField.isHidden) { [weak self] in
            self?.statusTextField.isHidden.toggle()
        }
    }

    @objc func handleTap(_ gestureRecognizer: UITapGestureRecognizer) {
        guard tapGestureRecognizer === gestureRecognizer else { return }
        delegate?.resizeProfileImage()
    }

    @objc func statusTextChanged(parameterSender: Any) {
        statusText = "\(statusTextField.text!)"
    }
}

// MARK: - UITextFieldDelegate

extension ProfileHeaderView: UITextFieldDelegate {

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        statusTextField.resignFirstResponder()
        return true
    }
}
