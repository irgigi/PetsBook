//
//  RegViewController.swift
//  PetsBookApp


import UIKit

class RegViewController: UIViewController {
    
    lazy var headTextLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        label.textColor = .systemBrown
        label.text = "ЗАРЕГИСТРИРОВАТЬСЯ"
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
        
    }()
    
    lazy var loginField: UITextField = {
        let text = UITextField()
        
        //text.backgroundColor = .systemGray6
        text.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        //text.placeholder = "login"
        text.text = "felix04"
        //text.textColor = UIColor.black
        //text.tintColor = UIColor(named: "MyColor")
        text.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: text.frame.height))
        text.leftViewMode = .always
        text.autocapitalizationType = .none
        text.keyboardType = .default
        text.returnKeyType = .done
        text.clearButtonMode = .whileEditing
        text.contentVerticalAlignment = .center
        text.layer.borderColor = UIColor.lightGray.cgColor
        text.layer.borderWidth = 0.5
        text.layer.cornerRadius = 10
        text.tag = 0
        text.translatesAutoresizingMaskIntoConstraints = false
        return text
    }()
    
    lazy var passwordField: UITextField = {
        let text = UITextField()
        //text.backgroundColor = .systemGray6
        text.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        //text.placeholder = "password"
        text.text = "1507"
        //text.textColor = UIColor.black
        //text.tintColor = UIColor(named: "MyColor")
        text.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: text.frame.height))
        text.leftViewMode = .always
        text.autocapitalizationType = .none
        text.keyboardType = .default
        text.returnKeyType = .done
        text.clearButtonMode = .whileEditing
        text.contentVerticalAlignment = .center
        text.isSecureTextEntry = true
        text.layer.borderColor = UIColor.lightGray.cgColor
        text.layer.borderWidth = 0.5
        text.layer.cornerRadius = 10
        text.tag = 1
        text.translatesAutoresizingMaskIntoConstraints = false
        return text
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if traitCollection.userInterfaceStyle == .dark {
            view.backgroundColor = .darkGray
        } else {
            view.backgroundColor = .white
        }
        setupUI()
    }
    
    private func setupUI() {
        view.addSubview(headTextLabel)
        view.addSubview(loginField)
        view.addSubview(passwordField)
        
        NSLayoutConstraint.activate([
            headTextLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            headTextLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 150),
            headTextLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 70),
            headTextLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -70),
            
            loginField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loginField.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            loginField.widthAnchor.constraint(equalToConstant: 300),
            loginField.heightAnchor.constraint(equalToConstant: 50)
            
            
        ])
        
    }
}
