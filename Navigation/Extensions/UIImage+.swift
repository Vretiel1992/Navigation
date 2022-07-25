//
//  UIImage+.swift
//  Navigation
//
//  Created by Антон Денисюк on 14.07.2022.
//

import UIKit

extension UIImage {
    
    func copy(alpha: CGFloat) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(size, false, scale)
        draw(at: CGPoint.zero, blendMode: .normal, alpha: alpha)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage
    }
}

