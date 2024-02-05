//
//  PhotosCollectionViewCell.swift
//  PetsBookApp


import UIKit

class PhotosCollectionViewCell: UICollectionViewCell {

    
    lazy var profileImageView: UIImageView = {
        let imageView = UIImageView(frame: .zero)
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 6.0
        return imageView
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        
        self.backgroundColor = .white
        addSubview(profileImageView)
        setupConstraintsCollection()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
   /*
    func setup( with profile: Profile) {
        profileImageView.image = UIImage(named: profile.img)
    }
    
    */
    
    
    func setupConstraintsCollection() {
        profileImageView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            profileImageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            profileImageView.topAnchor.constraint(equalTo: topAnchor),
            profileImageView.trailingAnchor.constraint(equalTo: trailingAnchor),
            profileImageView.bottomAnchor.constraint(equalTo: bottomAnchor),
            profileImageView.centerXAnchor.constraint(equalTo: centerXAnchor)
        ])
    }
}

/*
extension UIImage {
    
    func resize(to size: CGSize) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(size, false, 0.0)
        defer { UIGraphicsEndImageContext() }
        draw(in: CGRect(origin: .zero, size: size))
        return UIGraphicsGetImageFromCurrentImageContext()
    }
}
*/
