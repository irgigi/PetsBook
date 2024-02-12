//
//  ProfileViewController.swift
//  PetsBookApp


import UIKit
import Photos

class ProfileViewController: UIViewController {

    let profileTableHeaderView = ProfileTableHeaderView()
    let logoViewController = LogoViewController()
    private let firestoreService = FirestoreService()
    private let authService = AuthService()
    private let userService = UserService()
    private var userID: String?
    private var status: (() -> String)?
    private var statusText: String?
    
    private var aboutUser = [UserStatus]()
    
    enum CellReuseID: String {
        case base = "BaseTableViewCell_ReuseID"
        case custom = "CustomTableViewCell_ReuseID"
    }
    
    private enum HeaderFooterReuseID: String {
        case base = "TableSelectionFooterHeaderView_ReuseID"
    }
   
    // MARK: - Data
    
   // fileprivate let data = PostModel.make()
    private var userUID = [UserUID]()
    private var userStatus = [UserStatus]()
    
    
    // MARK: - table
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView.init(
            frame: .zero,
            style: .grouped
        )
       
        tableView.rowHeight = UITableView.automaticDimension
        
        tableView.register(
            PostTableViewCell.self,
            forCellReuseIdentifier: CellReuseID.base.rawValue
        )
        
        tableView.setAndLayout(headerView: profileTableHeaderView)
        
        tableView.register(
            PhotosTableViewCell.self,
            forCellReuseIdentifier: CellReuseID.custom.rawValue)
        
        tableView.register(
            ProfileTableHeaderView.self,
            forHeaderFooterViewReuseIdentifier: HeaderFooterReuseID.base.rawValue
        )
         
        tableView.delegate = self
        tableView.dataSource = self
        
        
        return tableView
    }()
    
//MARK: - инициализатор принимает юзера
    
    init(user: FireBaseUser) {
        super.init(nibName: nil, bundle: nil)
        userID = user.user.uid
        
        if let id = userID {
            
            userService.fetchAboutUser { [self] aboutUser in
                let info = aboutUser.contains { $0.user == id }
                if info {
                    initialFetch()
                    
                }
            }
            
            
            

            
    // переменная для хранения id user
           // let userSFB = UserUID(userUID: id)
            
    // если в бд есть пользователь, то загружаем его данные; если нет - то создаем данные в бд
            /*
            userService.fetchDocument { [weak self] users in
                for user in users {
                    if id == user.user {
                        print("load info")
                    } else {
                        let newUser = UserUID(userUID: id)
                        self?.userService.addUser(newUser) { info in
                            print("user DONE")
                        }
                    }
                }
            }
            */
            
            firestoreService.loadImage(eventID: id) { [weak self] image in
                self?.profileTableHeaderView.imageView.image = image
            }
        }
        profileTableHeaderView.nameLabel.text = user.user.email
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func initialFetchEvents() {
        userService.addObserverForEvents { [weak self] info in
            self?.reloadTableView(with: info)
        }
    }
    
    private func initialFetch() {
        userService.fetchAboutUser { [weak self] info in
            self?.reloadTableView(with: info)
        }
    }
    
    private func reloadTableView(with userStatus: [UserStatus]) {
        self.aboutUser = userStatus
        profileTableHeaderView.statusLabel.text = aboutUser.last?.status
        tableView.reloadData()
    }
    
    
//MARK: - life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        view.backgroundColor = .lightGray
        title = "Profile"

        NotificationCenter.default.addObserver(self, selector: #selector(imageTapped), name: NSNotification.Name("ImageTapped"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(addStatus), name: Notification.Name("statusTextChanged"), object: nil)
        
        tableView.addSubview(profileTableHeaderView)
        view.addSubview(tableView)
        //initialFetchEvents()
        setupConstraints()
        let exitButton = UIBarButtonItem(title: "Выход", style: .plain, target: self, action: #selector(exitButtonTapped))
        navigationItem.rightBarButtonItem = exitButton
        navigationItem.setHidesBackButton(true, animated: false)

    }
    
    @objc func addStatus(_ notification: Notification) {
        guard let statusText = notification.object as? String else { return }
        profileTableHeaderView.statusLabel.text = ""
        self.statusText = statusText
        print("st st st", statusText)
    }
    
    @objc func exitButtonTapped() {
        
        if let user = userID {
            if let status = statusText {
                let userStatus = UserStatus(user: user, status: status)
                userService.addAboutUser(userStatus) {_ in
                    print("status 3", userStatus)
                }
            }
        }

        profileTableHeaderView.statusSaved = { text in
            guard let text = text else { return }
            print("st st", text)
        }

        navigationController?.pushViewController(logoViewController, animated: true)
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupTabBar()
        loadViewIfNeeded()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        //navigationController?.setNavigationBarHidden(false, animated: animated)
        loadViewIfNeeded()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        loadViewIfNeeded()

    }
    
//MARK: -methods
    
    
    func setupTabBar() {
        tabBarController?.tabBar.isHidden = false
        tabBarController?.selectedIndex = 1
        if let item = tabBarController?.tabBar.items {
            item[1].isEnabled = false
        }
        
    }

    
    
    @objc func imageTapped() {
        presentImagePicker()
    }
    
    func presentImagePicker() {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: true)
    }
    

    //MARK: - вспомогательные методы
    
    func resizeImage(_ image: UIImage, targetSize: CGSize) -> UIImage {
        let render = UIGraphicsImageRenderer(size: targetSize)
        let resizedImage = render.image { (context) in
            image.draw(in: CGRect(origin: .zero, size: targetSize))
        }
        return resizedImage
    }
    
    
//MARK: - layout
    
    func setupConstraints() {
        let safeAreaGuide = view.safeAreaLayoutGuide
        profileTableHeaderView.translatesAutoresizingMaskIntoConstraints = false
        tableView.translatesAutoresizingMaskIntoConstraints = false

   
        NSLayoutConstraint.activate([
            
            tableView.topAnchor.constraint(equalTo: safeAreaGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: safeAreaGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: safeAreaGuide.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: safeAreaGuide.bottomAnchor),
            tableView.centerXAnchor.constraint(equalTo: safeAreaGuide.centerXAnchor),
            tableView.widthAnchor.constraint(equalTo: safeAreaGuide.widthAnchor)
            
        ])
        
    }
     
}
//MARK: - extensions

