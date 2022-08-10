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

    // MARK: - Public Properties

    var likeButtonTag = 0
    var isExpandedCell = false
    var isSelectedLike = false
    var fullTextTextView = ""

    weak var delegate: PostTableViewCellProtocol?

    let tapGestureDescriptionTextView = UITapGestureRecognizer()
    let tapGesturePictureImageView = UITapGestureRecognizer()

    lazy var pictureView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.isUserInteractionEnabled = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
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

    // MARK: - Private Properties

    private lazy var separatorView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.customBackgroundAppOne
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private lazy var borderView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemGray3
        view.layer.cornerRadius = 15
        view.clipsToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private lazy var backView: UIView = {
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

    private lazy var authorLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.textColor = .label
        label.numberOfLines = 2
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
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

    // MARK: - Initializers

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
        setupConstraints()
        setupGesture()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Override Methods

    override func prepareForReuse() {
        super.prepareForReuse()
        authorLabel.text = nil
        pictureView.image = nil
        descriptionTextView.text = nil
        likesButton.configuration?.title = nil
        viewsButtonOff.configuration?.title = nil
        isExpandedCell = false
        isSelectedLike = false
        likesButton.configuration?.baseBackgroundColor = .systemGray5
        likesButton.configuration?.baseForegroundColor = UIColor.customBaseForegroundButton
        likesButton.configuration?.image = UIImage(
            systemName: "suit.heart",
            withConfiguration: UIImage.SymbolConfiguration(pointSize: 14.0, weight: .bold, scale: .large))
    }

    // MARK: - Public Methods

    func clickedLikeSelectedCell() {
        likesButton.configuration?.baseBackgroundColor = UIColor.customBaseBackgroundButton
        likesButton.configuration?.baseForegroundColor = .systemRed
        likesButton.configuration?.title = "\(Int((likesButton.configuration?.title)!)! + 1)"
        likesButton.configuration?.image = UIImage(
            systemName: "heart.fill",
            withConfiguration: UIImage.SymbolConfiguration(pointSize: 14.0,
                                                           weight: .bold,
                                                           scale: .large))
        isSelectedLike = true
    }

    // MARK: - Private Methods

    private func setupView() {
        selectionStyle = .none
        backgroundColor = UIColor(named: "colorCellTableView")
        contentView.backgroundColor = UIColor.customBackgroundAppOne
        contentView.addSubview(separatorView)
        contentView.addSubview(borderView)
        borderView.addSubview(backView)
        backView.addSubview(authorLabel)
        backView.addSubview(pictureView)
        backView.addSubview(postStackView)
        postStackView.addArrangedSubview(descriptionTextView)
        postStackView.addArrangedSubview(likesAndViewsStackView)
        likesAndViewsStackView.addArrangedSubview(likesButton)
        likesAndViewsStackView.addArrangedSubview(viewsButtonOff)
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            separatorView.topAnchor.constraint(equalTo: contentView.topAnchor),
            separatorView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            separatorView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            separatorView.heightAnchor.constraint(equalToConstant: 10),

            borderView.topAnchor.constraint(equalTo: separatorView.bottomAnchor),
            borderView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            borderView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            borderView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),

            backView.topAnchor.constraint(equalTo: borderView.topAnchor, constant: 2.0),
            backView.leadingAnchor.constraint(equalTo: borderView.leadingAnchor),
            backView.trailingAnchor.constraint(equalTo: borderView.trailingAnchor),
            backView.bottomAnchor.constraint(equalTo: borderView.bottomAnchor, constant: -2.0),

            authorLabel.topAnchor.constraint(equalTo: backView.topAnchor, constant: 8),
            authorLabel.leadingAnchor.constraint(equalTo: backView.leadingAnchor, constant: 8),
            authorLabel.trailingAnchor.constraint(equalTo: backView.trailingAnchor, constant: -8),

            pictureView.topAnchor.constraint(equalTo: authorLabel.bottomAnchor, constant: 8),
            pictureView.leadingAnchor.constraint(equalTo: backView.leadingAnchor),
            pictureView.trailingAnchor.constraint(equalTo: backView.trailingAnchor),

            postStackView.topAnchor.constraint(equalTo: pictureView.bottomAnchor, constant: 8),
            postStackView.leadingAnchor.constraint(equalTo: backView.leadingAnchor, constant: 8),
            postStackView.trailingAnchor.constraint(equalTo: backView.trailingAnchor, constant: -8),
            postStackView.bottomAnchor.constraint(equalTo: backView.bottomAnchor, constant: -12)
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
            fullTextTextView = descriptionTextView.text!
            var changedText = (descriptionTextView.text! as NSString).substring(
                with: NSRange(location: 0, length: 160))
            changedText += "... Еще "
            descriptionTextView.text = changedText
            let attributes: [NSAttributedString.Key: NSObject] = [
                .foregroundColor: UIColor.label,
                .font: UIFont.systemFont(ofSize: 14.0)
            ]
            let attributedString = NSMutableAttributedString(string: changedText, attributes: attributes)
            attributedString.addAttribute(.link, value: "", range: NSRange(location: 160, length: 7))
            descriptionTextView.attributedText = attributedString
        }
    }

    // MARK: - Object Methods

    @objc private func handleTapGestureDescription(_ gestureRecognizer: UITapGestureRecognizer) {
        guard tapGestureDescriptionTextView === gestureRecognizer else { return }
        delegate?.didTapDescriptionTextView(cell: self)
    }

    @objc private func tapLikeButton(parameterSender: Any) {
        delegate?.didTapLikeButton(cell: self) { [weak self] in
            self?.isSelectedLike.toggle()
        }
    }

    @objc private func handleTapGesturePicture(_ gestureRecognizer: UITapGestureRecognizer) {
        guard tapGesturePictureImageView === gestureRecognizer else { return }
        delegate?.didTapPictureImageView(cell: self)
    }
}

// MARK: - Protocol Settable

extension PostTableViewCell: Settable {

    func setup(with viewModel: ViewModelProtocol) {
        guard let viewModel = viewModel as? ViewModel else { return }
        authorLabel.text = viewModel.author
        pictureView.image = UIImage(named: viewModel.image)
        likesButton.configuration?.title = "\(viewModel.likes)"
        viewsButtonOff.configuration?.title = "\(viewModel.views)"
        descriptionTextView.text = viewModel.description
        setupCutTextView()
    }
}
