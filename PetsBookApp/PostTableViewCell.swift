//
//  PostTableViewCell.swift
//  PetsBookApp
//

import UIKit

class PostTableViewCell: UITableViewCell {
    
    let profileTableHeaderView = ProfileTableHeaderView()
    
    
    
    // MARK: -
    
    let autorLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        label.numberOfLines = 2
        return label
    }()
    
    let imagePost: UIImageView = {
        let image = UIImageView()
        let screenWidth = UIScreen.main.bounds.width
        image.backgroundColor = .black
        image.clipsToBounds = true
        image.contentMode = .scaleAspectFill
      /*
        image.transform = CGAffineTransform(scaleX: UIScreen.main.bounds.width/image.bounds.width, y: UIScreen.main.bounds.width/image.bounds.width)
       */
        return image
    }()
    
    let descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        label.textColor = .systemGray
        label.numberOfLines = 0
        return label
    }()
    
    let likesLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        label.text = "Views: "
        return label
    }()
    
    let viewsLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        label.text = "Likes: "
        return label
    }()
    
    let stackForLabels: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        stackView.spacing = 250
        
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
        
        stackForLabels.addArrangedSubview(likesLabel)
        stackForLabels.addArrangedSubview(viewsLabel)
     
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
    
    func addSubviewInCell() {
        
        let subviews = [autorLabel, imagePost, stackForLabels, descriptionLabel]
        for subview in subviews {
            addSubview(subview)
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
    func consraintInCell() {
        
        autorLabel.translatesAutoresizingMaskIntoConstraints = false
        imagePost.translatesAutoresizingMaskIntoConstraints = false
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        likesLabel.translatesAutoresizingMaskIntoConstraints = false
        viewsLabel.translatesAutoresizingMaskIntoConstraints = false
        stackForLabels.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            
            autorLabel.topAnchor.constraint(equalTo: topAnchor, constant: 16),
            autorLabel.bottomAnchor.constraint(equalTo: imagePost.topAnchor, constant: 12),
            autorLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            autorLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            autorLabel.widthAnchor.constraint(equalTo: widthAnchor),
            autorLabel.heightAnchor.constraint(equalToConstant: 50),
            
            imagePost.topAnchor.constraint(equalTo: autorLabel.bottomAnchor),
            imagePost.bottomAnchor.constraint(equalTo: descriptionLabel.topAnchor),
            imagePost.leadingAnchor.constraint(equalTo: leadingAnchor),
            imagePost.centerXAnchor.constraint(equalTo: centerXAnchor),
            imagePost.trailingAnchor.constraint(equalTo: trailingAnchor),
            imagePost.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.width),
            imagePost.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width),
            
            descriptionLabel.topAnchor.constraint(equalTo: imagePost.bottomAnchor, constant: -16),
            descriptionLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            descriptionLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            descriptionLabel.bottomAnchor.constraint(equalTo: stackForLabels.topAnchor),
            
            stackForLabels.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: -16),
            stackForLabels.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            stackForLabels.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            stackForLabels.centerXAnchor.constraint(equalTo: centerXAnchor),
            stackForLabels.bottomAnchor.constraint(equalTo: bottomAnchor),
            stackForLabels.widthAnchor.constraint(equalTo: widthAnchor),
    
            likesLabel.topAnchor.constraint(equalTo: stackForLabels.topAnchor),
            likesLabel.leadingAnchor.constraint(equalTo: stackForLabels.leadingAnchor),
            likesLabel.leftAnchor.constraint(equalTo: leftAnchor),
            likesLabel.bottomAnchor.constraint(equalTo: stackForLabels.bottomAnchor),
        
            viewsLabel.topAnchor.constraint(equalTo: stackForLabels.topAnchor),
            viewsLabel.trailingAnchor.constraint(equalTo: stackForLabels.trailingAnchor),
            viewsLabel.rightAnchor.constraint(equalTo: rightAnchor),
            viewsLabel.bottomAnchor.constraint(equalTo: stackForLabels.bottomAnchor)
      
        ])
        
    }
        
        
    
}
