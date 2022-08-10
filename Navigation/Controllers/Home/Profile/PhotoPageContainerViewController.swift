//
//  PhotoPageContainerViewController.swift
//  Navigation
//
//  Created by Антон Денисюк on 10.08.2022.
//

import UIKit

protocol PhotoPageContainerViewControllerDelegate: AnyObject {

    func containerViewController(_ containerViewController: PhotoPageContainerViewController,
                                 indexDidUpdate currentIndex: Int)
}

class PhotoPageContainerViewController: UIViewController {

    override var prefersStatusBarHidden: Bool {
        return true
    }

    // MARK: - Public Properties

    var images = [UIImage]()
    var currentIndex = 0
    var transitionController = ZoomTransitionController()
    var pageViewController = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal,
                                                  options: [.interPageSpacing: 30])

    weak var delegate: PhotoPageContainerViewControllerDelegate?

    // MARK: - Private Properties

    private var nextIndex: Int?
    private var panGestureRecognizer: UIPanGestureRecognizer!
    private var currentViewController: PhotoZoomViewController {
        return pageViewController.viewControllers![0] as! PhotoZoomViewController
    }

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupGesture()
        setupPageViewController()
    }

    // MARK: - Private Methods

    private func setupView() {
        view.backgroundColor = .black
        navigationController?.setNavigationBarHidden(true, animated: false)
    }

    private func setupGesture() {
        panGestureRecognizer = UIPanGestureRecognizer(target: self,
                                                      action: #selector(self.didPanWith(gestureRecognizer:)))
        panGestureRecognizer.delegate = self
    }

    private func setupPageViewController() {
        let photoZoomVC = PhotoZoomViewController()
        photoZoomVC.index = currentIndex
        photoZoomVC.image = images[currentIndex]

        let viewControllers = [
            photoZoomVC
        ]

        pageViewController.delegate = self
        pageViewController.dataSource = self
        pageViewController.view.addGestureRecognizer(panGestureRecognizer)
        pageViewController.setViewControllers(viewControllers, direction: .forward, animated: true,
                                              completion: nil)
        pageViewController.willMove(toParent: self)
        view.addSubview(pageViewController.view)
        pageViewController.didMove(toParent: self)
    }

    // MARK: - Object Methods

    @objc func didPanWith(gestureRecognizer: UIPanGestureRecognizer) {
        switch gestureRecognizer.state {
        case .began:
            currentViewController.scrollView.isScrollEnabled = false
            transitionController.isInteractive = true
            navigationController?.popViewController(animated: true)
        case .ended:
            if transitionController.isInteractive {
                currentViewController.scrollView.isScrollEnabled = true
                transitionController.isInteractive = false
                transitionController.didPanWith(gestureRecognizer: gestureRecognizer)
            }
        default:
            if transitionController.isInteractive {
                transitionController.didPanWith(gestureRecognizer: gestureRecognizer)
            }
        }
    }
}

// MARK: - UIGestureRecognizerDelegate

extension PhotoPageContainerViewController: UIGestureRecognizerDelegate {

    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        if let gestureRecognizer = gestureRecognizer as? UIPanGestureRecognizer {
            let velocity = gestureRecognizer.velocity(in: view)
            var velocityCheck: Bool = false
            velocityCheck = velocity.y < 0
            if velocityCheck { return false }
        }
        return true
    }

    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer,
                           shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        if otherGestureRecognizer == currentViewController.scrollView.panGestureRecognizer {
            if currentViewController.scrollView.contentOffset.y == 0 {
                return true
            }
        }
        return false
    }
}

// MARK: - UIPageViewControllerDataSource

extension PhotoPageContainerViewController: UIPageViewControllerDataSource {

    func pageViewController(_ pageViewController: UIPageViewController,
                            viewControllerBefore viewController: UIViewController) -> UIViewController? {
        if currentIndex == 0 { return nil }
        let photoZoomVC = PhotoZoomViewController()
        photoZoomVC.image = images[currentIndex - 1]
        photoZoomVC.index = currentIndex - 1
        return photoZoomVC
    }

    func pageViewController(_ pageViewController: UIPageViewController,
                            viewControllerAfter viewController: UIViewController) -> UIViewController? {
        if currentIndex == (images.count - 1) { return nil }
        let photoZoomVC = PhotoZoomViewController()
        photoZoomVC.image = images[currentIndex + 1]
        photoZoomVC.index = currentIndex + 1
        return photoZoomVC
    }
}

// MARK: - UIPageViewControllerDelegate

extension PhotoPageContainerViewController: UIPageViewControllerDelegate {

    func pageViewController(_ pageViewController: UIPageViewController,
                            willTransitionTo pendingViewControllers: [UIViewController]) {
        guard let nextVC = pendingViewControllers.first as? PhotoZoomViewController else { return }
        nextIndex = nextVC.index
    }

    func pageViewController(_ pageViewController: UIPageViewController,
                            didFinishAnimating finished: Bool,
                            previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {

        if completed && nextIndex != nil {
            previousViewControllers.forEach { photoZoomVC in
                let zoomVC = photoZoomVC as! PhotoZoomViewController
                zoomVC.scrollView.zoomScale = zoomVC.scrollView.minimumZoomScale
            }
            currentIndex = nextIndex!
            delegate?.containerViewController(self, indexDidUpdate: currentIndex)
        }
        nextIndex = nil
    }
}

// MARK: - ZoomAnimatorDelegate

extension PhotoPageContainerViewController: ZoomAnimatorDelegate {

    func transitionWillStartWith(zoomAnimator: ZoomAnimator) {}

    func transitionDidEndWith(zoomAnimator: ZoomAnimator) {}

    func referenceImageView(for zoomAnimator: ZoomAnimator) -> UIImageView? {
        return currentViewController.scrollView.imageZoomView
    }

    func referenceImageViewFrameInTransitioningView(for zoomAnimator: ZoomAnimator) -> CGRect? {
        return currentViewController.scrollView.convert(
            currentViewController.scrollView.imageZoomView.frame, to: currentViewController.view)
    }
}
