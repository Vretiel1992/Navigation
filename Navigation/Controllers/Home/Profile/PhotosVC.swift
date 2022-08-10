//
//  PhotosVC.swift
//  Navigation
//
//  Created by Антон Денисюк on 22.04.2022.
//

import UIKit

final class PhotosVC: UIViewController {

    // MARK: - Public Properties

    var currentLeftSafeAreaInset: CGFloat = 0.0
    var currentRightSafeAreaInset: CGFloat = 0.0

    // MARK: - Private Properties

    private let photoGallery = PhotoGallery()
    private var selectedIndexPath: IndexPath = IndexPath()

    private lazy var layout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumInteritemSpacing = 8
        layout.minimumLineSpacing = 8
        return layout
    }()

    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .systemGray6
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "DefaultCell")
        collectionView.register(PhotosCollectionViewCell.self, forCellWithReuseIdentifier: "PhotosVCCell")
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.setNavigationBarHidden(true, animated: false)
        setupNavigationBar()
        setupView()
        setupConstraints()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = false
        navigationController?.setNavigationBarHidden(false, animated: true)
    }

    override func viewWillLayoutSubviews() {
        view.frame = CGRect(origin: CGPoint(x: 0, y: 0), size: view.bounds.size)
        collectionView.frame = CGRect(origin: CGPoint(x: 0, y: 0), size: view.bounds.size)

        collectionView.contentInsetAdjustmentBehavior = .never
        let statusBarHeight: CGFloat = view.window?.windowScene?.statusBarManager?.statusBarFrame.height ?? 0
        let navBarHeight: CGFloat = navigationController?.navigationBar.frame.height ?? 0
        edgesForExtendedLayout = .all
        let tabBarHeight = tabBarController?.tabBar.frame.height ?? 0
        collectionView.contentInset = UIEdgeInsets(top: (navBarHeight) + statusBarHeight,
                                                   left: 0.0, bottom: tabBarHeight, right: 0.0)
    }

    // MARK: - Override Methods

    override func viewSafeAreaInsetsDidChange() {
        self.currentLeftSafeAreaInset = self.view.safeAreaInsets.left
        self.currentRightSafeAreaInset = self.view.safeAreaInsets.right
    }

    // MARK: - Private Methods

    private func setupNavigationBar() {
        navigationItem.title = "Фотогалерея"
    }

    private func setupView() {
        view.addSubview(collectionView)
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}

// MARK: - UICollectionViewDataSource

