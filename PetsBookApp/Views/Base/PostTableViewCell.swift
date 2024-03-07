//
//  PostTableViewCell.swift
//  PetsBookApp
//

import UIKit

class PostTableViewCell: UITableViewCell {
    
    let profileTableHeaderView = ProfileTableHeaderView()
    let post = [Post]()
    let postService = PostService()
    
    var likeAction: (() -> Void)?
    
    // MARK: -
    
    let autorLabel: UILabel = {
        let label = UILabel()
        label.textColor = Colors.primaryColor
        label.font = Fonts.boldTextFont
        label.numberOfLines = 2
        return label
    }()
    
    let imagePost: UIImageView = {
        let image = UIImageView()
        let screenWidth = UIScreen.main.bounds.width
        image.backgroundColor = Colors.almostWhite
        image.clipsToBounds = true
        image.contentMode = .scaleAspectFit
        image.layer.cornerRadius = 10
        image.layer.borderWidth = 1.0
        image.layer.borderColor = Colors.almostWhite.cgColor
      /*
        image.transform = CGAffineTransform(scaleX: UIScreen.main.bounds.width/image.bounds.width, y: UIScreen.main.bounds.width/image.bounds.width)
       */
        return image
    }()
    
    let descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = Fonts.italicTextFont
        label.textColor = Colors.myColor
        label.numberOfLines = 0
        return label
    }()
    
    let likesLabel: UILabel = {
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
    
    
    /*
    let viewsLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        label.text = "Likes: "
        return label
    }()
    */
    
    let stackForLabels: UIStackView = {
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
        
        
        //stackForLabels.addArrangedSubview(viewsLabel)
        stackForLabels.addArrangedSubview(likesButton)
        stackForLabels.addArrangedSubview(likesLabel)
        addSubviewInCell()
        
        consraintInCell()


      //  tuneView()
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
        print("tap cell")
        NotificationCenter.default.post(name: .liked, object: nil)
        likeAction?()
    }

    
    func addSubviewInCell() {
       
        let subviews = [autorLabel, imagePost, stackForLabels, descriptionLabel]
        for subview in subviews {
            contentView.addSubview(subview)
        }
        
    }
/*
    func update(_ model: PostModel) {
        
        autorLabel.text = model.author
        imagePost.image = UIImage(named: model.image)
        descriptionLabel.text = model.description
        likesLabel.text! += String(describing: model.likes)
        viewsLabel.text! += String(describing: model.views)
        
        }
  */
    
    func update(_ model: Post) {
        autorLabel.text = model.userName
        
        postService.getPhotoFromURL(from: model.image) {[weak self] photo in
            DispatchQueue.main.async {
                self?.imagePost.image = photo
            }
        }
        
        descriptionLabel.text = model.descript
        
    }
    
    func consraintInCell() {
        
        autorLabel.translatesAutoresizingMaskIntoConstraints = false
        imagePost.translatesAutoresizingMaskIntoConstraints = false
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        likesLabel.translatesAutoresizingMaskIntoConstraints = false
       // viewsLabel.translatesAutoresizingMaskIntoConstraints = false
        stackForLabels.translatesAutoresizingMaskIntoConstraints = false
        likesButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            
            autorLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            autorLabel.bottomAnchor.constraint(equalTo: imagePost.topAnchor, constant: -12),
            autorLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            autorLabel.widthAnchor.constraint(equalTo: contentView.widthAnchor),
            autorLabel.heightAnchor.constraint(equalToConstant: 50),
            
            imagePost.topAnchor.constraint(equalTo: autorLabel.bottomAnchor),
            imagePost.bottomAnchor.constraint(equalTo: descriptionLabel.topAnchor),
            imagePost.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            imagePost.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            imagePost.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            imagePost.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.width),
            imagePost.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width),
            
            descriptionLabel.topAnchor.constraint(equalTo: imagePost.bottomAnchor, constant: 30),
            descriptionLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            descriptionLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            descriptionLabel.bottomAnchor.constraint(equalTo: stackForLabels.topAnchor, constant: -10),
            
            stackForLabels.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor),
            stackForLabels.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            stackForLabels.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            //stackForLabels.centerXAnchor.constraint(equalTo: centerXAnchor),
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
