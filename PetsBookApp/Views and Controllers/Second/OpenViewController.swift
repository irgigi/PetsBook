//
//  OpenViewController.swift
//  PetsBookApp


import UIKit

class OpenViewController: UIViewController {
    
//MARK: - service
    
    private let userService = UserService()
    private let postService = PostService()
    private let subscribeService = SubscribeService.shared
    private let authService = AuthService.shared
    private let likeService = LikeService.shared
    
// MARK: - Properties
    
    let openTableHeaderView = OpenTableView()
    let profileTableHeaderView = ProfileTableHeaderView()
    let openCell = OpenTableViewCell()
    
    enum CellReuseID: String {
        case base = "BaseTableViewCell_ReuseID"
        case custom = "CustomTableViewCell_ReuseID"
    }
    
    private enum HeaderFooterReuseID: String {
        case base = "TableSelectionFooterHeaderView_ReuseID"
    }
    
    var baseUser: String?
    var thisUser: String?
    var likeItem: String?

    
// MARK: - Data
    
   // private var userUID = [UserUID]()
   // private var userStatus = [UserStatus]()
    private var post = [Post]()
    
   // var images: [UIImage] = []
    
    var updateData: (() -> Void)?
    
    // MARK: - table
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView.init(
            frame: .zero,
            style: .grouped
        )
        
        tableView.rowHeight = UITableView.automaticDimension
        
        tableView.register(
            OpenTableViewCell.self,
            forCellReuseIdentifier: CellReuseID.base.rawValue
        )
        
        tableView.setAndLayout(headerView: openTableHeaderView)
        
        tableView.backgroundColor = Colors.almostWhite
        tableView.separatorStyle = .singleLine
        tableView.separatorColor = Colors.myColor
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        
        tableView.register(
            PhotosTableViewCell.self,
            forCellReuseIdentifier: CellReuseID.custom.rawValue)
        
        tableView.register(
            OpenTableView.self,
            forHeaderFooterViewReuseIdentifier: HeaderFooterReuseID.base.rawValue
        )
        
        tableView.delegate = self
        tableView.dataSource = self
        
        
        return tableView
    }()
   /*
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    */
//MARK: - init
    
    init(user: String?) {
        super.init(nibName: nil, bundle: nil)
        if let id = user {
            self.thisUser = id
            loadAvatar(id)
            loadPost(id)
            // загржаем статус, если есть
            userService.fetchStatus(user: id) {[weak self] (user, error) in
                if let error = error {
                    print(error.localizedDescription)
                } else {
                    if let us = user {
                        self?.openTableHeaderView.statusLabel.text = us.status
                        self?.tableView.reloadData()
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
                            self?.openTableHeaderView.nameLabel.text = n
                            print("?", n)
                            self?.tableView.reloadData()
                        }
                    } else {
                        self?.openTableHeaderView.nameLabel.text = "anonimus"
                        print("not found name")
                    }
                }
            }
            
            if let fromUser = authService.currentUserHandler {
                self.baseUser = fromUser
                subscribeService.checkSubscribe(fromUser, addUser: id) { [weak self] result, error in
                    if let error = error {
                        print(error.localizedDescription)
                    }
                    
                    if result {
                        
                        self?.openTableHeaderView.button.isSelected = true
                        self?.tableView.reloadData()
                        
                    } else {
                        
                        self?.openTableHeaderView.button.isSelected = false
                        self?.tableView.reloadData()
                    }
                    
                }
                
            }

        }

    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
//MARK: - life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        view.backgroundColor = .lightGray
        title = NSLocalizedString("Profile", comment: "")
        
        NotificationCenter.default.addObserver(self, selector: #selector(tapped), name: .tapped, object: nil)
        

        tableView.addSubview(openTableHeaderView)
        view.addSubview(tableView)
        
        setupConstraints()
        tableView.reloadData()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        if isBeingDismissed {
            NotificationCenter.default.post(name: .dissmissedVC, object: nil)
        }
    }
    
