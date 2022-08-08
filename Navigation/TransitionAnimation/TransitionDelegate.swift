//
//  TransitionDelegate.swift
//  Navigation
//
//  Created by Антон Денисюк on 26.07.2022.
//

import UIKit

class TransitionDelegate: NSObject, UIViewControllerTransitioningDelegate {

    // MARK: - Public Properties

    var imageView: UIImageView?
    var realFrameTapImageViewCell: CGRect?
    var panGesture: UIPanGestureRecognizer?
    var useInteractiveDismiss: Bool = false
    var dismissVelocity: CGFloat = 1.0

    // MARK: - Protocol Functions

    func animationController(forPresented presented: UIViewController, presenting: UIViewController,
                             source: UIViewController) -> UIViewControllerAnimatedTransitioning? {

        if let tappedImageView = imageView {
            let animator = ImageTransitionAnimator()
            animator.tappedImageView = tappedImageView
            animator.realFrameTappedImageView = realFrameTapImageViewCell
            return animator
        } else {
            return nil
        }
    }

    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {

        if !useInteractiveDismiss {
            return nil
        } else {
            let animator = ImageTransitionAnimator()
            animator.presenting = false
            animator.isDismissInteractive = true
            animator.tappedImageView = imageView
            animator.dismissVelocity = dismissVelocity
            return animator
        }
    }

    func interactionControllerForPresentation(using animator: UIViewControllerAnimatedTransitioning) ->
    UIViewControllerInteractiveTransitioning? {
        return nil
    }

    func interactionControllerForDismissal(using animator: UIViewControllerAnimatedTransitioning) ->
    UIViewControllerInteractiveTransitioning? {

        if !useInteractiveDismiss || panGesture == nil {
            return nil
        } else {
            let interactiveController = InteractiveTransitionController()
            interactiveController.panGesture = panGesture
            return interactiveController
        }
    }
}
