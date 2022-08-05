//
//  ProfileViewController.swift
//  Navigation
//
//  Created by Антон Денисюк on 07.03.2022.
//

import UIKit

final class ProfileViewController: UIViewController {
    
    // MARK: - Private Properties
    
    private var topConstraintBigProfileImageView: NSLayoutConstraint?
    private var leadingConstraintBigProfileImageView: NSLayoutConstraint?
    private var widthViewConstraintBigProfileImageView: NSLayoutConstraint?
    private var heightViewConstraintBigProfileImageView: NSLayoutConstraint?
    
    private lazy var arrayTapLikeIndexPath: [IndexPath] = []
    private lazy var heightHeaderInSection: CGFloat = 185
    private lazy var isExpanded = false
    private lazy var tapGestureRecognizer = UITapGestureRecognizer()
    
    static var currentImageFrame: CGRect?
    
    private let customTransitionDelegate = TransitionDelegate()
    
    private lazy var backgroundBigAvatarImageView: UIView = {
        var backgroundView = UIView()
        backgroundView.alpha = 0
        backgroundView.backgroundColor = .systemBackground
        backgroundView.translatesAutoresizingMaskIntoConstraints = false
        return backgroundView
    }()
    
    private lazy var bigAvatarImageView: UIImageView = {
        var imageView = UIImageView()
        imageView.isUserInteractionEnabled = true
        imageView.alpha = 0
        imageView.image = #imageLiteral(resourceName: "TimCook")
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 50
        imageView.clipsToBounds = true
        imageView.layer.borderColor = UIColor.white.cgColor
        imageView.layer.borderWidth = 3
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var closeButtonBigAvatarView: UIImageView = {
        let closeButton = UIImageView()
        closeButton.image = UIImage(systemName: "xmark.app.fill")
        closeButton.tintColor = .label
        closeButton.alpha = 0
        closeButton.isUserInteractionEnabled = true
        closeButton.translatesAutoresizingMaskIntoConstraints = false
        return closeButton
    }()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 44
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        tableView.separatorStyle = .none
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "DefaultCell")
        tableView.register(PostTableViewCell.self, forCellReuseIdentifier: "ArticleCell")
        tableView.register(PhotosTableViewCell.self, forCellReuseIdentifier: "PhotosCell")
        tableView.register(ProfileHeaderView.self, forHeaderFooterViewReuseIdentifier: "Header")
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = .systemBackground
        return tableView
    }()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupNavigationBar()
        self.setupView()
        self.setupConstraints()
        self.setupGesture()
    }
    
    // MARK: - Private Methods
    
    private func setupNavigationBar() {
        self.navigationItem.title = ""
        self.navigationItem.backButtonTitle = "Назад"
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "logout"),
                                                                style: .plain,
                                                                target: self,
                                                                action: #selector(logout(parameterSender:)))
        //        self.navigationController?.navigationBar.isHidden = true
        
    }
    
    private func setupView() {
        self.view.backgroundColor = .systemBackground
        self.title = "Профиль"
        self.view.addSubview(self.tableView)
        self.view.addSubview(self.backgroundBigAvatarImageView)
        self.view.addSubview(self.bigAvatarImageView)
        self.view.addSubview(self.closeButtonBigAvatarView)
        self.view.bringSubviewToFront(self.backgroundBigAvatarImageView)
        self.view.bringSubviewToFront(self.bigAvatarImageView)
        self.view.bringSubviewToFront(self.closeButtonBigAvatarView)
    }
    
    private func setupConstraints() {
        self.topConstraintBigProfileImageView = self.bigAvatarImageView.topAnchor.constraint(equalTo: backgroundBigAvatarImageView.safeAreaLayoutGuide.topAnchor)
        self.leadingConstraintBigProfileImageView = self.bigAvatarImageView.leadingAnchor.constraint(equalTo: backgroundBigAvatarImageView.safeAreaLayoutGuide.leadingAnchor, constant: 20)
        self.heightViewConstraintBigProfileImageView =  self.bigAvatarImageView.heightAnchor.constraint(equalToConstant: 100)
        self.widthViewConstraintBigProfileImageView =  self.bigAvatarImageView.widthAnchor.constraint(equalToConstant: 100)
        
        NSLayoutConstraint.activate([
            self.tableView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            self.tableView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor),
            self.tableView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor),
            self.tableView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor),
            
            self.backgroundBigAvatarImageView.topAnchor.constraint(equalTo: self.view.topAnchor),
            self.backgroundBigAvatarImageView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            self.backgroundBigAvatarImageView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            self.backgroundBigAvatarImageView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            
            self.topConstraintBigProfileImageView,
            self.leadingConstraintBigProfileImageView,
            self.heightViewConstraintBigProfileImageView,
            self.widthViewConstraintBigProfileImageView,
            
            self.closeButtonBigAvatarView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 5),
            self.closeButtonBigAvatarView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: -5),
            self.closeButtonBigAvatarView.heightAnchor.constraint(equalToConstant: 40),
            self.closeButtonBigAvatarView.widthAnchor.constraint(equalToConstant: 40)
        ].compactMap({ $0 }))
    }
    
    private func setupGesture(){
        self.tapGestureRecognizer.addTarget(self, action: #selector(handleTapGesture(_:)))
        self.bigAvatarImageView.addGestureRecognizer(tapGestureRecognizer)
    }
    
    private func animationProfileImageView() {
        self.isExpanded.toggle()
        self.widthViewConstraintBigProfileImageView?.constant = self.isExpanded ? self.view.frame.width : 100
        self.heightViewConstraintBigProfileImageView?.constant = self.isExpanded ? self.view.frame.width : 100
        self.topConstraintBigProfileImageView?.constant = self.isExpanded ? (self.backgroundBigAvatarImageView.safeAreaLayoutGuide.layoutFrame.height - self.backgroundBigAvatarImageView.safeAreaLayoutGuide.layoutFrame.width) / 2 : 70
        self.leadingConstraintBigProfileImageView?.constant = self.isExpanded ? 0 : 20
        
        self.isExpanded ? closeButtonBigAvatarView.addGestureRecognizer(tapGestureRecognizer) : bigAvatarImageView.addGestureRecognizer(tapGestureRecognizer)
        
        UIView.animate(withDuration: 0.4) {
            self.bigAvatarImageView.layer.cornerRadius = self.isExpanded ? 0 : 50
            self.bigAvatarImageView.alpha = self.isExpanded ? 1 : 0
            self.backgroundBigAvatarImageView.alpha = self.isExpanded ? 0.7 : 0
            self.closeButtonBigAvatarView.alpha = self.isExpanded ? 1 : 0
            self.view.layoutIfNeeded()
        }
    }
    
    // MARK: - Object Methods
    
    @objc func handleTapGesture(_ gestureRecognizer: UITapGestureRecognizer) {
        guard tapGestureRecognizer === gestureRecognizer else { return }
        animationProfileImageView()
    }
    
    @objc func logout(parameterSender: Any) {
        let alert = UIAlertController(title: "Вы действительно хотите выйти из аккаунта?",
                                      message: nil,
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Выйти",
                                      style: .default,
                                      handler: { action in
            SceneDelegate.shared?.rootViewController.switchToLogInViewController()
        }))
        alert.addAction(UIAlertAction(title: "Отмена", style: .cancel))
        self.present(alert, animated: true, completion: nil)
    }
}

