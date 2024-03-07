//
//  ProfileViewController.swift
//  PetsBookApp


import UIKit
import Photos



class ProfileViewController: UIViewController {

    let profileTableHeaderView = ProfileTableHeaderView()
    let photoCollectionService = PhotoCollectionService.shared
    var photosCell = PhotosTableViewCell()
    var postCell = PostTableViewCell()
    
    let logoViewController = LogoViewController()
    let usersFeedController = UsersFeedController()
    
    private let firestoreService = FirestoreService()
    private let authService = AuthService.shared
    private let userService = UserService()
    private let postService = PostService()
    private let subscribeService = SubscribeService.shared
    private let likeService = LikeService()
    
    
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
        case info = "ElementViewCell_ReuseID"
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
    private var post = [Post]()
    private var subscribers = [UserAvatarAndName]() {
        didSet {
            tableView.reloadData()
        }
    }
    
    var images: [UIImage] = []
    
    
    var subscribeUsers: [UIImage] = [] {
        didSet {
            tableView.reloadData()
        }
    }
    
    var names: [UserUID] = [] {
        didSet {
            tableView.reloadData()
        }
    }

    var selUser: UserUID?
    

    var likeItem: String?
    
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
        tableView.backgroundColor = Colors.almostWhite
        tableView.separatorStyle = .singleLine
        tableView.separatorColor = Colors.myColor
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        tableView.setAndLayout(headerView: profileTableHeaderView)
        
        tableView.register(
            PhotosTableViewCell.self,
            forCellReuseIdentifier: CellReuseID.custom.rawValue)
        
        tableView.register(
            ElementTabelViewCell.self,
            forCellReuseIdentifier: CellReuseID.info.rawValue)
        
        tableView.register(
            ProfileTableHeaderView.self,
            forHeaderFooterViewReuseIdentifier: HeaderFooterReuseID.base.rawValue
        )
         
        tableView.delegate = self
        tableView.dataSource = self
        
        
        return tableView
    }()
    

 //MARK: - загрузка данных
    
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
                            }
                        }
                    }
                }
            }
        }
    }
    
    func loadPost(_ user: String) {
        postService.getPost(user) { [weak self] allPosts in
            DispatchQueue.main.async {
                self?.post = []
                self?.post.append(contentsOf: allPosts)
                self?.tableView.reloadData()
            }
        }
    }
    
    func loadSubscribeUsers(_ user: String) {
        subscribers = []
        subscribeService.getAddedUsers(user) { [self] array in
         
            for item in array {
                /*
                self.userService.getAvatarAndName(forUser: item.user) { (avatar: String?, name: String?) in
                    
                    guard let urlAva = avatar else { return }
                    guard let name = name else { return }
                    self.userService.getAvaFromURL(from: urlAva) { [weak self] image in
                        DispatchQueue.main.async { [weak self] in
                            if let image = image {
                                var data = UserAvatarAndName(ava: image, name: name)
                                self?.data.append(data)
                                self?.tableView.reloadData()
                            }
                        }
                    }
                }
                
                */
                self.userService.getListenerhAvatar(user: item.addUser) { userAva, error in
                    if let error = error {
                        print(error.localizedDescription)
                    } else {
                        guard let addedUser = userAva?.avatar else { return }
                        
                        self.userService.fetchName(user: item.addUser) { [weak self] userName, error in
                            if let error = error {
                                print(error.localizedDescription)
                            } else {
                                guard let name = userName?.userName else { return }
                                guard let selectUser = userName?.user else { return }
                                //self?.names.append(name)
                                //self?.tableView.reloadData()
                                //guard let urlAva = userAva else { return }
                                self?.userService.getAvaFromURL(from: addedUser) { [weak self] image in
                                    DispatchQueue.main.async { [weak self] in
                                        if let image = image {
                                            //self?.subscribeUsers.append(image)
                                            //guard let id = userName?.user else { return }
                                            let userInfo = UserUID(user: selectUser, userName: name)
                                            let info = UserAvatarAndName(user: userInfo, ava: image)
                                            self?.subscribers.append(info)
                                            self?.tableView.reloadData()
                                        }
                                    }
                                }
                            }
                        }

                    }
                }
                
            }
        }
    }
    
//MARK: - инициализатор принимает юзера
    
    init(user: FireBaseUser) {
        super.init(nibName: nil, bundle: nil)

        forExit()
        
        userID = user.user.uid
        
        let userMail = user.user.email
        if let id = userID {
            
            //для других взаимодействий

            authService.getUser(id)
             
            loadAvatar(id)
            loadPost(id)
            //loadSubscribeUsers(id)
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
                    if let user = user {
                        if let name = user.userName {
                            self?.profileTableHeaderView.nameLabel.text = name
                            self?.tableView.reloadData()
                        }
                    } else {
                        self?.profileTableHeaderView.nameLabel.text = userMail
                        print("not found name")
                    }
                }
            }
            
        }
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

 /*
    private func reloadTableView2(with userName: UserUID) {
        self.userName = userName
        if let us = userName.userName {
            profileTableHeaderView.nameLabel.text = us
        }
        tableView.reloadData()
    }
    
    */
    
