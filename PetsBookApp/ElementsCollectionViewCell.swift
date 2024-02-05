//
//  ElementsCollectionViewCell.swift
//  PetsBookApp


import UIKit

class ElementsCollectionViewCell: UICollectionViewCell {
    
    let textLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        label.textColor = .black
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
        
    }()
    
    lazy var arrowButton: UIButton = {
        let button = UIButton(type: .system)
        button.tintColor = .black
        button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return(button)
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.addSubview(textLabel)
        contentView.addSubview(arrowButton)
        
        constraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func buttonTapped() {
        
        
        
    }
    
    func constraints() {
        NSLayoutConstraint.activate([
            
            textLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            textLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            textLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12),
            
            arrowButton.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            arrowButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -24),
            arrowButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12)
        
        ])
    }
}