// MARK: - UITableViewDataSource

extension ProfileViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        section == 0 ? 1 : Post.data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "PhotosCell",
                                                           for: indexPath) as? PhotosTableViewCell else {
                let cell = tableView.dequeueReusableCell(withIdentifier: "DefaultCell", for: indexPath)
                return cell
            }
            return cell
        } else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "ArticleCell",
                                                           for: indexPath) as? PostTableViewCell else {
                let cell = tableView.dequeueReusableCell(withIdentifier: "DefaultCell", for: indexPath)
                return cell
            }
            let article = Post.data[indexPath.row]
            let viewModel = PostTableViewCell.ViewModel(author: article.author,
                                                        description: article.description,
                                                        image: article.image,
                                                        likes: article.likes,
                                                        views: article.views + 1)
            cell.delegate = self
            cell.setup(with: viewModel)
            cell.likeButtonTag = indexPath.row
            if arrayTapLikeIndexPath.contains(indexPath) {
                cell.clickedLikeSelectedCell()
            }
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        return " "
    }
}

// MARK: - UITableViewDelegate

extension ProfileViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard section == 0 else { return nil }
        guard let view = tableView.dequeueReusableHeaderFooterView(withIdentifier: "Header") as? ProfileHeaderView else { return nil }
        view.delegate = self
        return view
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return section == 0 ? heightHeaderInSection : 0
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard indexPath.section == 0 else { return }
        let PhotoVC = PhotosViewController()
        navigationController?.pushViewController(PhotoVC, animated: true)
        tableView.deselectRow(at: indexPath, animated: false)
    }
}

