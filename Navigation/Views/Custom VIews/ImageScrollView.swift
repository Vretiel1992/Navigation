//
//  ImageScrollView.swift
//  Navigation
//
//  Created by Антон Денисюк on 04.06.2022.
//

import UIKit

class ImageScrollView: UIScrollView {

    // MARK: - Public Properties

    var imageZoomView: UIImageView!
    var initialZoomScale: CGFloat = 0

    lazy var zoomingTap: UITapGestureRecognizer = {
        let zoomingTap = UITapGestureRecognizer(target: self, action: #selector(handleZoomingTap))
        zoomingTap.numberOfTapsRequired = 2
        return zoomingTap
    }()

    // MARK: - Initializers

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.delegate = self
        self.showsVerticalScrollIndicator = false
        self.showsHorizontalScrollIndicator = false
        self.decelerationRate = UIScrollView.DecelerationRate.fast
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Override Methods

    override func layoutSubviews() {
        super.layoutSubviews()
        centerImage()
    }

    // MARK: - Public Methods

    func set(image: UIImage) {
        imageZoomView?.removeFromSuperview()
        imageZoomView = nil
        imageZoomView = UIImageView(image: image)
        self.addSubview(imageZoomView)
        configurateFor(imageSize: image.size)
    }

    func configurateFor(imageSize: CGSize) {
        self.contentSize = imageSize

        setCurrentMaxAndMinZoomScale()
        self.zoomScale = self.minimumZoomScale
        initialZoomScale = self.minimumZoomScale
        imageZoomView.addGestureRecognizer(zoomingTap)
        imageZoomView.isUserInteractionEnabled = true
    }

    func setCurrentMaxAndMinZoomScale() {
        let boundsSize = self.bounds.size
        let imageSize = imageZoomView.bounds.size

        let xScale = boundsSize.width / imageSize.width
        let yScale = boundsSize.height / imageSize.height
        let minScale = min(xScale, yScale)

        let maxScale: CGFloat = 3.5

        self.minimumZoomScale = minScale
        self.maximumZoomScale = maxScale
    }

    func centerImage() {
        let boundsSize = self.bounds.size
        var frameToCenter = imageZoomView.frame

        if frameToCenter.size.width < boundsSize.width {
            frameToCenter.origin.x = (boundsSize.width - frameToCenter.size.width) / 2
        } else {
            frameToCenter.origin.x = 0
        }

        if frameToCenter.size.height < boundsSize.height {
            frameToCenter.origin.y = (boundsSize.height - frameToCenter.size.height) / 2
        } else {
            frameToCenter.origin.y = 0
        }

        imageZoomView.frame = frameToCenter
    }

    func zoom(point: CGPoint, animated: Bool) {
        let currectScale = self.zoomScale
        let minScale = self.minimumZoomScale
        let maxScale = self.maximumZoomScale

        if minScale == maxScale && minScale > 1 {
            return
        }

        let toScale = maxScale
        let finalScale = (currectScale == minScale) ? toScale : minScale
        let zoomRect = zoomRect(scale: finalScale, center: point)
        self.zoom(to: zoomRect, animated: animated)
    }

    func zoomRect(scale: CGFloat, center: CGPoint) -> CGRect {
        var zoomRect = CGRect.zero
        let bounds = self.bounds

        zoomRect.size.width = bounds.size.width / scale
        zoomRect.size.height = bounds.size.height / scale

        zoomRect.origin.x = center.x - (zoomRect.size.width / 2)
        zoomRect.origin.y = center.y - (zoomRect.size.height / 2)
        return zoomRect
    }

    // MARK: - Object Methods

    @objc func handleZoomingTap(sender: UITapGestureRecognizer) {
        let location = sender.location(in: sender.view)
        zoom(point: location, animated: true)
    }
}

// MARK: - UIScrollViewDelegate

extension ImageScrollView: UIScrollViewDelegate {

    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageZoomView
    }

    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        centerImage()
    }
}
