//
//  ProfileViewController.swift
//  PetsBookApp


import UIKit
import Photos

class ProfileViewController: UIViewController {

    let profileTableHeaderView = ProfileTableHeaderView()
    let photoCollectionService = PhotoCollectionService.shared
    let photosCell = PhotosTableViewCell()
    
    let logoViewController = LogoViewController()
    private let firestoreService = FirestoreService()
    private let authService = AuthService()
    private let userService = UserService()
    private var userID: String?
    private var ava: UIImage?
    private var name: String?
    
    private var status: (() -> String)?
    private var statusText: String?
    
    private var aboutUser: UserStatus?
    private var userName: UserUID?
    
    enum CellReuseID: String {
        case base = "BaseTableViewCell_ReuseID"
        case custom = "CustomTableViewCell_ReuseID"
    }
    
    private enum HeaderFooterReuseID: String {
        case base = "TableSelectionFooterHeaderView_ReuseID"
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
   
    // MARK: - Data
    
   // fileprivate let data = PostModel.make()
    private var userUID = [UserUID]()
    private var userStatus = [UserStatus]()
    
    var images: [UIImage] = []
    
    
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
    
    func loadAvatar(_ user: String) {
        //загружаем аватар, если есть
        userService.fetchAvatar(user: user) { [weak self] (user, error) in
            if let error = error {
                print(error.localizedDescription)
            } else {
                if let us = user {
                    self?.userService.getAvaFromURL(from: us.avatar) { img in
                        if let image = img {
                            DispatchQueue.main.async {
                                self?.profileTableHeaderView.imageView.image = image
                                self?.ava = image
                                self?.tableView.reloadData()
                            }
                        }
                    }
                }
            }
        }
    }
    
    init(user: FireBaseUser) {
        super.init(nibName: nil, bundle: nil)
        
        forExit()
        
        userID = user.user.uid
        let userMail = user.user.email
        if let id = userID {

            loadAvatar(id)
            // загржаем статус, если есть
            userService.fetchStatus(user: id) {[weak self] (user, error) in
                if let error = error {
                    print(error.localizedDescription)
                } else {
                    if let us = user {
                        self?.reloadTableView(with: us)
                    } else {
                        print("not found status")
                    }
                }
                
            }
            
            // загружаем имя или мейл
            userService.fetchName(user: id) { [weak self] (user, error) in
                if let error = error {
                    print(error.localizedDescription)
                } else {
                    if let us = user {
                        if let n = us.userName {
                            self?.profileTableHeaderView.nameLabel.text = n
                            print("?", n)
                            self?.tableView.reloadData()
                        }
                    } else {
                        self?.profileTableHeaderView.nameLabel.text = userMail
                        print("not found name")
                    }
                }
            }
            
            /*
            userService.fetchAboutUser { [self] aboutUser in
                let info = aboutUser.contains { $0.user == id }
                if info {
                    initialFetch()
                    
                }
            }
            
            */
            

            
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
            
  //          firestoreService.loadImage(eventID: id) { [weak self] image in
  //              self?.profileTableHeaderView.imageView.image = image
  //          }
        }
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    /*
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
     */
    private func reloadTableView(with userStatus: UserStatus) {
        self.aboutUser = userStatus
        if let st = userStatus.status {
            profileTableHeaderView.statusLabel.text = st
        }
        tableView.reloadData()
    }
    
    private func reloadTableView2(with userName: UserUID) {
        self.userName = userName
        if let us = userName.userName {
            profileTableHeaderView.nameLabel.text = us
        }
        tableView.reloadData()
    }
    
    
    
//MARK: - life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        view.backgroundColor = .lightGray
        title = "Profile"
        loadSavedPhoto()

        NotificationCenter.default.addObserver(self, selector: #selector(imageTapped), name: NSNotification.Name("ImageTapped"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(addStatus), name: Notification.Name("statusTextChanged"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(addName), name: Notification.Name("NameTapped"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(addAvatar), name: Notification.Name("avaChanged"), object: nil)
        
        tableView.addSubview(profileTableHeaderView)
        view.addSubview(tableView)
        //initialFetchEvents()
        setupConstraints()

    }
    
    func forExit() {
        
        let exitButton = UIBarButtonItem(title: "Выход", style: .plain, target: self, action: #selector(exitButtonTapped))
        navigationItem.rightBarButtonItem = exitButton
        navigationItem.rightBarButtonItem?.isHidden = false
        navigationItem.setHidesBackButton(true, animated: false)
    }
    
    func loadSavedPhoto() {
        images = photoCollectionService.loadSavedPhoto()
        tableView.reloadData()
    }
    
    @objc func addStatus(_ notification: Notification) {
        guard let statusText = notification.object as? String else { return }
        profileTableHeaderView.statusLabel.text = ""
        self.statusText = statusText
    }
    
    @objc func addName(_ notification: Notification) {
        showAddName { [weak self] name in
            self?.profileTableHeaderView.nameLabel.text = name
            self?.name = name
        }
        guard let nameText = notification.object as? String else { return }
        self.name = nameText
        
    }
    
    
    @objc func addAvatar(_ notification: Notification) {
        guard let newAva = notification.object as? UIImage else { return }
        ava = newAva
    }
    
    @objc func exitButtonTapped() {
        
        addAva(ava)

        if let user = userID {
            if let status = statusText {
                
                let userStatus = UserStatus(user: user, status: status)
                userService.checkStatus(user: user) { [self] (isDoc, error) in
                    if let error = error {
                        print(error.localizedDescription)
                    } else {
                        if isDoc {
                            userService.updateStatus(user, status)
                        } else {
                            print("not document")
                            userService.addAboutUser(userStatus) {_ in
                            }
                        }
                    }
                }

            }
            
            if let naming = name {
                
                let userName = UserUID(user: user, userName: naming)
                userService.checkName(user: user) { [self] (isDoc, error) in
                    if let error = error {
                        print(error.localizedDescription)
                    } else {
                        if isDoc {
                            userService.updateName(user, naming)
                        } else {
                            print("not document")
                            userService.addUser(userName) {_ in
                            }
                        }
                    }
                }
            }

        }

        profileTableHeaderView.statusSaved = { [self] text in
            guard let text = text else { return }
            name = text
        }

        navigationController?.pushViewController(logoViewController, animated: true)
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupTabBar()
        forExit()
        loadViewIfNeeded()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        forExit()
        //navigationController?.setNavigationBarHidden(false, animated: animated)
        loadViewIfNeeded()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        forExit()
        loadViewIfNeeded()

    }
    
//MARK: -methods
    
    
    func setupTabBar() {
        tabBarController?.tabBar.isHidden = false
        
        //if let selectedVC = tabBarController?.selectedViewController {
        //    print("tabbar done")
       // }
        //tabBarController?.selectedIndex = 1

        //if let item = tabBarController?.tabBar.items {
        //    item[2].isEnabled = false
        //}
        
    }
    
    
    @objc func imageTapped() {
        presentImagePicker()
        ava = profileTableHeaderView.imageView.image
    }
    
    func addAva(_ image: UIImage?) {
        if let im = image {
            if let user = userID {
                userService.saveAvatar(user, im) { [weak self] result in
                    switch result {
                    case .success(let avaString):
                        let userAva = UserAvatar(user: user, avatar: avaString)
                        self?.userService.addUserAvatar(userAva) { userAva in
                            print("AVA saved")
                        }
                    case .failure(let error):
                        print(error)
                    }
                }
            }
        }
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

        }
        picker.dismiss(animated: true)
    }
    
}