extension UITableView {
    
    func setAndLayout(headerView: UIView) {
        tableHeaderView = headerView
        headerView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            headerView.widthAnchor.constraint(equalTo: widthAnchor)
        ])
        
        headerView.setNeedsLayout()
        headerView.layoutIfNeeded()
        headerView.frame.size = headerView.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
    }
}

extension ProfileViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        } else {
            return 1 //data.count
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            
            guard let cell = tableView.dequeueReusableCell(
                withIdentifier: CellReuseID.custom.rawValue,
                for: indexPath
            ) as? PhotosTableViewCell else {
                fatalError("could not dequeueReusableCell")
            }
            //cell.update(data[indexPath.row])
            cell.contentView.frame.size.width = tableView.frame.width
            return cell
        } else {
            
            guard let cell = tableView.dequeueReusableCell(
                withIdentifier: CellReuseID.base.rawValue,
                for: indexPath
            ) as? PostTableViewCell else {
                fatalError("could not dequeueReusableCell")
            }
            //cell.update(data[indexPath.row])
            //cell.update(event[indexPath.row])
            return cell
            
        }
        
    }
    
    func tableView(
        _ tableView: UITableView,
        heightForHeaderInSection section: Int
    ) -> CGFloat {
        
        if section == 0 {
            
            return 250
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
    
        return 0
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForHeaderInSection section: Int) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 190
        } else {
            return UITableView.automaticDimension
        }
    }
    
    func tableView(
        _ tableView: UITableView,
        viewForHeaderInSection section: Int
    ) -> UIView? {
        
        if section == 0 {
            
            guard let headerView = tableView.dequeueReusableHeaderFooterView(
                withIdentifier: HeaderFooterReuseID.base.rawValue
            ) as? ProfileTableHeaderView else {
                fatalError("could not dequeueReusableCell")
            }
            headerView.isUserInteractionEnabled = true
            return headerView
            
        } else {
            
            return nil
            
        }
       
    }
    
    
}

extension ProfileViewController: UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let picImage = info[.originalImage] as? UIImage {
            profileTableHeaderView.setImage(picImage)
            if let id = userID {
                firestoreService.loadImage(eventID: id) { [weak self] image in
                    self?.profileTableHeaderView.imageView.image = image
                }
            }

            firestoreService.addImage(picImage) { error in
                if let error = error {
                    print(error.localizedDescription)
                } else {
                    print("DONE!")
                }
            }
            
        }
        picker.dismiss(animated: true)
    }
    
}