extension PhotosVC: UICollectionViewDataSource {

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photoGallery.images.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotosVCCell",
                                                            for: indexPath) as? PhotosCollectionViewCell else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DefaultCell", for: indexPath)
            return cell
        }
        cell.setImage(name: photoGallery.images[indexPath.item])
        return cell
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension PhotosVC: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let widthAndHeight = floor((collectionView.frame.width - 32) / 3)
        return CGSize(width: widthAndHeight, height: widthAndHeight)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedIndexPath = indexPath
        let photoPageController = PhotoPageContainerViewController()
        photoPageController.images = photoGallery.images
        photoPageController.currentIndex = selectedIndexPath.row

        navigationController?.delegate = photoPageController.transitionController
        photoPageController.transitionController.fromDelegate = self
        photoPageController.transitionController.toDelegate = photoPageController
        photoPageController.delegate = self
        navigationController?.pushViewController(photoPageController, animated: true)
    }

    func getImageViewFromCollectionViewCell(for selectedIndexPath: IndexPath) -> UIImageView {
        let visibleCells = collectionView.indexPathsForVisibleItems
        if !visibleCells.contains(self.selectedIndexPath) {
            collectionView.scrollToItem(at: self.selectedIndexPath, at: .centeredVertically, animated: false)
            collectionView.reloadItems(at: collectionView.indexPathsForVisibleItems)
            collectionView.layoutIfNeeded()

            guard let guardedCell = (collectionView.cellForItem(at: self.selectedIndexPath)
                                     as? PhotosCollectionViewCell) else {
                return UIImageView(frame: CGRect(x: UIScreen.main.bounds.midX,
                                                 y: UIScreen.main.bounds.midY, width: 100.0, height: 100.0))
            }
            return guardedCell.imageView
        } else {
            guard let guardedCell = collectionView.cellForItem(at: self.selectedIndexPath)
                    as? PhotosCollectionViewCell else {
                return UIImageView(frame: CGRect(x: UIScreen.main.bounds.midX,
                                                 y: UIScreen.main.bounds.midY, width: 100.0, height: 100.0))
            }
            return guardedCell.imageView
        }
    }

    func getFrameFromCollectionViewCell(for selectedIndexPath: IndexPath) -> CGRect {
        let visibleCells = collectionView.indexPathsForVisibleItems
        if !visibleCells.contains(self.selectedIndexPath) {
            collectionView.scrollToItem(at: self.selectedIndexPath, at: .centeredVertically, animated: false)
            collectionView.reloadItems(at: collectionView.indexPathsForVisibleItems)
            collectionView.layoutIfNeeded()
            guard let guardedCell = (collectionView.cellForItem(at: self.selectedIndexPath)
                                     as? PhotosCollectionViewCell) else {
                return CGRect(x: UIScreen.main.bounds.midX, y: UIScreen.main.bounds.midY, width: 100.0, height: 100.0)
            }
            return guardedCell.frame
        } else {
            guard let guardedCell = (collectionView.cellForItem(at: self.selectedIndexPath)
                                     as? PhotosCollectionViewCell) else {
                return CGRect(x: UIScreen.main.bounds.midX, y: UIScreen.main.bounds.midY, width: 100.0, height: 100.0)
            }
            return guardedCell.frame
        }
    }
}

// MARK: - PhotoPageContainerViewControllerDelegate

extension PhotosVC: PhotoPageContainerViewControllerDelegate {

    func containerViewController(_ containerViewController: PhotoPageContainerViewController,
                                 indexDidUpdate currentIndex: Int) {
        selectedIndexPath = IndexPath(row: currentIndex, section: 0)
        collectionView.scrollToItem(at: selectedIndexPath, at: .centeredVertically, animated: false)
    }
}

// MARK: - ZoomAnimatorDelegate

extension PhotosVC: ZoomAnimatorDelegate {

    func transitionWillStartWith(zoomAnimator: ZoomAnimator) {}

    func transitionDidEndWith(zoomAnimator: ZoomAnimator) {
        let cell = collectionView.cellForItem(at: selectedIndexPath) as! PhotosCollectionViewCell
        let cellFrame = collectionView.convert(cell.frame, to: view)
        if cellFrame.minY < collectionView.contentInset.top {
            collectionView.scrollToItem(at: selectedIndexPath, at: .top, animated: false)
        } else if cellFrame.maxY > view.frame.height - collectionView.contentInset.bottom {
            collectionView.scrollToItem(at: selectedIndexPath, at: .bottom, animated: false)
        }
    }

    func referenceImageView(for zoomAnimator: ZoomAnimator) -> UIImageView? {
        let referenceImageView = getImageViewFromCollectionViewCell(for: selectedIndexPath)
        return referenceImageView
    }

    func referenceImageViewFrameInTransitioningView(for zoomAnimator: ZoomAnimator) -> CGRect? {
        view.layoutIfNeeded()
        collectionView.layoutIfNeeded()
        let unconvertedFrame = getFrameFromCollectionViewCell(for: selectedIndexPath)
        let cellFrame = collectionView.convert(unconvertedFrame, to: view)
        if cellFrame.minY < collectionView.contentInset.top {
            return CGRect(x: cellFrame.minX,
                          y: collectionView.contentInset.top,
                          width: cellFrame.width,
                          height: cellFrame.height - (collectionView.contentInset.top - cellFrame.minY))
        }
        return cellFrame
    }
}