//MARK: - life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        view.backgroundColor = Colors.myColorLight
        title = NSLocalizedString("PROFILE", comment: "")
        let titleColor = [
            NSAttributedString.Key.foregroundColor: Colors.myColor
        ]
        self.navigationController?.navigationBar.titleTextAttributes = titleColor as [NSAttributedString.Key : Any]
        //NotificationCenter.default.addObserver(self, selector: #selector(subscribeButtonTapped), name: .subscribeButtonTapped, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(unSubscribeButtonTapped), name: .unSubscribeButtonTapped, object: nil)
        
        //NotificationCenter.default.addObserver(self, selector: #selector(deleteButtonTapped), name: .deleteButtonTapped, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(likeButtonTapped), name: .liked, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(buttonTap), name: .customButtonTapped, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(imageTapped), name: .imageTapped, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(addStatus), name: Notification.Name("statusTextChanged"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(addName), name: Notification.Name("NameTapped"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(addAvatar), name: Notification.Name("avaChanged"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(dismissedVC), name: .dissmissedVC, object: nil)
        
        tableView.addSubview(profileTableHeaderView)
        view.addSubview(tableView)
        //initialFetchEvents()
        setupConstraints()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupTabBar()
        loadSavedPhoto()
        guard let user = userID else { return }
        loadSubscribeUsers(user)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        //navigationController?.setNavigationBarHidden(false, animated: animated)
        tableView.reloadData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        tableView.reloadData()
    }
    
//MARK: -METHODS
    
    
    private func reloadTableView(with userStatus: UserStatus) {
        self.aboutUser = userStatus
        if let st = userStatus.status {
            profileTableHeaderView.statusLabel.text = st
        }
        tableView.reloadData()
    }
    
    
    @objc func likeButtonTapped(_ notification: Notification) {
        print("tap here")
        tableView.reloadData()
    }
   
    func buttonTapped(at indexPath: IndexPath) {
        print("tap here2")
        
        likeItem = post[indexPath.row].postID
        guard let idPost = likeItem else { return }
    
        if let id = userID {
            
            likeService.checkLike(idPost, id) { [weak self] result in
                if result {
                    self?.likeService.unlikepost(idPost, id) { [weak self] error in
                        if let error = error {
                            print(error.localizedDescription)
                        }
                        print("... unliked!")
                        self?.postCell.likesButton.isSelected = true
                        self?.tableView.reloadData()
                    }
                } else {
                    self?.likeService.addLike(idPost, id) { [weak self] error in
                        if let error = error {
                            print(error.localizedDescription)
                        } else {
                            print("... liked!")
                            self?.postCell.likesButton.isSelected = true
                            self?.tableView.reloadData()
                        }
                        
                    }
                }
            }
          

            /*
            likeService.countLikes(forPostID: idPost) { [weak self] count in
                self?.postCell.likesLabel.text = String(count)
                self?.tableView.reloadData()
            }
             */
        }
    }


    /*
    //отслеживание подписки на пользователя
    @objc private func subscribeButtonTapped(_ notification: Notification) {
        if let id = userID {
            guard let user = subscribeService.value else { return }
            let subscibe = Subscribe(user: id, addUser: user)
            let openVC = OpenViewController(user: user)
            subscribeService.checkSubscribe(id, addUser: user) { [weak self] result, error in
                if let error = error {
                    print(error)
                }
                if !result {
                    
                    if id == user {
                        self?.showAllert(message: "На себя подписаться нельзя!")
                    } else {
                        self?.subscribeService.addUserToUser(subscibe) { [weak self] error, result  in
                            if let error = error {
                                print(error)
                            }
                            print("nnn subscribe done")
                            if (result != nil) {
                                openVC.openTableHeaderView.button.isSelected = true
                                self?.tableView.reloadData()
                            }
                            
                        }
                    }
                    
                }
            }
            
        }
    }
     
  */
    
    @objc private func dismissedVC(_ notification: Notification) {
        viewWillAppear(true)
    }
    
    @objc private func unSubscribeButtonTapped(_ notification: Notification) {
        if let newValue = notification.object as? UserUID {
            let openVC = OpenViewController(user: newValue.user)
            if let id = userID {
                subscribeService.checkSubscribe(id, addUser: newValue.user) { [self] result, error in
                    if let error = error {
                        print(error)
                    }
                    if result {
                        openVC.updateData = { [weak self] in
                            self?.tableView.reloadData()
                        }
                    }
                }
            }
            present(openVC, animated: true)
        }
    }
    /*
    @objc private func deleteButtonTapped(_ notification: Notification) {
        if let id = userID {
            print("nnn 1")
            guard let user = subscribeService.value else { return }
            let subscibe = Subscribe(user: id, addUser: user)
            print("nnn 2")
            subscribeService.checkSubscribe(id, addUser: user) { [weak self] result, error in
                if let error = error {
                    print(error)
                }
                print("nnn 3")
                if result {
                    self?.subscribeService.deleteSubscribe(subscibe) { error in
                        if let error = error {
                            print(error)
                        }
                        print("nnn 4")
                    }
                }
            }
            
        }
    }
    */
    
    @objc func buttonTap() {
        showAddInfoForPost { [self] descr, img in
            guard let description = descr else { return }
            guard let image = img else { return }
            guard let id = userID else { return }
            guard let name = profileTableHeaderView.nameLabel.text else { return }
            postService.uploadPost(image, id, description, name) { [weak self] _,_  in
                self?.tableView.reloadData()
            }
            //loadPost(id)
        }
    }
    
    func forExit() {
        
        let exitButton = UIBarButtonItem(title: NSLocalizedString("Exit", comment: ""), style: .plain, target: self, action: #selector(exitButtonTapped))
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
        authService.logoutUser { [weak self] error in
            
            if let logoVC = self?.logoViewController {
                self?.navigationController?.pushViewController(logoVC, animated: true)
            } else {
                print(error)
            }
            
        }
    }
    
    
    func setupTabBar() {
        tabBarController?.tabBar.isHidden = false
        
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
                        self?.userService.updateUserAvatar(userAva) { userAva in
                            print("AVA saved")
                        }
                        self?.tableView.reloadData()
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
        headerView.backgroundColor = Colors.myColorLight
        headerView.setNeedsLayout()
        headerView.layoutIfNeeded()
        headerView.frame.size = headerView.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
    }
}

