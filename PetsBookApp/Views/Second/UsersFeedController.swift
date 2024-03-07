//
//  UsersFeedController.swift
//  PetsBookApp



import UIKit
import FirebaseAuth

final class UsersFeedController: UIViewController {
    
    let postService = PostService()
    let userService = UserService()
    let likeService = LikeService.shared
    let subscribeService = SubscribeService.shared
    let authService = AuthService.shared
    
    let postCell = PostTableViewCell()
    
//MARK: -properties
    
    var post = [Post]()
    
    var value: String? {
        didSet {
            if let newValue = value {
                subscribeService.subUser?(newValue)
                print("/// - ///", newValue)
            }
        }
    }
    
    var likeItem: String?
    var likeUser: String?
    var baseUser: String?
  /*
    var count: Int? {
        didSet {
            print("... count", count)
        }
    }
   */
    
// MARK: - table -
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView.init(
            frame: .zero,
            style: .grouped
        )
        
        tableView.rowHeight = UITableView.automaticDimension
        
        tableView.backgroundColor = Colors.almostWhite
        tableView.separatorStyle = .singleLine
        tableView.separatorColor = Colors.myColor
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        
        tableView.register(
            UsersFeedTableViewCell.self,
            forCellReuseIdentifier: "table"
        )
        
        
        tableView.delegate = self
        tableView.dataSource = self
        
        
        return tableView
    }()
    
// MARK: - life cycle -
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Colors.myColorLight
        
        title = NSLocalizedString("Posts", comment: "")
        
       // NotificationCenter.default.addObserver(self, selector: #selector(liked), name: .liked, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(dismissedVC), name: .dissmissedVC, object: nil)

        view.addSubview(tableView)
        setupConstraints()
        
        if let id = authService.currentUserHandler {
            self.baseUser = id
            loadPost()
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    

    
// MARK: - methods -
    
   /*
    @objc func liked(_ notification: NSNotification) {
        guard let idPost = likeItem else { return }
        guard let idUser = likeUser else { return }
        
        if !postCell.likesButton.isSelected {
            likeService.likePost(idPost, idUser) { [weak self] error in
                if let error = error {
                    print(error.localizedDescription)
                }
                self?.postCell.likesButton.isSelected = true
            }
        }

    }
    */
    
    @objc private func dismissedVC(_ notification: Notification) {
        tableView.reloadData()
    }
    
    func loadPost() {
        postService.addForPost { [weak self] allPosts in
            self?.post = []
            self?.post.append(contentsOf: allPosts)
            self?.tableView.reloadData()

        }
    }
    
    func buttonTapped(at indexPath: IndexPath) {
       
        likeItem = post[indexPath.row].postID
        guard let idPost = likeItem else { return }
    
        if let id = baseUser {
            
            likeService.checkLike(idPost, id) { [weak self] result in
                if result {
                    self?.likeService.unlikepost(idPost, id) { [weak self] error in
                        if let error = error {
                            print(error.localizedDescription)
                        } else {
                            self?.postCell.likesButton.isSelected = false
                            self?.tableView.reloadData()
                            print("... unliked!")
                        }
                    }
                } else {
                    self?.likeService.addLike(idPost, id) { [weak self] error in
                        if let error = error {
                            print(error.localizedDescription)
                        } else {
                            self?.postCell.likesButton.isSelected = true
                            self?.tableView.reloadData()
                            print("... liked!")
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
    
// MARK: - layout -
    
    func setupConstraints() {
        let safeAreaGuide = view.safeAreaLayoutGuide
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

// MARK: - EXTRA -

extension UsersFeedController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return post.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: "table",
            for: indexPath
        ) as? UsersFeedTableViewCell else {
            fatalError("could not dequeueReusableCell")
        }
        
        let selectedView = UIView()
        selectedView.backgroundColor = Colors.myColorLight
        cell.selectedBackgroundView = selectedView
        
        cell.update(post[indexPath.row])
        //cell.contentView.frame.size.width = tableView.frame.width
        
        cell.likeAction = { [weak self] in
            self?.buttonTapped(at: indexPath)
        }
        
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let selectedItem = post[indexPath.row]
   
        
        //subscribeService.subUser?(selectedItem.user)
        subscribeService.value = selectedItem.user
        
        likeItem = selectedItem.postID
        likeUser = selectedItem.user
        
        print("... didset", indexPath)
        
        let openVC = OpenViewController(user: selectedItem.user)
        present(openVC, animated: true)
        
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.backgroundColor = Colors.almostWhite
    }
    
    
}