//MARK: - METHODS
    
    func close() {
        updateData?()
        dismiss(animated: true)
    }
    

    
    @objc func tapped(_ notification: NSNotification) {
        
        guard let id = baseUser else { return }
        guard let user = thisUser else { return }
        
        let subscibe = Subscribe(user: id, addUser: user)
        
        if openTableHeaderView.button.isSelected {
            
            subscribeService.checkSubscribe(id, addUser: user) { [weak self] result, error in
                if let error = error {
                    print(error)
                }
                if result {
                    self?.subscribeService.deleteSubscribe(subscibe) { [weak self] error in
                        if let error = error {
                            print(error)
                        }
                        self?.openTableHeaderView.button.isSelected = false
                        self?.tableView.reloadData()
                    }
                }
            }
        } else {
            
            subscribeService.checkSubscribe(id, addUser: user) { [weak self] result, error in
                if let error = error {
                    print(error)
                }
                if !result {
                    
                    if id == user {
                        self?.showAllert(message: NSLocalizedString("Error! It's your account!", comment: ""))
                    } else {
                        self?.subscribeService.addUserToUser(subscibe) { [weak self] error, result  in
                            if let error = error {
                                print(error)
                            }
                            self?.openTableHeaderView.button.isSelected = true
                            self?.tableView.reloadData()
                            
                            
                        }
                    }
                    
                }
            }
        }
        
        /*
        
        if openTableHeaderView.button.isSelected {
            if let id = user {
                print("nnn from", id)
                guard let user = fromUser else { return }
                let subscibe = Subscribe(user: user, addUser: id)
                print("nnn 2")
                subscribeService.checkSubscribe(user, addUser: id) { [weak self] result, error in
                    if let error = error {
                        print(error)
                    }
                    print("nnn 3")
                    if result {
                        self?.subscribeService.deleteSubscribe(subscibe) { [weak self] error in
                            if let error = error {
                                print(error)
                            }
                            print("nnn 4")
                            self?.openTableHeaderView.button.isSelected = false
                        }
                    }
                }
            }
            
            //NotificationCenter.default.post(name: .deleteButtonTapped, object: nil)
        } else {
            //NotificationCenter.default.post(name: .subscribeButtonTapped, object: nil)
            if let id = fromUser {
                guard let user = user else { return }
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
    }
        
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
                                self?.openTableHeaderView.imageView.image = image
                                self?.tableView.reloadData()
                            }
                        }
                    }
                }
            }
        }
    }
    
    func loadPost(_ user: String) {
        postService.getPost(user) { [weak self] allPosts in
            //self?.post = []
            self?.post.append(contentsOf: allPosts)
            self?.tableView.reloadData()
        }
    }
    
    func showFullScreenImage(_ image: UIImage?) {
        guard let image = image else { return }
        
        let fullScreenViewController = UIViewController()
        
        let imageView = UIImageView(frame: fullScreenViewController.view.bounds)
        imageView.contentMode = .scaleAspectFit
        imageView.image = image
        imageView.isUserInteractionEnabled = true
        
        let dismissTapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissFullScreenImage(_:)))
        imageView.addGestureRecognizer(dismissTapGesture)
        
        fullScreenViewController.view.addSubview(imageView)
        fullScreenViewController.modalPresentationStyle = .overFullScreen
        fullScreenViewController.view.backgroundColor = Colors.myColorLight
        present(fullScreenViewController, animated: true)
    }
    
    @objc func dismissFullScreenImage(_ gesture: UITapGestureRecognizer) {
        dismiss(animated: true)
    }
    
    func buttonTapped(at indexPath: IndexPath) {
        print("tap here2")
        
        likeItem = post[indexPath.row].postID
        guard let idPost = likeItem else { return }
    
        if let id = baseUser {
            
            likeService.checkLike(idPost, id) { [weak self] result in
                if result {
                    self?.likeService.unlikepost(idPost, id) { [weak self] error in
                        if let error = error {
                            print(error.localizedDescription)
                        }
                        print("... unliked!")
                        self?.openCell.likesButton.isSelected = true
                        self?.tableView.reloadData()
                    }
                } else {
                    self?.likeService.addLike(idPost, id) { [weak self] error in
                        if let error = error {
                            print(error.localizedDescription)
                        } else {
                            print("... liked!")
                            self?.openCell.likesButton.isSelected = true
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
        openTableHeaderView.translatesAutoresizingMaskIntoConstraints = false
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

extension OpenViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       
        return  post.count
        
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
            
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: CellReuseID.base.rawValue,
            for: indexPath
        ) as? OpenTableViewCell else {
            fatalError("could not dequeueReusableCell")
        }
        
        let selectedView = UIView()
        selectedView.backgroundColor = Colors.myColorLight
        cell.selectedBackgroundView = selectedView
        
        cell.likeAction = { [weak self] in
            self?.buttonTapped(at: indexPath)
        }
        
        cell.update(post[indexPath.row])
        
        
        guard let id = baseUser else { return cell }
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
            
        
    }
    
    func tableView(
        _ tableView: UITableView,
        heightForHeaderInSection section: Int
    ) -> CGFloat {
        return 150
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
    
        return 0
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForHeaderInSection section: Int) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    
        return UITableView.automaticDimension
       
    }
    
    func tableView(
        _ tableView: UITableView,
        viewForHeaderInSection section: Int
    ) -> UIView? {
        
       
            
        guard let headerView = tableView.dequeueReusableHeaderFooterView(
            withIdentifier: HeaderFooterReuseID.base.rawValue
        ) as? OpenTableView else {
            fatalError("could not dequeueReusableCell")
        }
        headerView.isUserInteractionEnabled = true
        return headerView
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedItem = post[indexPath.row]
        let photoService = PhotoService()
        photoService.getPhotoFromURL(from: selectedItem.image) { [weak self] image in
            DispatchQueue.main.async { [weak self] in
                guard let image = image else { return }
                self?.showFullScreenImage(image)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.backgroundColor = Colors.almostWhite
    }
    
}
