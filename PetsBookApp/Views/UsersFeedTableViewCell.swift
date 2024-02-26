//
//  UsersFeedTableViewCell.swift
//  PetsBookApp


import UIKit

class UsersFeedTableViewCell: PostTableViewCell {
    
    lazy var newButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(systemName: "eyes"), for: .normal)
        return button
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addSubview(newButton)
        setupElement()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupElement() {
        NSLayoutConstraint.activate([
            newButton.topAnchor.constraint(equalTo: topAnchor, constant: 16),
            newButton.bottomAnchor.constraint(equalTo: imagePost.topAnchor, constant: 12),
            newButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            autorLabel.widthAnchor.constraint(equalTo: widthAnchor),
            autorLabel.heightAnchor.constraint(equalToConstant: 50),
        ])
    }
    
}
