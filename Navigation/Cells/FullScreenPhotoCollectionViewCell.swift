//
//  FullScreenPhotoCollectionViewCell.swift
//  Navigation
//
//  Created by Антон Денисюк on 07.05.2022.
//

import UIKit

class FullScreenPhotoCollectionViewCell: UICollectionViewCell, UIScrollViewDelegate {
    
    var currentZoomScale: CGFloat = 0.0
    
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
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.contentView.addSubview(self.scrollView)
        self.scrollView.addSubview(self.imageView)
        self.scrollView.delegate = self
        self.setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            self.scrollView.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor),
            self.scrollView.centerXAnchor.constraint(equalTo: self.contentView.centerXAnchor),
            self.scrollView.heightAnchor.constraint(equalTo: self.contentView.heightAnchor),
            self.scrollView.widthAnchor.constraint(equalTo: self.contentView.widthAnchor),
            
            self.imageView.centerYAnchor.constraint(equalTo: self.scrollView.centerYAnchor),
            self.imageView.centerXAnchor.constraint(equalTo: self.scrollView.centerXAnchor),
            self.imageView.heightAnchor.constraint(equalTo: self.scrollView.heightAnchor),
            self.imageView.widthAnchor.constraint(equalTo: self.scrollView.widthAnchor)
        ])
    }
    
    func setImage(name: UIImage) {
        self.imageView.image = name
    }
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
    
    func defaultZoomScale() {
        self.currentZoomScale = 1.0
        self.scrollView.zoomScale = self.currentZoomScale
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        self.currentZoomScale = self.scrollView.zoomScale
    }
}
