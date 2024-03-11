//
//  ElementTabelViewCell.swift
//  PetsBookApp


import UIKit

class ElementTabelViewCell: UITableViewCell {
    
//MARK: - Subview
    
    lazy var infoLabel: UILabel = {
        let label = UILabel()
        label.font = Fonts.boldTextFont
        label.textColor = Colors.myColor
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
        
    }()
    
    lazy var arrowButton: UIButton = {
        let button = UIButton(type: .system)
        button.tintColor = Colors.myColor
        button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return(button)
    }()
    
//MARK: - init
    
    override init(
        style: UITableViewCell.CellStyle,
        reuseIdentifier: String?
    ) {
        super.init(
            style: .default,
            reuseIdentifier: reuseIdentifier
        )
        
        contentView.addSubview(infoLabel)
        contentView.addSubview(arrowButton)
        
        constraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
//MARK: - methods
    
    @objc func buttonTapped() {
        let controller = PhotosViewController()
        var responder: UIResponder? = self
        while responder != nil {
            responder = responder?.next
            if let viewController = responder as? UIViewController {
                viewController.navigationController?.pushViewController(controller, animated: true)
            }
        }
    }
    
    func constraints() {
        NSLayoutConstraint.activate([
            
            infoLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            infoLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            infoLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12),
            
            arrowButton.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            arrowButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -24),
            arrowButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12)
        
        ])
    }
}
