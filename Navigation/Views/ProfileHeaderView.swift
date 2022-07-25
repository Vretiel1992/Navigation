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

class ProfileHeaderView: UITableViewHeaderFooterView, UITextFieldDelegate {
    
    private var statusText: String = "Установите статус..."
    
    let tapGestureRecognizer = UITapGestureRecognizer()
    
    private lazy var backView: UIView = {
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
    
    private var buttonTopConstraint: NSLayoutConstraint?
    
    weak var delegate: ProfileHeaderViewProtocol?
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        self.setupView()
    }
    
    override func layoutSubviews() {
        let thickness = 2.0
        let borderTop = CALayer()
        borderTop.frame = CGRect(x: 0.0, y: 0.0, width: UIScreen.main.bounds.width, height: thickness)
        borderTop.backgroundColor = UIColor.systemGray3.cgColor
        self.backView.layer.addSublayer(borderTop)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        self.addSubview(self.backView)
        self.addSubview(self.infoStackView)
        self.addSubview(self.setStatusButton)
        self.addSubview(self.statusTextField)
        self.addSubview(self.labelsStackView)
        self.infoStackView.addArrangedSubview(self.avatarImageView)
        self.infoStackView.addArrangedSubview(self.labelsStackView)
        self.labelsStackView.addArrangedSubview(self.fullNameLabel)
        self.labelsStackView.addArrangedSubview(self.statusLabel)
        
        self.setStatusButton.addTarget(self,
                                       action: #selector(didTapStatusButton(parameterSender:)),
                                       for: .touchUpInside)
        
        self.statusTextField.addTarget(self,
                                       action: #selector(statusTextChanged(parameterSender:)),
                                       for: .editingChanged)
        setConstraints()
    }
    
    @objc func didTapStatusButton(parameterSender: Any) {
        if self.statusTextField.isHidden {
            self.addSubview(self.statusTextField)
            statusTextField.delegate = self
            self.buttonTopConstraint?.isActive = false
            
            let topConstraint = self.statusTextField.topAnchor.constraint(equalTo: self.infoStackView.bottomAnchor, constant: 10)
            let leadingConstraint = self.statusTextField.leadingAnchor.constraint(equalTo: self.statusLabel.leadingAnchor)
            let trailingConstraint = self.statusTextField.trailingAnchor.constraint(equalTo: self.infoStackView.trailingAnchor)
            let heightTextFieldConstraint = self.statusTextField.heightAnchor.constraint(equalToConstant: 40)
            self.buttonTopConstraint = self.setStatusButton.topAnchor.constraint(equalTo: self.statusTextField.bottomAnchor, constant: 20)
            
            NSLayoutConstraint.activate([
                topConstraint,
                leadingConstraint,
                trailingConstraint,
                heightTextFieldConstraint,
                self.buttonTopConstraint
            ].compactMap({ $0 }))
            
            self.setStatusButton.setTitle("Применить статус", for: .normal)
        } else {
            if !self.statusText.isEmpty {
                self.statusLabel.text = self.statusText.trimmingCharacters(in: .whitespaces)
            }
            self.statusTextField.text = nil
            
            self.buttonTopConstraint?.isActive = false
            
            self.buttonTopConstraint = self.setStatusButton.topAnchor.constraint(equalTo: self.infoStackView.bottomAnchor, constant: 20)
            
            NSLayoutConstraint.activate([
                self.buttonTopConstraint
            ].compactMap( { $0 }))
            
            self.statusTextField.removeFromSuperview()
            self.setStatusButton.setTitle("Изменить статус", for: .normal)
        }
        
        self.delegate?.didTapStatusButton(textFieldIsVisible: self.statusTextField.isHidden) { [weak self] in
            self?.statusTextField.isHidden.toggle()
        }
    }
    
    @objc func handleTap(_ gestureRecognizer:UITapGestureRecognizer){
        guard tapGestureRecognizer === gestureRecognizer else { return }
        self.delegate?.resizeProfileImage()
    }
    
    @objc func statusTextChanged(parameterSender: Any) {
        self.statusText = "\(self.statusTextField.text!)"
    }
    
    private func setConstraints() {
        let topConstraintBackView = self.backView.topAnchor.constraint(equalTo: self.topAnchor)
        let bottomConstraintBackView = self.backView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        let leadingConstraintBackView = self.backView.leadingAnchor.constraint(equalTo: self.leadingAnchor)
        let trailingConstraintBackView = self.backView.trailingAnchor.constraint(equalTo: self.trailingAnchor)
        
        let topConstraintInfoStackView = self.infoStackView.topAnchor.constraint(equalTo: self.topAnchor, constant: 5)
        let leadingConstraintInfoStackView = self.infoStackView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20)
        let trailingConstraintInfoStackView = self.infoStackView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20)
        
        let imageViewAspectRatio = self.avatarImageView.heightAnchor.constraint(equalTo: self.avatarImageView.widthAnchor, multiplier: 1.0)
        
        self.buttonTopConstraint = self.setStatusButton.topAnchor.constraint(equalTo: self.infoStackView.bottomAnchor, constant: 20)
        self.buttonTopConstraint?.priority = UILayoutPriority(rawValue: 999)
        let leadingButtonConstraint = self.setStatusButton.leadingAnchor.constraint(equalTo: self.infoStackView.leadingAnchor)
        let trailingButtonConstraint = self.setStatusButton.trailingAnchor.constraint(equalTo: self.infoStackView.trailingAnchor)
        let bottomButtonConstraint = self.setStatusButton.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -10)
        let heightButtonConstraint = self.setStatusButton.heightAnchor.constraint(equalToConstant: 50)
        
        NSLayoutConstraint.activate([
            topConstraintBackView,
            bottomConstraintBackView,
            leadingConstraintBackView,
            trailingConstraintBackView,
            topConstraintInfoStackView,
            leadingConstraintInfoStackView,
            trailingConstraintInfoStackView,
            imageViewAspectRatio,
            self.buttonTopConstraint,
            leadingButtonConstraint,
            trailingButtonConstraint,
            bottomButtonConstraint,
            heightButtonConstraint
        ].compactMap({ $0 }))
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.statusTextField.resignFirstResponder()
        return true
    }
    
}
