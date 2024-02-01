//
//  RegViewController.swift
//  PetsBookApp


import UIKit

class RegViewController: UIViewController {
    
    lazy var headTextLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 22, weight: .bold)
        label.textColor = .systemBrown
        label.text = "РЕГИСТРАЦИЯ"
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
        
    }()
    
    lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        label.textColor = .systemBrown
        label.text = "Придумайте логин и пароль"
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
        
    }()
    
    lazy var onePawView: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(named: "paw1")
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    lazy var secondPawView: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(named: "paw2")
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    lazy var loginField: UITextField = {
        let text = UITextField()
        
        //text.backgroundColor = .systemGray6
        text.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        text.placeholder = "login"
        //text.text = "felix04"
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
        text.placeholder = "password"
        //text.text = "1507"
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
    
    lazy var regButton: UIButton = {
        let button = UIButton()
        button.setTitle("ЗАРЕГИСТРИРОВАТЬСЯ", for: .normal)
        button.backgroundColor = .systemBrown
        button.layer.cornerRadius = 5
        button.addTarget(self, action: #selector(goToAccauntView), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
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
    
    @objc func goToAccauntView() {
        
    }
    
    private func setupUI() {
        view.addSubview(headTextLabel)
        view.addSubview(loginField)
        view.addSubview(passwordField)
        view.addSubview(onePawView)
        view.addSubview(secondPawView)
        view.addSubview(descriptionLabel)
        view.addSubview(regButton)
        
        NSLayoutConstraint.activate([
            headTextLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            headTextLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 150),
            headTextLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            headTextLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),
            
            descriptionLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            descriptionLabel.topAnchor.constraint(equalTo: headTextLabel.bottomAnchor, constant: 100),
            descriptionLabel.widthAnchor.constraint(equalToConstant: 300),
            descriptionLabel.heightAnchor.constraint(equalToConstant: 50),
            
            loginField.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            loginField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50),
            loginField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -50),
            loginField.heightAnchor.constraint(equalToConstant: 50),
            
            
            passwordField.topAnchor.constraint(equalTo: loginField.bottomAnchor, constant: 50),
            passwordField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50),
            passwordField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -50),
            passwordField.heightAnchor.constraint(equalToConstant: 50),
            
            onePawView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50),
            onePawView.bottomAnchor.constraint(equalTo: loginField.topAnchor, constant: -10),
            onePawView.widthAnchor.constraint(equalToConstant: 30),
            onePawView.heightAnchor.constraint(equalToConstant: 30),
            

            secondPawView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50),
            secondPawView.bottomAnchor.constraint(equalTo: passwordField.topAnchor, constant: -10),
            secondPawView.widthAnchor.constraint(equalToConstant: 30),
            secondPawView.heightAnchor.constraint(equalToConstant: 30),
            
            regButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            regButton.topAnchor.constraint(equalTo: passwordField.bottomAnchor, constant: 50),
            regButton.widthAnchor.constraint(equalToConstant: 300),
            regButton.heightAnchor.constraint(equalToConstant: 50),
            
        ])
        
    }
}
