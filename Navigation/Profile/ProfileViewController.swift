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
    private lazy var heightHeaderInSection: CGFloat = 180
    private lazy var isExpanded = false
    private lazy var tapGestureRecognizer = UITapGestureRecognizer()
    private lazy var swipeUpGestureRecognizer = UISwipeGestureRecognizer()
    private lazy var swipeDownGestureRecognizer = UISwipeGestureRecognizer()
    private lazy var tapGesture = UITapGestureRecognizer()
    
    private lazy var backgroundBigAvatarImageView: UIView = {
        var backgroundView = UIView()
        backgroundView.alpha = 0
        backgroundView.backgroundColor = .white
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
        closeButton.tintColor = .black
        closeButton.alpha = 0
        closeButton.isUserInteractionEnabled = true
        closeButton.translatesAutoresizingMaskIntoConstraints = false
        return closeButton
    }()
        
    private lazy var scrollImageView: ImageScrollView = {
        let scrollImageView = ImageScrollView()
        return scrollImageView
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
        tableView.backgroundColor = .systemGray5
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
    }
    
    // MARK: - Private Methods
    
    private func setupNavigationBar() {
        self.navigationItem.title = ""
        self.navigationItem.backButtonTitle = "Назад"
    }
    
    private func setupView() {
        self.view.backgroundColor = .systemGray5
        
        self.scrollImageView = ImageScrollView(frame: self.view.bounds)
        self.scrollImageView.backgroundColor = .black
        self.scrollImageView.alpha = 0
        
        self.view.addSubview(self.tableView)
        self.view.addSubview(self.backgroundBigAvatarImageView)
        self.view.addSubview(self.bigAvatarImageView)
        self.view.addSubview(self.closeButtonBigAvatarView)
        self.view.addSubview(self.scrollImageView)
        self.view.bringSubviewToFront(self.backgroundBigAvatarImageView)
        self.view.bringSubviewToFront(self.bigAvatarImageView)
        self.view.bringSubviewToFront(self.closeButtonBigAvatarView)
        self.view.bringSubviewToFront(self.scrollImageView)
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
            self.closeButtonBigAvatarView.widthAnchor.constraint(equalToConstant: 40),
                      
            self.scrollImageView.topAnchor.constraint(equalTo: self.view.topAnchor),
            self.scrollImageView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            self.scrollImageView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            self.scrollImageView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor)
        ].compactMap({ $0 }))
    }
    
    private func setupGesture(){
        tapGestureRecognizer.addTarget(self, action: #selector(handleTapGesture(_:)))
        self.bigAvatarImageView.addGestureRecognizer(tapGestureRecognizer)
        swipeUpGestureRecognizer.addTarget(self, action: #selector(handleSwipeGesture(_:)))
        swipeUpGestureRecognizer.direction = .up
        swipeDownGestureRecognizer.addTarget(self, action: #selector(handleSwipeGesture(_:)))
        swipeDownGestureRecognizer.direction = .down
        self.scrollImageView.addGestureRecognizer(swipeUpGestureRecognizer)
        self.scrollImageView.addGestureRecognizer(swipeDownGestureRecognizer)
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
    
    @objc func handleSwipeGesture(_ gestureRecognizer: UISwipeGestureRecognizer) {
        print("swipe")
        switch gestureRecognizer {
        case swipeUpGestureRecognizer:
            hiddenBigPostImageView()
        case swipeDownGestureRecognizer:
            hiddenBigPostImageView()
        default:
            return
        }
        
        func hiddenBigPostImageView () {
            UIView.animate(withDuration: 0.3) {
                self.scrollImageView.alpha = 0
                
            } completion: { _ in
                
            }
            self.tabBarController?.tabBar.isHidden = false
        }
    }
}

// MARK: - UITableViewDataSource

extension ProfileViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        section == 0 ? 1 : dataSource.count
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
            let article = dataSource[indexPath.row]
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
        let view = tableView.dequeueReusableHeaderFooterView(withIdentifier: "Header") as? ProfileHeaderView
        view?.delegate = self
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
        heightHeaderInSection = textFieldIsVisible ? 230 : 180
        
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
                        .foregroundColor: UIColor.black,
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
                        .foregroundColor: UIColor.black,
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
            cell.likesButton.configuration?.baseBackgroundColor = #colorLiteral(red: 0.9886392951, green: 0.9445171952, blue: 0.9435593486, alpha: 1)
            cell.likesButton.configuration?.baseForegroundColor = .red
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
            cell.likesButton.configuration?.baseForegroundColor = .darkGray
            cell.likesButton.configuration?.title = "\(Int((cell.likesButton.configuration?.title)!)! - 1)"
            cell.likesButton.configuration?.image = UIImage(systemName: "suit.heart",
                                                            withConfiguration: UIImage.SymbolConfiguration(pointSize: 14.0,
                                                                                                           weight: .bold,
                                                                                                           scale: .large))
            completion()
        }
    }
    
    func didTapPictureImageView(imageCell: UIImage) {
        print("work")
        UIView.animate(withDuration: 0.3) {

            self.scrollImageView.alpha = 1
            self.scrollImageView.set(image: imageCell)
            self.view.layoutIfNeeded()
            
            self.tabBarController?.tabBar.isHidden = true
        }
    }
}


