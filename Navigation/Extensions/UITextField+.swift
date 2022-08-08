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
}
