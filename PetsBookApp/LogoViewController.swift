//
//  LogoViewController.swift
//  PetsBookApp


import UIKit

class LogoViewController: UIViewController {
    
    lazy var logoView: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()

    
    lazy var regButton: UIButton = {
        let button = UIButton()
        button.setTitle("ЗАРЕГИСТРИРОВАТЬСЯ", for: .normal)
        button.backgroundColor = .systemBrown
        button.layer.cornerRadius = 5
        button.addTarget(self, action: #selector(goToRegView), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    lazy var textButton: UIButton = {
        let button = UIButton()
        button.setTitle("Уже есть аккаунт", for: .normal)
        button.setTitleColor(.systemBrown, for: .normal)
        button.addTarget(self, action: #selector(goToLogView), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
       
        if traitCollection.userInterfaceStyle == .dark {
            view.backgroundColor = .darkGray
            if let thisImage = UIImage(named: "petsbook_dark") {
                logoView.image = thisImage
            }
        } else {
            view.backgroundColor = .white
            if let thisImage = UIImage(named: "petsbook_light") {
                logoView.image = thisImage
            }
        }
        setupUI()
    }
    
    @objc func goToRegView() {
        let regViewController = RegViewController()
        regViewController.completionHandler = {
            return true
        }
        navigationController?.navigationBar.tintColor = .systemBrown
        navigationController?.pushViewController(regViewController, animated: true)
    }
    
    @objc func goToLogView() {
        let regViewController = RegViewController()
        regViewController.completionHandler = {
            return false
        }
        navigationController?.navigationBar.tintColor = .systemBrown
        navigationController?.pushViewController(regViewController, animated: true)
    }
    
    private func setupUI() {
        view.addSubview(logoView)
        view.addSubview(regButton)
        view.addSubview(textButton)
        
        NSLayoutConstraint.activate([
            logoView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            logoView.topAnchor.constraint(equalTo: view.topAnchor, constant: 100),
            logoView.widthAnchor.constraint(equalToConstant: 350),
            logoView.heightAnchor.constraint(equalToConstant: 400),
            
            regButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            regButton.topAnchor.constraint(equalTo: logoView.bottomAnchor, constant: 50),
            regButton.widthAnchor.constraint(equalToConstant: 300),
            regButton.heightAnchor.constraint(equalToConstant: 50),
            
            textButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            textButton.topAnchor.constraint(equalTo: regButton.bottomAnchor, constant: 30),
            textButton.widthAnchor.constraint(equalToConstant: 200),
            textButton.heightAnchor.constraint(equalToConstant: 50)
        ])
        
    }


}

