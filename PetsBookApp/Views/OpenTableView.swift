//
//  OpenTableView.swift
//  PetsBookApp


import UIKit

class OpenTableView: ProfileTableHeaderView {
    
    
    lazy var button: UIButton = {
        let button = UIButton(type: .system)
        //button.setTitle("Добавить", for: .normal)
        button.setImage(UIImage(systemName: "bookmark"), for: .normal)
        button.setImage(UIImage(systemName: "bookmark.fill"), for: .highlighted)
        button.setImage(UIImage(systemName: "bookmark.fill"), for: .selected)
        button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        bigButton.isHidden = true
        bigButton2.isHidden = true
        textField.isHidden = true
        addSubview(button)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    @objc func buttonTapped() {
        
        NotificationCenter.default.post(name: .tapped, object: nil)
    
      /*
        if let result = isSelect {
            if result {
                print("nnn selected")
                NotificationCenter.default.post(name: .deleteButtonTapped, object: nil)
            } else {
                print("nnn unselected")
                NotificationCenter.default.post(name: .subscribeButtonTapped, object: nil)
            }
        }
      */
    }
    
    func setup() {
        NSLayoutConstraint.activate([
            button.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            button.topAnchor.constraint(equalTo: topAnchor, constant: 16),
            button.widthAnchor.constraint(equalToConstant: 50),
            button.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
}
