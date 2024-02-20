//
//  CollectionViewCell.swift
//  PetsBookApp


import UIKit

class CollectionViewCell: UICollectionViewCell {
    
    

    
    let imageCollection: UIImageView = {
        let image = UIImageView(frame: .zero)
        let screenWidth = UIScreen.main.bounds.width
        image.backgroundColor = .black
        image.clipsToBounds = true
        image.layer.cornerRadius = 6.0
        image.contentMode = .scaleAspectFill
        image.translatesAutoresizingMaskIntoConstraints = false

       
        return image
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(imageCollection)
        constraint()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
  /*
    func setupImage(_ model: PostModel) {
        
        imageCollection.image = UIImage(named: model.image)
        
        }
  */
    
    func setupImage(_ image: UIImage) {
        
        imageCollection.image = image
        
    }
    

    
    func constraint() {
        NSLayoutConstraint.activate([
            
            imageCollection.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageCollection.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: 12),
            imageCollection.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageCollection.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12),
            imageCollection.widthAnchor.constraint(equalTo: contentView.widthAnchor),
            imageCollection.heightAnchor.constraint(equalTo: contentView.widthAnchor)
            
        
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