// MARK: - ProfileHeaderViewProtocol

extension ProfileViewController: ProfileHeaderViewProtocol {
    
    func didTapStatusButton(textFieldIsVisible: Bool, completion: @escaping () -> Void) {
        heightHeaderInSection = textFieldIsVisible ? 235 : 185
        
        UIView.animate(withDuration: 0.3, delay: 0.0) {
            self.tableView.beginUpdates()
            self.view.layoutIfNeeded()
            self.tableView.endUpdates()
        } completion: { _ in
            completion()
        }
    }
    
    func resizeProfileImage() {
        animationProfileImageView()
    }
}

// MARK: - PostTableViewCellProtocol

extension ProfileViewController: PostTableViewCellProtocol {
    
    func didTapDescriptionTextView(cell: PostTableViewCell) {
        guard let text = cell.descriptionTextView.attributedText?.string else { return }
        let textToTap = cell.isExpandedCell ? "Скрыть текст" : "... Еще"
        if let range = text.range(of: textToTap),
           cell.tapGestureDescriptionTextView.didTapAttributedTextInTextView(textView: cell.descriptionTextView, inRange: NSRange(range, in: text)) {
            if cell.isExpandedCell {
                cell.isExpandedCell.toggle()
                self.view.layoutIfNeeded()
                UIView.animate(withDuration: 0.3, animations: {
                    self.tableView.beginUpdates()
                    var changedText =  (cell.descriptionTextView.text! as NSString).substring(with: NSRange(location: 0, length: 160))
                    changedText += "... Еще "
                    cell.descriptionTextView.text = changedText
                    let attributes: [NSAttributedString.Key: NSObject] = [
                        .foregroundColor: UIColor.label,
                        .font: UIFont.systemFont(ofSize: 14.0),
                    ]
                    let attributedString = NSMutableAttributedString(string: changedText, attributes: attributes)
                    attributedString.addAttribute(.link, value: "", range: NSRange(location: 160, length: 7))
                    cell.descriptionTextView.attributedText = attributedString
                    self.view.layoutIfNeeded()
                    self.tableView.endUpdates()
                })
            } else {
                cell.isExpandedCell.toggle()
                let changedText = cell.fullTextTextView
                self.view.layoutIfNeeded()
                UIView.animate(withDuration: 0.3, animations: {
                    self.tableView.beginUpdates()
                    cell.descriptionTextView.text = changedText + "\n\nСкрыть текст "
                    let attributes: [NSAttributedString.Key: NSObject] = [
                        .foregroundColor: UIColor.label,
                        .font: UIFont.systemFont(ofSize: 14.0),
                    ]
                    let attributedString = NSMutableAttributedString(string: cell.descriptionTextView.text,
                                                                     attributes: attributes)
                    attributedString.addAttribute(.link, value: "", range: NSRange(location: changedText.count,
                                                                                   length: 14))
                    cell.descriptionTextView.attributedText = attributedString
                    self.view.layoutIfNeeded()
                    self.tableView.endUpdates()
                })
            }
        }
    }
    
