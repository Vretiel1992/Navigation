//
//  UITapGestureRecognizer+.swift
//  Navigation
//
//  Created by Антон Денисюк on 14.07.2022.
//

import UIKit

extension UITapGestureRecognizer {
    
    func didTapAttributedTextInTextView(textView: UITextView, inRange targetRange: NSRange) -> Bool {
        let layoutManager = textView.layoutManager
        let locationOfTouch = self.location(in: textView)
        let index = layoutManager.characterIndex(for: locationOfTouch, in: textView.textContainer, fractionOfDistanceBetweenInsertionPoints: nil)
        return NSLocationInRange(index, targetRange)
    }
}
