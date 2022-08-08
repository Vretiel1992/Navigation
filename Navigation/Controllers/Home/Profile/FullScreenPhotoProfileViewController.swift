//
//  FullScreenPhotoProfileViewController.swift
//  Navigation
//
//  Created by Антон Денисюк on 26.07.2022.
//

import UIKit

final class FullScreenPhotoProfileViewController: UIViewController {

    // MARK: - Public Properties

    var image: UIImage?
    var scrollView: ImageScrollView!
    var useInteractiveDismiss = false
    var panGesture = UIPanGestureRecognizer()

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupImageScrollView()
        setupPanGesture()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        scrollView.imageZoomView.isHidden = false
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        scrollView.imageZoomView.isHidden = useInteractiveDismiss ? true : false
    }

    // MARK: - Private Methods

    private func setupImageScrollView() {
        scrollView = ImageScrollView(frame: view.bounds)
        scrollView.set(image: image!)
        scrollView.imageZoomView.contentMode = .scaleAspectFit
        scrollView.contentInsetAdjustmentBehavior = .never
    view.addSubview(scrollView)
    }

    private func setupPanGesture() {
        panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePan(gesture:)))
        panGesture.delegate = self
        scrollView.addGestureRecognizer(panGesture)
    }

    private func beginInteractiveTransitionIfPossible(gesture: UIPanGestureRecognizer) {
        transitionCoordinator?.animate(alongsideTransition: nil, completion: { (context) in
            if context.isCancelled && gesture.state == .changed {
                if let delegate = self.transitioningDelegate as? TransitionDelegate {
                    delegate.dismissVelocity = self.getGestureVelocity(panGesture: gesture)
                    self.dismiss(animated: true, completion: nil)
                    self.beginInteractiveTransitionIfPossible(gesture: gesture)
                }
            }
        })
    }

    private func getGestureVelocity(panGesture: UIPanGestureRecognizer) -> CGFloat {
        let velocity = panGesture.velocity(in: scrollView)
        return velocity.y
    }

    // MARK: - Object Methods

    @objc func handlePan(gesture: UIPanGestureRecognizer) {
        guard scrollView.zoomScale == scrollView.initialZoomScale else { return }
        guard transitionCoordinator == nil else { return }

        if gesture.state == .began {
            if let delegate = transitioningDelegate as? TransitionDelegate {
                useInteractiveDismiss = true
                delegate.useInteractiveDismiss = true
                delegate.panGesture = gesture
                delegate.dismissVelocity = getGestureVelocity(panGesture: gesture)
                dismiss(animated: true)
                beginInteractiveTransitionIfPossible(gesture: gesture)
            } else if gesture.state == .changed {
                beginInteractiveTransitionIfPossible(gesture: gesture)
            }
        }
    }
}

// MARK: - UIGestureRecognizerDelegate

extension FullScreenPhotoProfileViewController: UIGestureRecognizerDelegate {

    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer,
                           shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}
