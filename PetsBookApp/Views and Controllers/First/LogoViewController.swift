//
//  LogoViewController.swift
//  PetsBookApp


import UIKit

class LogoViewController: UIViewController {
    
//MARK: - subviews
    
    lazy var logoView: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()

    
    lazy var regButton: UIButton = {
        let button = UIButton()
        button.setTitle(NSLocalizedString("REGISTER", comment: ""), for: .normal)
        button.backgroundColor = Colors.primaryColor
        button.layer.cornerRadius = 5
        button.addTarget(self, action: #selector(goToRegView), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    lazy var textButton: UIButton = {
        let button = UIButton()
        button.setTitle(NSLocalizedString("HAVE ACCOUNT", comment: ""), for: .normal)
        button.setTitleColor(Colors.primaryColor, for: .normal)
        button.addTarget(self, action: #selector(goToLogView), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

//MARK: - life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tabBarController?.tabBar.isHidden = true
    
        if let thisImage = UIImage(named: "petsbook") {
            logoView.image = thisImage
            view.backgroundColor = Colors.myColorLight
        }
        
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = true
        navigationItem.setHidesBackButton(true, animated: false)
    }
    
//MARK: - methods
    
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
    
//MARK: - constraints
    
    private func setupUI() {
        view.addSubview(logoView)
        view.addSubview(regButton)
        view.addSubview(textButton)
        
        NSLayoutConstraint.activate([
            logoView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            logoView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -100),
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

