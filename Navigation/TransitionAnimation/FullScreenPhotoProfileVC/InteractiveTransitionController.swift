//
//  InteractiveTransitionController.swift
//  Navigation
//
//  Created by Антон Денисюк on 26.07.2022.
//

import UIKit

class InteractiveTransitionController: UIPercentDrivenInteractiveTransition {

    // MARK: - Public Properties

    var panGesture: UIPanGestureRecognizer?

    // MARK: - Private Properties

    private var transitionContext: UIViewControllerContextTransitioning?
    private var initialLocation: CGPoint?
    private var initialTranslation: CGPoint?

    // MARK: - Override Methods

    override func startInteractiveTransition(_ transitionContext: UIViewControllerContextTransitioning) {
        super.startInteractiveTransition(transitionContext)
        self.transitionContext = transitionContext
        panGesture?.addTarget(self, action: #selector(handlePanGesture(_:)))
        initialTranslation = panGesture?.translation(in: transitionContext.containerView)
    }

    // MARK: - Private Methods

    private func calculatePercentComplete(panGesture: UIPanGestureRecognizer) -> CGFloat {
        let transitionContainerView = transitionContext?.containerView
        let translation = panGesture.translation(in: transitionContainerView)
        let floatZero: CGFloat = 0.0
        guard let initialTranslationY = initialTranslation?.y else { return -1 }
        if (initialTranslationY > floatZero && translation.y < floatZero ) || (initialTranslationY < floatZero
                                                                               && translation.y > floatZero ) {
            return -1
        }

        guard let viewHeight = transitionContainerView?.bounds.height else { return -1 }
        let progress: CGFloat = abs(translation.y / viewHeight  )
        return min(progress, 1)
    }

    // MARK: - Object Methods

    @objc func handlePanGesture(_ panGesture: UIPanGestureRecognizer) {
        let progress = calculatePercentComplete(panGesture: panGesture)
        switch panGesture.state {
        case .changed:
            if progress < 0.0 {
                cancel()
                panGesture.removeTarget(self, action: #selector(handlePanGesture(_:)))
            } else {
                update(progress)
            }
        case .ended, .cancelled:
            let velocity = panGesture.velocity(in: panGesture.view?.superview)
            if abs(velocity.y) > 200 {
                finish()
            } else {
                if progress < 0.3 {
                    cancel()
                } else {
                    finish()
                }
            }
        default:
            cancel()
        }
    }
}
