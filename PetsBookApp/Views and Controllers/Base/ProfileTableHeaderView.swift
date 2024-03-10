//
//  ProfileTableHeaderView.swift
//  PetsBookApp

import UIKit

// MARK: - delegate



class ProfileTableHeaderView: UITableViewHeaderFooterView {
    
//MARK: - properties
    
    var statusText: String?
    var nameText: String?
    
    //для установки статуса похоже лишнее
    //var statusSaved: ((String?) -> Void)?
    
    //для установки статуса
    var newStatus: String? {
        didSet {
            NotificationCenter.default.post(name: .statusTextChanged, object: newStatus)
        }
    }
    
    var newAva: UIImage? {
        didSet {
            NotificationCenter.default.post(name: Notification.Name("avaChanged"), object: newAva)
        }
    }
    
    var newName: String? {
        didSet {
            NotificationCenter.default.post(name: Notification.Name("nameChanged"), object: newName)
        }
    }
    
    //private var inspector = LoginInspector()
    
    // MARK: - Subviews
    
    lazy var imageView: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFill
        image.clipsToBounds = true
        image.isUserInteractionEnabled = true
        //создание круглой рамки
        image.layer.cornerRadius = 60
        image.layer.borderWidth = 2.0
        image.layer.borderColor = Colors.primaryColor.cgColor
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped))
        image.addGestureRecognizer(tapGestureRecognizer)
        
        return image
    }()

    lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        label.textColor = Colors.secondaryColor
        label.numberOfLines = 0
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(nameTapped))
        label.isUserInteractionEnabled = true
        label.addGestureRecognizer(tapGestureRecognizer)
        return label
        
    }()

    lazy var statusLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        label.textColor = Colors.myColor
        return label
    }()
  
    lazy var textField: UITextField = {
        let text = UITextField()
        text.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        text.textColor = Colors.primaryColor
        text.placeholder = NSLocalizedString(" enter text ", comment: "")
        text.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: text.frame.height))
        text.leftViewMode = .always
        text.layer.cornerRadius = 12
        text.layer.borderWidth = 1
        text.layer.borderColor = Colors.primaryColor.cgColor
        text.layer.backgroundColor = Colors.almostWhite.cgColor
        text.addTarget(self, action: #selector(statusTextChanged(_:)), for: .editingChanged)

        return text
    }()
    
    lazy var bigButton: UIButton = {
        let button = UIButton()
        button.setTitle(NSLocalizedString("set status", comment: ""), for: .normal)
        button.backgroundColor = Colors.primaryColor
        button.setTitleColor(Colors.almostWhite, for: .normal)
        button.layer.cornerRadius = 5
        button.layer.shadowColor = Colors.almostWhite.cgColor
        button.layer.shadowOpacity = 0.7
        button.layer.shadowOffset = CGSize(width: 4, height: 4)
        button.addTarget(self, action: #selector(buttonPressed(_:)), for: .touchUpInside)
        return(button)
    }()
    
    lazy var bigButton2: UIButton = {
        let button = UIButton()
        button.setTitle(NSLocalizedString("add post", comment: ""), for: .normal)
        button.backgroundColor = Colors.primaryColor
        button.setTitleColor(Colors.almostWhite, for: .normal)
        button.layer.cornerRadius = 5
        button.layer.shadowColor = Colors.almostWhite.cgColor
        button.layer.shadowOpacity = 0.7
        button.layer.shadowOffset = CGSize(width: 4, height: 4)
        button.addTarget(self, action: #selector(buttonPressed(_:)), for: .touchUpInside)
        return(button)
    }()
    
    


    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        backgroundColor = Colors.myColorLight
        addSubviews()
        elementConstraint()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
//MARK: - methods
    
    @objc func imageTapped(_ sender: UITapGestureRecognizer) {
        NotificationCenter.default.post(name: NSNotification.Name("ImageTapped"), object: nil)
    }
    
    
    @objc func nameTapped(_ sender: UITapGestureRecognizer) {
        NotificationCenter.default.post(name: NSNotification.Name("NameTapped"), object: nil)
    }
    
    @objc func statusTextChanged(_ textField: UITextField) {
        
        guard let text = textField.text else {
            print("no text")
            return
        }
        statusText = text
    }
    
    @objc private func buttonPressed(_ sender: UIButton) {
        switch sender {
        case bigButton:
            guard let st = statusText else { return }
            if st.isEmpty {
                return
            } else {
                statusLabel.text = st
                
                //передать статус
                newStatus = st
                
                //передать статус
                //statusSaved?(st)
                textField.text = ""
            }
        case bigButton2:
            NotificationCenter.default.post(name: .customButtonTapped, object: nil)
        default:
            return
        }
    }
    
    func setImage(_ image: UIImage?) {
        if let im = image {
            imageView.image = im
            newAva = im
        }
        setNeedsLayout()
    }
    

//MARK: -layout
    
    func addSubviews() {
        
        addSubview(imageView)
        addSubview(bigButton)
        addSubview(textField)
        addSubview(statusLabel)
        addSubview(nameLabel)
        addSubview(bigButton2)
    }
    
    func elementConstraint() {
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        statusLabel.translatesAutoresizingMaskIntoConstraints = false
        textField.translatesAutoresizingMaskIntoConstraints = false
        bigButton.translatesAutoresizingMaskIntoConstraints = false
        bigButton2.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([

            imageView.topAnchor.constraint(equalTo: topAnchor, constant: 16),
            imageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            imageView.widthAnchor.constraint(equalToConstant: 120),
            imageView.heightAnchor.constraint(equalToConstant: 120),
            imageView.trailingAnchor.constraint(equalTo: nameLabel.leadingAnchor, constant: -30),
            
            nameLabel.topAnchor.constraint(equalTo: topAnchor, constant: 27),
            nameLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 16),
            nameLabel.bottomAnchor.constraint(equalTo: statusLabel.topAnchor, constant: -20),
            nameLabel.leadingAnchor.constraint(equalTo: imageView.trailingAnchor),
            nameLabel.heightAnchor.constraint(equalToConstant: 30),
            
            statusLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor),
            statusLabel.leadingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: 30),
            statusLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            statusLabel.bottomAnchor.constraint(equalTo: textField.topAnchor, constant: -10),
            statusLabel.heightAnchor.constraint(equalToConstant: 20),
            
            textField.topAnchor.constraint(equalTo: statusLabel.bottomAnchor),
            textField.leadingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: 16),
            textField.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            textField.bottomAnchor.constraint(equalTo: bigButton.topAnchor, constant: -34),
            textField.widthAnchor.constraint(equalToConstant: 200),
            textField.heightAnchor.constraint(equalToConstant: 40),
            
            bigButton2.topAnchor.constraint(equalTo: topAnchor, constant: 180),
            bigButton2.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            bigButton2.trailingAnchor.constraint(equalTo: centerXAnchor, constant: -10),
            bigButton2.heightAnchor.constraint(equalToConstant: 50),

            bigButton.topAnchor.constraint(equalTo: topAnchor, constant: 180),
            bigButton.leadingAnchor.constraint(equalTo: centerXAnchor, constant: 10),
            bigButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            bigButton.heightAnchor.constraint(equalToConstant: 50),

        ])
        
    }
    
}
