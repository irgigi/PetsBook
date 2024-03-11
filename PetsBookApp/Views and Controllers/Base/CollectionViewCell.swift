//
//  CollectionViewCell.swift
//  PetsBookApp


import UIKit



class CollectionViewCell: UICollectionViewCell {
    
    
// MARK: - Subview
    
    lazy var userCollection: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleToFill
        image.clipsToBounds = true
        image.isUserInteractionEnabled = true
        image.layer.cornerRadius = 20
        image.layer.borderWidth = 5.0
        image.layer.borderColor = Colors.almostWhite.cgColor
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.font = Fonts.lightTextFont
        label.textColor = Colors.primaryColor
        label.numberOfLines = 0
        label.textAlignment = .center
        label.isUserInteractionEnabled = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
        
    }()
    
//MARK: - init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(userCollection)
        contentView.addSubview(nameLabel)
        constraint()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
//MARK: - methods
    
    func setupImage(_ data: UserAvatarAndName) {
        
        userCollection.image = data.ava
        nameLabel.text = data.user.userName
        
    }
    
  
    @objc func userTapped() {
        
    }

    
    func constraint() {
        NSLayoutConstraint.activate([
            
            nameLabel.topAnchor.constraint(equalTo: contentView.topAnchor),
            nameLabel.bottomAnchor.constraint(equalTo: userCollection.topAnchor, constant: -5),
            nameLabel.widthAnchor.constraint(equalTo: userCollection.widthAnchor),
            nameLabel.centerXAnchor.constraint(equalTo: userCollection.centerXAnchor),
            nameLabel.heightAnchor.constraint(equalToConstant: 10),
            
            userCollection.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: 12),
            userCollection.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            userCollection.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12),
            userCollection.widthAnchor.constraint(equalTo: contentView.widthAnchor),

        ])
    }
}

extension UIImage {
    func resize(to size: CGSize) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(size, false, 0.0)
        defer { UIGraphicsEndImageContext() }
        draw(in: CGRect(origin: .zero, size: size))
        return UIGraphicsGetImageFromCurrentImageContext()
    }
}
