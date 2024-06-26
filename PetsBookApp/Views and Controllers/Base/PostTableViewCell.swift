//
//  PostTableViewCell.swift
//  PetsBookApp
//

import UIKit


class PostTableViewCell: UITableViewCell {
    
 //MARK: - properties
    
    let profileTableHeaderView = ProfileTableHeaderView()
    let post = [Post]()
    let postService = PostService()
    
    var likeAction: (() -> Void)?
    
// MARK: - Subview
    
    lazy var autorLabel: UILabel = {
        let label = UILabel()
        label.textColor = Colors.secondaryColor
        label.font = Fonts.boldTextFont
        label.numberOfLines = 2
        return label
    }()
    
    lazy var imagePost: UIImageView = {
        let image = UIImageView()
        let screenWidth = UIScreen.main.bounds.width
        image.backgroundColor = Colors.almostWhite
        image.clipsToBounds = true
        image.contentMode = .scaleAspectFill
        image.layer.cornerRadius = 20
        image.layer.borderWidth = 1.0
        image.layer.borderColor = Colors.almostWhite.cgColor

        return image
    }()
    
    lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = Fonts.italicTextFont
        label.textColor = Colors.secondaryColor
        label.numberOfLines = 0
        return label
    }()
    
    lazy var likesLabel: UILabel = {
        let label = UILabel()
        label.textColor = Colors.secondaryColor
        label.font = Fonts.baseTextFont
        label.text = "0"
        return label
    }()
    
    lazy var likesButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "heart"), for: .normal)
        button.setImage(UIImage(systemName: "heart.fill"), for: .selected)
        button.addTarget(self, action: #selector(likeButtonTapped), for: .touchUpInside)
        return button
    }()

    lazy var stackForLabels: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .leading
        stackView.distribution = .fill
        stackView.spacing = 0
        
        return stackView
    }()
    
    
// MARK: - Lifecycle
    
    override init(
        style: UITableViewCell.CellStyle,
        reuseIdentifier: String?
    ) {
        super.init(
            style: .subtitle,
            reuseIdentifier: reuseIdentifier
        )

        stackForLabels.addArrangedSubview(likesButton)
        stackForLabels.addArrangedSubview(likesLabel)
        addSubviewInCell()
        consraintInCell()

    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        isHidden = false
        isSelected = false
        isHighlighted = false
    }
    
 
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        guard let view = selectedBackgroundView else {
            return
        }
        
        contentView.insertSubview(view, at: 0)
        selectedBackgroundView?.isHidden = !selected
    }
    
//MARK: - METHODS
    
    @objc func likeButtonTapped() {
        likeAction?()
    }

    
    func addSubviewInCell() {
       
        let subviews = [autorLabel, imagePost, stackForLabels, descriptionLabel]
        for subview in subviews {
            contentView.addSubview(subview)
        }
        
    }
    
    func updateLikes(newLikeCount: Int) {
        likesLabel.text = "\(newLikeCount)"
    }
    
    func update(_ model: Post) {
        autorLabel.text = model.userName
        
        postService.getPhotoFromURL(from: model.image) {[weak self] photo in
            DispatchQueue.main.async {
                self?.imagePost.image = photo
            }
        }
        
        descriptionLabel.text = model.descript
        
    }
//MARK: -constraints
    
    func consraintInCell() {
        
        autorLabel.translatesAutoresizingMaskIntoConstraints = false
        imagePost.translatesAutoresizingMaskIntoConstraints = false
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        likesLabel.translatesAutoresizingMaskIntoConstraints = false
        stackForLabels.translatesAutoresizingMaskIntoConstraints = false
        likesButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            
            autorLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            autorLabel.bottomAnchor.constraint(equalTo: imagePost.topAnchor, constant: -12),
            autorLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            autorLabel.widthAnchor.constraint(equalTo: contentView.widthAnchor),
            autorLabel.heightAnchor.constraint(equalToConstant: 50),
            
            imagePost.topAnchor.constraint(equalTo: autorLabel.bottomAnchor),
            imagePost.bottomAnchor.constraint(equalTo: descriptionLabel.topAnchor, constant: -30),
            imagePost.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            imagePost.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            imagePost.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            imagePost.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.width),
            imagePost.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width),
            
            descriptionLabel.topAnchor.constraint(equalTo: imagePost.bottomAnchor),
            descriptionLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            descriptionLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            descriptionLabel.bottomAnchor.constraint(equalTo: stackForLabels.topAnchor, constant: -10),
            
            stackForLabels.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor),
            stackForLabels.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            stackForLabels.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            stackForLabels.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            stackForLabels.heightAnchor.constraint(equalToConstant: 50),
            stackForLabels.widthAnchor.constraint(equalTo: contentView.widthAnchor),
            
            likesButton.topAnchor.constraint(equalTo: stackForLabels.topAnchor, constant: 10),
            likesButton.leadingAnchor.constraint(equalTo: stackForLabels.leadingAnchor, constant: 10),
            likesButton.trailingAnchor.constraint(equalTo: likesLabel.leadingAnchor, constant: -10),
            likesButton.bottomAnchor.constraint(equalTo: stackForLabels.bottomAnchor, constant: -10),
    
            likesLabel.topAnchor.constraint(equalTo: stackForLabels.topAnchor, constant: 10),
            likesLabel.leadingAnchor.constraint(equalTo: stackForLabels.leadingAnchor, constant: 40),
            likesLabel.widthAnchor.constraint(equalToConstant: 50),
            likesLabel.bottomAnchor.constraint(equalTo: stackForLabels.bottomAnchor, constant: -10)
        
        ])
        
    }
        
        
    
}
