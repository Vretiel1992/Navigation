//
//  PhotosTableViewCell.swift
//  Navigation
//
//  Created by Антон Денисюк on 21.04.2022.
//

import UIKit

class PhotosTableViewCell: UITableViewCell {

    // MARK: - Private Properties

    private lazy var backView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.systemGray3
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private lazy var borderView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.customBackgroundAppTwo
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private lazy var photoLabel: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        label.text = "Фотографии"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var arrowImageView: UIImageView = {
        let imageView = UIImageView()
        let image = UIImage(systemName: "arrow.right")
        imageView.image = image
        imageView.tintColor = .label
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    private lazy var pictureViewOne: UIImageView = {
        let imageView = UIImageView()
        let image = UIImage(named: "1")
        imageView.image = image
        imageView.layer.cornerRadius = 6
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    private lazy var pictureViewTwo: UIImageView = {
        let imageView = UIImageView()
        let image = UIImage(named: "2")
        imageView.image = image
        imageView.layer.cornerRadius = 6
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    private lazy var pictureViewThree: UIImageView = {
        let imageView = UIImageView()
        let image = UIImage(named: "3")
        imageView.image = image
        imageView.layer.cornerRadius = 6
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    private lazy var pictureViewFour: UIImageView = {
        let imageView = UIImageView()
        let image = UIImage(named: "18")
        imageView.image = image
        imageView.layer.cornerRadius = 6
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    private lazy var imagesStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 8
        stackView.distribution = .fillEqually
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()

    // MARK: - Initializers

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
        setupConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Private Methods

    private func setupView() {
        selectionStyle = .none
        contentView.addSubview(backView)
        backView.addSubview(borderView)
        borderView.addSubview(photoLabel)
        borderView.addSubview(arrowImageView)
        borderView.addSubview(imagesStackView)
        imagesStackView.addArrangedSubview(pictureViewOne)
        imagesStackView.addArrangedSubview(pictureViewTwo)
        imagesStackView.addArrangedSubview(pictureViewThree)
        imagesStackView.addArrangedSubview(pictureViewFour)

    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            backView.topAnchor.constraint(equalTo: contentView.topAnchor),
            backView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            backView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            backView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),

            borderView.topAnchor.constraint(equalTo: backView.topAnchor, constant: 2),
            borderView.leadingAnchor.constraint(equalTo: backView.leadingAnchor),
            borderView.trailingAnchor.constraint(equalTo: backView.trailingAnchor),
            borderView.bottomAnchor.constraint(equalTo: backView.bottomAnchor, constant: -2),

            photoLabel.topAnchor.constraint(equalTo: borderView.topAnchor, constant: 10),
            photoLabel.leadingAnchor.constraint(equalTo: borderView.leadingAnchor, constant: 10),

            arrowImageView.trailingAnchor.constraint(equalTo: borderView.trailingAnchor, constant: -10),
            arrowImageView.centerYAnchor.constraint(equalTo: photoLabel.centerYAnchor),
            arrowImageView.heightAnchor.constraint(equalTo: photoLabel.heightAnchor),
            arrowImageView.widthAnchor.constraint(equalTo: arrowImageView.heightAnchor, multiplier: 1.0),

            imagesStackView.topAnchor.constraint(equalTo: photoLabel.bottomAnchor, constant: 12),
            imagesStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),
            imagesStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12),
            imagesStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12),
            imagesStackView.heightAnchor.constraint(equalToConstant: (UIScreen.main.bounds.width - 48) / 4)
        ])
    }
}
