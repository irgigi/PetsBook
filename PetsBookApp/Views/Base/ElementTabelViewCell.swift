//
//  ElementTabelViewCell.swift
//  PetsBookApp


import UIKit

class ElementTabelViewCell: UITableViewCell {
    
    lazy var infoLabel: UILabel = {
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
            infoLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            infoLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12),
           // infoLabel.widthAnchor.constraint(equalToConstant: 100),
          //  infoLabel.heightAnchor.constraint(equalToConstant: 50),
            
            arrowButton.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            arrowButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -24),
            arrowButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12),
           // arrowButton.widthAnchor.constraint(equalToConstant: 100),
           // arrowButton.heightAnchor.constraint(equalToConstant: 50)
        
        ])
    }
}
