//
//  PhotosCollectionViewCell.swift
//  Navigation
//
//  Created by Антон Денисюк on 22.04.2022.
//

import UIKit

class PhotosCollectionViewCell: UICollectionViewCell {
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 6
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.contentView.addSubview(self.imageView)
        self.setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            self.imageView.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor),
            self.imageView.centerXAnchor.constraint(equalTo: self.contentView.centerXAnchor),
            self.imageView.heightAnchor.constraint(equalTo: self.contentView.heightAnchor),
            self.imageView.widthAnchor.constraint(equalTo: self.contentView.widthAnchor)
        ])
    }
    
    func setImage(name: UIImage) {
        self.imageView.image = name
    }
}
