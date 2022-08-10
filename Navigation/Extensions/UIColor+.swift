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
            return UIColor(red: 58 / 255, green: 38 / 255, blue: 38 / 255, alpha: 1)
        default:
            return UIColor(red: 252 / 255, green: 241 / 255, blue: 241 / 255, alpha: 1)
        }
    }
}
