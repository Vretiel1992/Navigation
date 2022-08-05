//
//  PostTableViewCell.swift
//  Navigation
//
//  Created by Антон Денисюк on 10.04.2022.
//

import UIKit

protocol PostTableViewCellProtocol: AnyObject {
    func didTapDescriptionTextView(cell: PostTableViewCell)
    func didTapLikeButton(cell: PostTableViewCell, completion: @escaping () -> Void)
    func didTapPictureImageView(cell: PostTableViewCell)
}

class PostTableViewCell: UITableViewCell, UITextViewDelegate {
    
    struct ViewModel: ViewModelProtocol {
        let author, description, image: String
        var likes, views: Int
    }
    
    var likeButtonTag = 0
    var isExpandedCell = false
    var isSelectedLike = false
    var fullTextTextView = ""
    
    let tapGestureDescriptionTextView = UITapGestureRecognizer()
    let tapGesturePictureImageView = UITapGestureRecognizer()
    
    lazy var separatorView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.customBackgroundAppOne
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var borderView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemGray3
        view.layer.cornerRadius = 15
        view.clipsToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var backView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.customBackgroundAppTwo
        view.layer.cornerRadius = 15
        view.clipsToBounds = true
        view.layer.maskedCorners = [
            .layerMinXMaxYCorner,
            .layerMinXMinYCorner,
            .layerMaxXMaxYCorner,
            .layerMaxXMinYCorner
        ]
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var likesButton: UIButton = {
        let button = UIButton()
        var config = UIButton.Configuration.gray()
        config.cornerStyle = .capsule
        config.image = UIImage(systemName: "suit.heart",
                               withConfiguration: UIImage.SymbolConfiguration(pointSize: 14.0,
                                                                              weight: .bold,
                                                                              scale: .large))
        config.imagePadding = 5
        config.buttonSize = .mini
        
        config.baseForegroundColor = UIColor.customBaseForegroundButton
        
        button.configuration = config
        button.addTarget(self, action: #selector(tapLikeButton(parameterSender:)), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var authorLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.textColor = .label
        label.numberOfLines = 2
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var descriptionTextView: UITextView = {
        let textView = UITextView()
        textView.textAlignment = .left
        textView.textContainerInset = .zero
        textView.backgroundColor = UIColor.customBackgroundAppTwo
        textView.isScrollEnabled = false
        textView.isEditable = false
        textView.isSelectable = false
        textView.dataDetectorTypes = .link
        textView.textContainer.lineBreakMode = .byTruncatingTail
        textView.showsHorizontalScrollIndicator = false
        textView.showsVerticalScrollIndicator = false
        textView.delegate = self
        textView.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        textView.isUserInteractionEnabled = true
        textView.translatesAutoresizingMaskIntoConstraints = false
        return textView
    }()
    
    lazy var pictureView: UIImageView = {
        let imageView = UIImageView()
//        imageView.setContentHuggingPriority(UILayoutPriority(251), for: .horizontal)
//        imageView.setContentHuggingPriority(UILayoutPriority(251), for: .vertical)
//        imageView.setContentCompressionResistancePriority(UILayoutPriority(750), for: .horizontal)
        imageView.setContentCompressionResistancePriority(UILayoutPriority(750), for: .vertical)
        imageView.contentMode = .scaleAspectFit
        imageView.isUserInteractionEnabled = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    
    private lazy var viewsButtonOff: UIButton = {
        let button = UIButton()
        var config = UIButton.Configuration.plain()
        config.cornerStyle = .capsule
        config.image = UIImage(systemName: "eye.fill",
                               withConfiguration: UIImage.SymbolConfiguration(pointSize: 14.0,
                                                                              weight: .bold,
                                                                              scale: .large))
        config.imagePadding = 5
        config.buttonSize = .mini
        config.baseForegroundColor = .systemGray
        button.configuration = config
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var postStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 16
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private lazy var likesAndViewsStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .equalCentering
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    weak var delegate: PostTableViewCellProtocol?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.setupView()
        self.setupConstraints()
        self.setupGesture()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.authorLabel.text = nil
        self.pictureView.image = nil
        self.descriptionTextView.text = nil
        self.likesButton.configuration?.title = nil
        self.viewsButtonOff.configuration?.title = nil
        isExpandedCell = false
        isSelectedLike = false
        self.likesButton.configuration?.baseBackgroundColor = .systemGray5
        self.likesButton.configuration?.baseForegroundColor = UIColor.customBaseForegroundButton
        self.likesButton.configuration?.image = UIImage(systemName: "suit.heart", withConfiguration: UIImage.SymbolConfiguration(pointSize: 14.0, weight: .bold, scale: .large))
    }
    
    private func setupView() {
        self.selectionStyle = .none
        self.backgroundColor = UIColor(named: "colorCellTableView")
        self.contentView.backgroundColor = UIColor.customBackgroundAppOne
        contentView.addSubview(self.separatorView)
        contentView.addSubview(self.borderView)
        self.borderView.addSubview(self.backView)
        self.backView.addSubview(self.authorLabel)
        self.backView.addSubview(self.pictureView)
        self.backView.addSubview(self.postStackView)
        self.postStackView.addArrangedSubview(self.descriptionTextView)
        self.postStackView.addArrangedSubview(self.likesAndViewsStackView)
        self.likesAndViewsStackView.addArrangedSubview(self.likesButton)
        self.likesAndViewsStackView.addArrangedSubview(self.viewsButtonOff)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            self.separatorView.topAnchor.constraint(equalTo: contentView.topAnchor),
            self.separatorView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            self.separatorView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            self.separatorView.heightAnchor.constraint(equalToConstant: 10),
            
            self.borderView.topAnchor.constraint(equalTo: self.separatorView.bottomAnchor),
            self.borderView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            self.borderView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            self.borderView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            self.backView.topAnchor.constraint(equalTo: self.borderView.topAnchor, constant: 2.0),
            self.backView.leadingAnchor.constraint(equalTo: self.borderView.leadingAnchor),
            self.backView.trailingAnchor.constraint(equalTo: self.borderView.trailingAnchor),
            self.backView.bottomAnchor.constraint(equalTo: self.borderView.bottomAnchor, constant: -2.0),
            
            self.authorLabel.topAnchor.constraint(equalTo: self.backView.topAnchor, constant: 8),
            self.authorLabel.leadingAnchor.constraint(equalTo: self.backView.leadingAnchor, constant: 8),
            self.authorLabel.trailingAnchor.constraint(equalTo: self.backView.trailingAnchor, constant: -8),
            
            self.pictureView.topAnchor.constraint(equalTo: self.authorLabel.bottomAnchor, constant: 8),
            self.pictureView.leadingAnchor.constraint(equalTo: self.backView.leadingAnchor),
            self.pictureView.trailingAnchor.constraint(equalTo: self.backView.trailingAnchor),
            
            self.postStackView.topAnchor.constraint(equalTo: self.pictureView.bottomAnchor, constant: 8),
            self.postStackView.leadingAnchor.constraint(equalTo: self.backView.leadingAnchor, constant: 8),
            self.postStackView.trailingAnchor.constraint(equalTo: self.backView.trailingAnchor, constant: -8),
            self.postStackView.bottomAnchor.constraint(equalTo: self.backView.bottomAnchor, constant: -12)
        ])
    }
    
    private func setupGesture() {
        tapGestureDescriptionTextView.numberOfTapsRequired = 1
        descriptionTextView.addGestureRecognizer(tapGestureDescriptionTextView)
        tapGestureDescriptionTextView.addTarget(self, action: #selector(handleTapGestureDescription(_:)))
        tapGesturePictureImageView.numberOfTapsRequired = 1
        pictureView.addGestureRecognizer(tapGesturePictureImageView)
        tapGesturePictureImageView.addTarget(self, action: #selector(handleTapGesturePicture(_:)))
    }
    
    private func setupCutTextView() {
        if descriptionTextView.text.count >= 160 {
            self.fullTextTextView = descriptionTextView.text!
            var changedText =  (descriptionTextView.text! as NSString).substring(with: NSRange(location: 0, length: 160))
            changedText += "... Еще "
            descriptionTextView.text = changedText
            let attributes: [NSAttributedString.Key: NSObject] = [
                .foregroundColor: UIColor.label,
                .font: UIFont.systemFont(ofSize: 14.0),
            ]
            let attributedString = NSMutableAttributedString(string: changedText, attributes: attributes)
            attributedString.addAttribute(.link, value: "", range: NSRange(location: 160, length: 7))
            descriptionTextView.attributedText = attributedString
        }
    }
    
    @objc private func handleTapGestureDescription(_ gestureRecognizer: UITapGestureRecognizer) {
        guard tapGestureDescriptionTextView === gestureRecognizer else { return }
        self.delegate?.didTapDescriptionTextView(cell: self)
    }
    
    @objc private func tapLikeButton(parameterSender: Any) {
        self.delegate?.didTapLikeButton(cell: self) { [weak self] in
            self?.isSelectedLike.toggle()
        }
    }
    
    @objc private func handleTapGesturePicture(_ gestureRecognizer: UITapGestureRecognizer) {
        guard tapGesturePictureImageView === gestureRecognizer else { return }
        self.delegate?.didTapPictureImageView(cell: self)
    }
    
    func clickedLikeSelectedCell() {
        self.likesButton.configuration?.baseBackgroundColor = UIColor.customBaseBackgroundButton
        self.likesButton.configuration?.baseForegroundColor = .systemRed
        self.likesButton.configuration?.title = "\(Int((self.likesButton.configuration?.title)!)! + 1)"
        self.likesButton.configuration?.image = UIImage(systemName: "heart.fill",
                                                        withConfiguration: UIImage.SymbolConfiguration(pointSize: 14.0,
                                                                                                       weight: .bold,
                                                                                                       scale: .large))
        self.isSelectedLike = true
    }
}

extension PostTableViewCell: Setupable {
    
    func setup(with viewModel: ViewModelProtocol) {
        guard let viewModel = viewModel as? ViewModel else { return }
        self.authorLabel.text = viewModel.author
        self.pictureView.image = UIImage(named: viewModel.image)
        self.likesButton.configuration?.title = "\(viewModel.likes)"
        self.viewsButtonOff.configuration?.title = "\(viewModel.views)"
        self.descriptionTextView.text = viewModel.description
        setupCutTextView()
    }
}

