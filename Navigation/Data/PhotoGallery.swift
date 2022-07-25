//
//  PhotoGallery.swift
//  Navigation
//
//  Created by Антон Денисюк on 06.05.2022.
//

import UIKit

class PhotoGallery {
    
    var images = [UIImage]()
    
    init() {
        setupGallery()
    }
    
    func setupGallery() {
        for i in 1...20 {
            let image = UIImage(named: "\(i)")!
            images.append(image)
        }
    }
}
