//
//  UIColor+.swift
//  Navigation
//
//  Created by Антон Денисюк on 20.07.2022.
//

import UIKit

extension UIColor {
    static let customBackgroundAppOne = UIColor { traitCollection in
        switch traitCollection.userInterfaceStyle {
        case .dark:
            return UIColor.systemBackground
        default:
            return UIColor.systemGray5
        }
    }
    
    static let customBackgroundAppTwo = UIColor { traitCollection in
        switch traitCollection.userInterfaceStyle {
        case .dark:
            return UIColor.systemGray6
        default:
            return UIColor.systemBackground
        }
    }
    
    static let customBaseForegroundButton = UIColor { traitCollection in
        switch traitCollection.userInterfaceStyle {
        case .dark:
            return UIColor.lightGray
        default:
            return UIColor.darkGray
        }
    }
    
    static let customBaseBackgroundButton = UIColor { traitCollection in
        switch traitCollection.userInterfaceStyle {
        case .dark:
            return UIColor(r: 58, g: 38, b: 38)
        default:
            return UIColor(r: 252, g: 241, b: 241)
        }
    }
    
    convenience init(r: CGFloat, g: CGFloat, b: CGFloat, a: CGFloat = 1) {
        self.init(
            red: r / 255.0,
            green: g / 255.0,
            blue: b / 255.0,
            alpha: a
        )
    }
}

