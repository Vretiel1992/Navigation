//
//  PhotoGallery.swift
//  Navigation
//
//  Created by Антон Денисюк on 06.05.2022.
//

import UIKit

class PhotoGallery {

    // MARK: - Public Properties

    var images = [UIImage]()

    // MARK: - Initializers

    init() {
        setupGallery()
    }

    // MARK: - Public Methods

    func setupGallery() {
        for imageName in 1...20 {
            let image = UIImage(named: "\(imageName)")!
            images.append(image)
        }
    }
}
