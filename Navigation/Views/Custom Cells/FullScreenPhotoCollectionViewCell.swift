//
//  FullScreenPhotoCollectionViewCell.swift
//  Navigation
//
//  Created by Антон Денисюк on 07.05.2022.
//

import UIKit

class FullScreenPhotoCollectionViewCell: UICollectionViewCell {

    // MARK: - Public Properties

    var currentZoomScale: CGFloat = 0.0

    // MARK: - Private Properties

    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.minimumZoomScale = 1.0
        scrollView.maximumZoomScale = 3.5
        scrollView.zoomScale = 1.0
        scrollView.isScrollEnabled = true
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()

    // MARK: - Initializers

    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(scrollView)
        scrollView.addSubview(imageView)
        scrollView.delegate = self
        setupConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Public Methods

    func setImage(name: UIImage) {
        imageView.image = name
    }

    func defaultZoomScale() {
        currentZoomScale = 1.0
        scrollView.zoomScale = currentZoomScale
    }

    // MARK: - Private Methods

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            scrollView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            scrollView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            scrollView.heightAnchor.constraint(equalTo: contentView.heightAnchor),
            scrollView.widthAnchor.constraint(equalTo: contentView.widthAnchor),

            imageView.centerYAnchor.constraint(equalTo: scrollView.centerYAnchor),
            imageView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
            imageView.heightAnchor.constraint(equalTo: scrollView.heightAnchor),
            imageView.widthAnchor.constraint(equalTo: scrollView.widthAnchor)
        ])
    }
}

// MARK: - UIScrollViewDelegate

extension FullScreenPhotoCollectionViewCell: UIScrollViewDelegate {

    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        currentZoomScale = self.scrollView.zoomScale
    }
}
