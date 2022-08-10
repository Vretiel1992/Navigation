//
//  UITextField+.swift
//  Navigation
//
//  Created by Антон Денисюк on 14.07.2022.
//

import UIKit

extension UITextField {

    func indent(size: CGFloat) {
        self.leftView = UIView(frame: CGRect(x: self.frame.minX,
                                             y: self.frame.minY,
                                             width: size,
                                             height: self.frame.height))
        self.leftViewMode = .always
    }

    func shake(duration timeDuration: Double = 0.07, repeat countRepeat: Float = 3) {
        let animation = CABasicAnimation(keyPath: "position")
        animation.duration = timeDuration
        animation.repeatCount = countRepeat
        animation.autoreverses = true
        animation.fromValue = NSValue(cgPoint: CGPoint(x: self.center.x - 10, y: self.center.y))
        animation.toValue = NSValue(cgPoint: CGPoint(x: self.center.x + 10, y: self.center.y))
        self.layer.add(animation, forKey: "position")
    }
}
