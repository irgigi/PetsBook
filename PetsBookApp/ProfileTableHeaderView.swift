//
//  ProfileTableHeaderView.swift
//  PetsBookApp

import UIKit

// MARK: - USER


class ProfileTableHeaderView: UITableViewHeaderFooterView {
    
    //static var userProfile: User2?
    private var statusText:String
    //private var inspector = LoginInspector()
    
    // MARK: - Subviews
    
    lazy var imageView: UIImageView = {
        let image = UIImageView()
        //image.image = UIImage(named: "none_ava")
        image.contentMode = .scaleToFill
        image.clipsToBounds = true
        image.isUserInteractionEnabled = true
        //создание круглой рамки
        image.layer.cornerRadius = 60
        image.layer.borderWidth = 3.0
        image.layer.borderColor = UIColor.white.cgColor
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped))
        image.addGestureRecognizer(tapGestureRecognizer)
        
        return image
    }()

    let nameLabel: UILabel = {
        let label = UILabel()
        //var user: User2?
        label.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        label.textColor = .black
        //label.text = userProfile?.name
        label.numberOfLines = 0
        
        return label
        
    }()

    let statusLabel: UILabel = {
        let label = UILabel()
        //var user: User2?
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        label.textColor = UIColor.gray
        //label.text = userProfile?.status
        
        return label
    }()
  
    lazy var textField: UITextField = {
        let text = UITextField()
        
        text.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        text.textColor = UIColor.black
        text.placeholder = " введите текст "
        text.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: text.frame.height))
        text.leftViewMode = .always
        text.layer.cornerRadius = 12
        text.layer.borderWidth = 1
        text.layer.borderColor = UIColor.black.cgColor
        text.layer.backgroundColor = UIColor.white.cgColor
        text.addTarget(self, action: #selector(statusTextChanged(_:)), for: .editingChanged)

        return text
    }()
    
    lazy var bigButton: UIButton = {
        let button = UIButton(
            frame: CGRect(
                x: 0,
                y: 0,
                width: 0,
                height: 0
            )
        )
        button.setTitle("Set status", for: .normal)
        button.backgroundColor = .systemBlue
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 5
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOpacity = 0.7
        button.layer.shadowOffset = CGSize(width: 4, height: 4)
        button.addTarget(self, action: #selector(buttonPressed(_:)), for: .touchUpInside)
    
        return(button)
    }()

    override init(reuseIdentifier: String?) {
        
        statusText = ""
        super.init(reuseIdentifier: reuseIdentifier)
       
        
        addSubviews()
        elementConstraint()
    
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func addSubviews() {
        
        addSubview(imageView)
        addSubview(bigButton)
        addSubview(textField)
        addSubview(statusLabel)
        addSubview(nameLabel)
    }
    
    @objc func statusTextChanged(_ textField: UITextField) {
        statusText = textField.text ?? ""
        
    }
    
    @objc func imageTapped(_ sender: UITapGestureRecognizer) {
        NotificationCenter.default.post(name: NSNotification.Name("ImageTapped"), object: nil)
    }
    
    func setImage(_ image: UIImage?) {
        imageView.image = image
        setNeedsLayout()
    }
    
    
    @objc func buttonPressed(_ sender: UIButton) {
       
        if let showText = textField.text {
            print(showText)
        }
        
        if statusText .isEmpty {
            statusLabel.text = statusLabel.text
        } else {
            statusLabel.text = statusText
        }
        
    }
    
    func elementConstraint() {
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        statusLabel.translatesAutoresizingMaskIntoConstraints = false
        textField.translatesAutoresizingMaskIntoConstraints = false
        bigButton.translatesAutoresizingMaskIntoConstraints = false
        
        
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
            
            bigButton.topAnchor.constraint(equalTo: textField.bottomAnchor),
            bigButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            bigButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            bigButton.heightAnchor.constraint(equalToConstant: 50)
            
        
        ])
        
    }
    
}
