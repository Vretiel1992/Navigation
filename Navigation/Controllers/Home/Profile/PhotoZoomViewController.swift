//
//  PhotoZoomViewController.swift
//  Navigation
//
//  Created by Антон Денисюк on 10.08.2022.
//

import UIKit

protocol PhotoZoomViewControllerDelegate: AnyObject {

    func photoZoomViewController(_ photoZoomViewController: PhotoZoomViewController,
                                 scrollViewDidScroll scrollView: UIScrollView)
}

class PhotoZoomViewController: UIViewController {

    // MARK: - Public Properties

    var image: UIImage?
    var scrollView: ImageScrollView!
    var index: Int = 0

    weak var delegate: PhotoZoomViewControllerDelegate?

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupImageScrollView()
    }

    // MARK: - Override Methods

    override func viewSafeAreaInsetsDidChange() {
        guard let parentVC = navigationController?.viewControllers.first as? PhotosVC else {
            return
        }
        parentVC.currentLeftSafeAreaInset = view.safeAreaInsets.left
        parentVC.currentRightSafeAreaInset = view.safeAreaInsets.right
    }

    // MARK: - Public Methods

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        delegate?.photoZoomViewController(self, scrollViewDidScroll: scrollView)
    }

    // MARK: - Private Methods

    private func setupView() {
        view.backgroundColor = .black
        navigationController?.setNavigationBarHidden(true, animated: false)
    }

    private func setupImageScrollView() {
        scrollView = ImageScrollView(frame: view.bounds)
        scrollView.set(image: image!)
        scrollView.imageZoomView.contentMode = .scaleAspectFit
        scrollView.contentInsetAdjustmentBehavior = .never
        view.addSubview(scrollView)
    }
}