    func didTapLikeButton(cell: PostTableViewCell, completion: @escaping () -> Void) {
        arrayTapLikeIndexPath = arrayTapLikeIndexPath.count > 30 ? Array(arrayTapLikeIndexPath.suffix(10)) : arrayTapLikeIndexPath
        cell.likesButton.tag = cell.likeButtonTag
        arrayTapLikeIndexPath.contains(IndexPath(row: cell.likesButton.tag, section: 1)) ? arrayTapLikeIndexPath = arrayTapLikeIndexPath.filter { $0 != IndexPath(row: cell.likesButton.tag, section: 1) } : arrayTapLikeIndexPath.append(IndexPath(row: cell.likesButton.tag, section: 1))
        if !cell.isSelectedLike {
            cell.likesButton.configuration?.baseBackgroundColor = UIColor.customBaseBackgroundButton
            cell.likesButton.configuration?.baseForegroundColor = .systemRed
            cell.likesButton.configuration?.title = "\(Int((cell.likesButton.configuration?.title)!)! + 1)"
            cell.likesButton.configuration?.image = UIImage(systemName: "heart.fill",
                                                            withConfiguration: UIImage.SymbolConfiguration(pointSize: 7.0,
                                                                                                           weight: .bold,
                                                                                                           scale: .large))
            self.view.layoutIfNeeded()
            UIView.animate(withDuration: 0.4,
                           delay: 0.0,
                           usingSpringWithDamping: 0.15,
                           initialSpringVelocity: 3,
                           options: .curveLinear) {
                self.tableView.beginUpdates()
                cell.likesButton.configuration?.image = UIImage(systemName: "heart.fill",
                                                                withConfiguration: UIImage.SymbolConfiguration(pointSize: 14.0,
                                                                                                               weight: .bold,
                                                                                                               scale: .large))
                self.view.layoutIfNeeded()
                self.tableView.endUpdates()
                
                completion()
            }
        } else {
            cell.likesButton.configuration?.baseBackgroundColor = .systemGray5
            cell.likesButton.configuration?.baseForegroundColor = UIColor.customBaseForegroundButton
            cell.likesButton.configuration?.title = "\(Int((cell.likesButton.configuration?.title)!)! - 1)"
            cell.likesButton.configuration?.image = UIImage(systemName: "suit.heart",
                                                            withConfiguration: UIImage.SymbolConfiguration(pointSize: 14.0,
                                                                                                           weight: .bold,
                                                                                                           scale: .large))
            completion()
        }
    }
    
    func didTapPictureImageView(cell: PostTableViewCell) {
        cell.pictureView.isUserInteractionEnabled = false
        cell.pictureView.isHidden = true
        
        let fullScreenPhotoProfileVC = FullScreenPhotoProfileViewController()
        fullScreenPhotoProfileVC.modalPresentationStyle = .fullScreen
        fullScreenPhotoProfileVC.modalTransitionStyle = .crossDissolve
        fullScreenPhotoProfileVC.image = cell.pictureView.image
        self.customTransitionDelegate.imageView = cell.pictureView
        
        fullScreenPhotoProfileVC.transitioningDelegate = customTransitionDelegate
        transitioningDelegate = customTransitionDelegate
        self.present(fullScreenPhotoProfileVC, animated: true) {
            cell.pictureView.isUserInteractionEnabled = true
            cell.pictureView.isHidden = false
        }
        
        
        //        let realCellPictureViewY76 = cell.borderView.frame.origin.y + cell.backView.frame.origin.y + cell.pictureView.frame.origin.y
        
        //        let rect = cell.convert(cell.pictureView.frame, to: self.view)
        //        cell.customTransitionDelegate.imageView?.frame = CGRect(origin: CGPoint(x: rect.origin.x,
        //                                                                                y: rect.origin.y + realCellPictureViewY76),
        //                                                                size: rect.size)
        
        //        let cellRect = cell.convert(cell.pictureView.frame, to: self.view)
        //
        //        ProfileViewController.currentImageFrame = cell.pictureView.frame
        //
        
        //        print(cell.customTransitionDelegate.imageView?.frame)
        //        if let indexPath = tableView.indexPath(for: cell) {
        //            let rectRow = self.tableView.rectForRow(at: indexPath)
        //            let rectInScreen = self.tableView.convert(rectRow, to: self.view)
        //            print("\n!!! rectRowInScreen - \(rectInScreen)\n")
        //            let rectImage = cell.convert(cell.pictureView.frame, to: self.view)
        //        }
        

    }
}

