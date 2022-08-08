//
//  ImageTransitionAnimator.swift
//  Navigation
//
//  Created by Антон Денисюк on 26.07.2022.
//

import UIKit

class ImageTransitionAnimator: NSObject, UIViewControllerAnimatedTransitioning {

    // MARK: - Public Properties

    var presenting = true
    var isDismissInteractive = true
    var tappedImageView: UIImageView?
    var realFrameTappedImageView: CGRect?
    var dismissVelocity: CGFloat = 1.0

    // MARK: - Private Properties

    private let presentingAnimationDurationPart1 = 0.3
    private let presentingAnimationDurationPart2 = 0.7
    private let dismissAnimationDuration = 1.0

    // MARK: - Protocol Functions

    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        if presenting {
            return presentingAnimationDurationPart1 + presentingAnimationDurationPart2
        } else {
            return dismissAnimationDuration
        }
    }

    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        if presenting {
            presentingAnimation(transitionContext: transitionContext)
        } else {
            if isDismissInteractive {
                dismissAnimation(transitionContext: transitionContext)
            }
        }
    }

    // MARK: - Presenting Animation

    private func presentingAnimation(transitionContext: UIViewControllerContextTransitioning) {
        let containerView = transitionContext.containerView

        let fromVC = transitionContext.viewController(forKey: .from)!
        let toVC = transitionContext.viewController(forKey: .to) as! FullScreenPhotoProfileViewController

        let fromView = transitionContext.view(forKey: .from)!
        let toView = transitionContext.view(forKey: .to)!

        fromView.frame = transitionContext.initialFrame(for: fromVC)
        toView.frame = transitionContext.finalFrame(for: toVC)

        let imageView = UIImageView()
        imageView.frame = realFrameTappedImageView ?? CGRect.zero
        imageView.image = tappedImageView!.image
        imageView.contentMode = .scaleAspectFit

        containerView.addSubview(imageView)
        containerView.addSubview(toView)
        containerView.bringSubviewToFront(imageView)

        toView.alpha = 0
        toVC.scrollView.imageZoomView.isHidden = true

        UIView.animate(withDuration: presentingAnimationDurationPart1, animations: {
            imageView.center = toView.center

            fromView.alpha = 0
            toView.alpha = 1
            imageView.frame = toView.frame
        }) { _ in
            imageView.removeFromSuperview()
            toVC.scrollView.imageZoomView.isHidden = false
            transitionContext.completeTransition(true)
        }

    }

    // MARK: - Dismissing Animation

    private func dismissAnimation(transitionContext: UIViewControllerContextTransitioning) {

        let containerView = transitionContext.containerView

        let fromVC = transitionContext.viewController(forKey: .from)!
        let toVC = transitionContext.viewController(forKey: .to)!

        let fromView = transitionContext.view(forKey: .from)!
        let toView = transitionContext.view(forKey: .to)!

        fromView.frame = transitionContext.initialFrame(for: fromVC)
        toView.frame = transitionContext.finalFrame(for: toVC)

        let imageView = UIImageView()
        imageView.frame = fromView.frame
        imageView.image = tappedImageView?.image
        imageView.contentMode = .scaleAspectFit
        imageView.backgroundColor = .clear

        containerView.addSubview(imageView)
        containerView.addSubview(toView)
        containerView.bringSubviewToFront(imageView)

        toView.alpha = 0.0

        var destinationCenter = CGPoint.zero
        if dismissVelocity > 0 {
            destinationCenter = CGPoint(x: toView.frame.width / 2, y: toView.frame.height * 1.5 )
        } else {
            destinationCenter = CGPoint(x: toView.frame.width / 2, y: toView.frame.height * -1.5)
        }

        UIView.animate(withDuration: dismissAnimationDuration, animations: {
            fromView.alpha = 0
            toView.alpha = 1.0
            imageView.center = destinationCenter
        }) { _ in
            let wasCancelled: Bool = transitionContext.transitionWasCancelled
            imageView.removeFromSuperview()
            transitionContext.completeTransition(!wasCancelled)
        }
    }
}
