//
//  RegViewController.swift
//  PetsBookApp


import UIKit
import FirebaseAuth



class RegViewController: UIViewController {
    
//MARK: - services
    
    private let authService = AuthService.shared
    
//MARK: - properties for authorization/registration
    
    var completionHandler: (() -> Bool)?
    var isNewUser: Bool?
    var user: ((FireBaseUser?) -> Void)?
    
    //for tabbar
    func sendNotification(withUser user: FireBaseUser) {
        let data: [String: Any] = ["user": user]
        NotificationCenter.default.post(name: .forTabbar, object: nil, userInfo: data)
    }
    
    // удаление наблюдателя
    deinit {
        NotificationCenter.default.removeObserver(self)
    }

//MARK: - subviews
    
    //для заголовка
    lazy var headTextLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 22, weight: .bold)
        label.textColor = Colors.myColor
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
        
    }()
    //описание
    lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = Fonts.baseTextFont
        label.textColor = Colors.myColor
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
        
    }()
    //картинка у первого поля
    lazy var onePawView: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(named: "paw1")
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    //картинка у второго поля
    lazy var secondPawView: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(named: "paw2")
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    //поле логина
    lazy var loginField: UITextField = {
        let text = UITextField()
        text.font = Fonts.baseTextFont
        text.placeholder = NSLocalizedString("email", comment: "")
        text.text = "test2@mail.ru"
        text.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: text.frame.height))
        text.leftViewMode = .always
        text.autocapitalizationType = .none
        text.keyboardType = .default
        text.returnKeyType = .done
        text.clearButtonMode = .whileEditing
        text.contentVerticalAlignment = .center
        text.layer.borderColor = Colors.secondaryColor.cgColor
        text.layer.borderWidth = 0.5
        text.layer.cornerRadius = 10
        text.tag = 0
        text.translatesAutoresizingMaskIntoConstraints = false
        return text
    }()
    //поле пароля
    lazy var passwordField: UITextField = {
        let text = UITextField()
        text.font = Fonts.baseTextFont
        text.placeholder = NSLocalizedString("password", comment: "")
        text.text = "123456"
        text.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: text.frame.height))
        text.leftViewMode = .always
        text.autocapitalizationType = .none
        text.keyboardType = .default
        text.returnKeyType = .done
        text.clearButtonMode = .whileEditing
        text.contentVerticalAlignment = .center
        text.isSecureTextEntry = true
        text.layer.borderColor = Colors.secondaryColor.cgColor
        text.layer.borderWidth = 0.5
        text.layer.cornerRadius = 10
        text.tag = 1
        text.translatesAutoresizingMaskIntoConstraints = false
        return text
    }()
    //кнопка регистрации или входа
    lazy var regButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = Colors.primaryColor
        button.layer.cornerRadius = 5
        button.addTarget(self, action: #selector(goToAccauntView), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
//MARK: - life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Colors.myColorLight
        
        if let comp = completionHandler {
            let isReg = comp()
            if isReg {
                headTextLabel.text = NSLocalizedString("REGISTRATION", comment: "")
                descriptionLabel.text = NSLocalizedString("Write your e-mail and create a password", comment: "")
                regButton.setTitle(NSLocalizedString("REGISTER", comment: ""), for: .normal)
                isNewUser = true
            } else {
                headTextLabel.text = NSLocalizedString("ENTRANCE", comment: "")
                descriptionLabel.text = NSLocalizedString("Enter your e-mail and password", comment: "")
                regButton.setTitle(NSLocalizedString("COME IN", comment: ""), for: .normal)
                isNewUser = false
            }
        }
        
        setupUI()
    }
    
//MARK: - methods
    
    @objc func goToAccauntView() {
        
        guard let login = loginField.text, let password = passwordField.text else { return }
        
        if let comp = completionHandler {
            if comp() {
                
                if !authService.isValidEmail(login) || !authService.isValidPassword(password) {
                    showAllert(message: NSLocalizedString("Error: email or password (at least 6 characters)", comment: ""))
                    return
                }
                
                authService.signUpUser(email: login, password: password) { [weak self] result in
                    switch result {
                    case .success(let user):
                        print("\(user) зарегистрирован")
                        self?.showProfileViewController(user: user)
                    case .failure:
                        self?.showAllert(message: NSLocalizedString("This user is already registered!", comment: ""))
                    }
                }
                
            } else {
                
                authService.loginUser(email: login, password: password) { [weak self] result in
                    
                    switch result {
                    case .success(let user):
                        print("\(user) загружен")
                        self?.showProfileViewController(user: user)
                    case .failure:
                        self?.showAllert(message: NSLocalizedString("This user not found!", comment: ""))
                    }
                }
            }
        }
    }
    
//MARK: - constraints
    
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
            descriptionLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -100),
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
    
    //для нового пользователя добавить имя
    
    func showProfileViewController(user: FireBaseUser) {
        
        self.user?(user)
        
        //for tabbar
        sendNotification(withUser: user)
        
        let profileVC = ProfileViewController(user: user)
 
        if let new = isNewUser {
            if new {
                
                let alertController = UIAlertController(title: NSLocalizedString("Enter pet's name", comment: ""), message: nil, preferredStyle: .alert)
                alertController.addTextField { textField in
                    textField.placeholder = "text"
                }
                
                let cancelAction = UIAlertAction(title: NSLocalizedString("Cancel", comment: ""), style: .cancel, handler: nil)
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


