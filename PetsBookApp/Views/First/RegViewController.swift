//
//  RegViewController.swift
//  PetsBookApp


import UIKit
import FirebaseAuth



class RegViewController: UIViewController {
    
    private let authService = AuthService()
    var completionHandler: (() -> Bool)?
    var isNewUser: Bool?
    var user: ((FireBaseUser?) -> Void)?
    
    func sendNotification(withUser user: FireBaseUser) {
        let data: [String: Any] = ["user": user]
        NotificationCenter.default.post(name: NSNotification.Name("NotificationName"), object: nil, userInfo: data)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    
    lazy var headTextLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 22, weight: .bold)
        label.textColor = .systemBrown
        //label.text = "РЕГИСТРАЦИЯ"
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
        
    }()
    
    lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        label.textColor = .systemBrown
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        //label.text = "Напишите ваш e-mail и придумайте пароль"
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
        text.placeholder = "email"
        text.text = "test@mail.ru"
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
        text.text = "123456"
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
        //button.setTitle("ЗАРЕГИСТРИРОВАТЬСЯ", for: .normal)
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
        if let comp = completionHandler {
            let isReg = comp()
            if isReg {
                headTextLabel.text = "РЕГИСТРАЦИЯ"
                descriptionLabel.text = "Напишите ваш e-mail и придумайте пароль"
                regButton.setTitle("ЗАРЕГИСТРИРОВАТЬСЯ", for: .normal)
                isNewUser = true
            } else {
                headTextLabel.text = "ВХОД"
                descriptionLabel.text = "Введите ваш e-mail и пароль"
                regButton.setTitle("ВОЙТИ", for: .normal)
                isNewUser = false
            }
        }
        
        setupUI()
    }
    
    @objc func goToAccauntView() {
        
        guard let login = loginField.text, let password = passwordField.text else {
            
            return
            
        }
        
        if let comp = completionHandler {
            if comp() {
                
                if !authService.isValidEmail(login) || !authService.isValidPassword(password) {
                    showAllert(message: "Ошибка ввода email или пароля (не менее 6 символов)")
                    return
                }
                
                authService.signUpUser(email: login, password: password) { [weak self] result in
                    switch result {
                    case .success(let user):
                        print("\(user) зарегистрирован")
                        self?.showProfileViewController(user: user)
                    case .failure:
                        self?.showAllert(message: "Этот пользователь уже зарегистрирован!")
                    }
                }
                
            } else {
                
                authService.loginUser(email: login, password: password) { [weak self] result in
                    
                    switch result {
                    case .success(let user):
                        print("\(user) загружен")
                        self?.showProfileViewController(user: user)
                    case .failure:
                        self?.showAllert(message: "Этот пользователь не найден!")
                    }
                }
                
            }
        }

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

private extension RegViewController {
    
    func showProfileViewController(user: FireBaseUser) {
        
        self.user?(user)
        
        sendNotification(withUser: user)
        
        let profileVC = ProfileViewController(user: user)
        /*
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene, let sceneDelegate = windowScene.delegate as? SceneDelegate {
            sceneDelegate.window?.rootViewController = tabBarController
        }
        
       
        guard let tabBarController = UIApplication.shared.windows.first?.rootViewController as? UITabBarController else { return }
        
        for vc in tabBarController.viewControllers ?? [] {
            if vc == profileVC {
                return
            } else {
                profileVC.tabBarItem = UITabBarItem()
                tabBarController.viewControllers?.append(profileVC)
            }
        }
        */
        if let new = isNewUser {
            if new {
                
                let alertController = UIAlertController(title: "Введите имя питомца", message: nil, preferredStyle: .alert)
                alertController.addTextField { textField in
                    textField.placeholder = "text"
                }
                
                let cancelAction = UIAlertAction(title: "Отмена", style: .cancel, handler: nil)
                let okAction = UIAlertAction(title: "OK", style: .default) { [weak self] _ in
                    if let textField = alertController.textFields?.first, let text = textField.text, !text.isEmpty {
                        profileVC.profileTableHeaderView.nameLabel.text = text
                        self?.navigationController?.pushViewController(profileVC, animated: true)
                    }
                }
                alertController.addAction(cancelAction)
                alertController.addAction(okAction)
                present(alertController, animated: true)
                
            } else {
                navigationController?.pushViewController(profileVC, animated: true)
            }
        }
    }
}