extension ProfileViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        } else if section == 1 {
            return  1
        } else {
            return  post.count
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 1 {
            
            guard let cell = tableView.dequeueReusableCell(
                withIdentifier: CellReuseID.custom.rawValue,
                for: indexPath
            ) as? PhotosTableViewCell else {
                fatalError("could not dequeueReusableCell")
            }
            let selectedView = UIView()
            selectedView.backgroundColor = Colors.myColorLight
            cell.selectedBackgroundView = selectedView
            
            //cell.collectionView.reloadData()
            //cell.names = names
            //cell.update(data[indexPath.row])
            NotificationCenter.default.post(name: .dataButtonTapped, object: data)
            cell.info = subscribers
            cell.contentView.frame.size.width = tableView.frame.width
            
            
            return cell
        } else if indexPath.section == 2 {
            
            guard let cell = tableView.dequeueReusableCell(
                withIdentifier: CellReuseID.base.rawValue,
                for: indexPath
            ) as? PostTableViewCell else {
                fatalError("could not dequeueReusableCell")
            }
            
            let selectedView = UIView()
            selectedView.backgroundColor = Colors.myColorLight
            cell.selectedBackgroundView = selectedView
            
            cell.likeAction = { [weak self] in
                self?.buttonTapped(at: indexPath)
            }
            
            cell.update(post[indexPath.row])
            
            
            guard let id = userID else { return cell }
            guard let post = post[indexPath.row].postID else { return cell }
            
            
            
            likeService.countLikes(forPostID: post) { count in
                cell.likesLabel.text = String(count)
            }
            
            
            likeService.checkLike(post, id) { result in
                if result {
                    cell.likesButton.isSelected = true
                } else {
                    cell.likesButton.isSelected = false
                }
            }

            return cell
            
        } else if indexPath.section == 0 {
            
            guard let cell = tableView.dequeueReusableCell(
                withIdentifier: CellReuseID.info.rawValue,
                for: indexPath
            ) as? ElementTabelViewCell else {
                fatalError("could not dequeueReusableCell")
            }
            
            let selectedView = UIView()
            selectedView.backgroundColor = Colors.myColorLight
            cell.selectedBackgroundView = selectedView
            
            cell.infoLabel.text = NSLocalizedString("My Photo Gallery", comment: "")
            cell.arrowButton.setImage(UIImage(systemName: "arrowshape.forward.fill"), for: .normal)
            cell.contentView.frame.size.width = tableView.frame.width
            return cell
        } else {
            return UITableViewCell()
        }
        
    }
    
    func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        /*
        if section == 0 {
            return "test"
        }
         */
        return " "
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
            return 50
        }
        
        if indexPath.section == 1 {
            return 130
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
            headerView.backgroundColor = Colors.myColorLight
            headerView.isUserInteractionEnabled = true
            return headerView
            
        } else {
            
            return nil
            
        }
       
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if indexPath.section == 2 {
            
            if editingStyle == .delete {
                let post = post[indexPath.row]
                guard let postID = post.postID else { return }
                postService.deletePost(post) { [weak self] post in
                    self?.likeService.deleteLikes(forPostID: postID) { error in
                        if let error = error {
                            print(error.localizedDescription)
                        }
                    }
                    self?.tableView.reloadData()
                }
            }
        }
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        if indexPath.section == 1 {
            return false
        } else {
            return true
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        cell.backgroundColor = Colors.almostWhite
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


