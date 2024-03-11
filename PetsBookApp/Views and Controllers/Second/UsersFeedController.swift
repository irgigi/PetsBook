//
//  UsersFeedController.swift
//  PetsBookApp



import UIKit
import FirebaseAuth

final class UsersFeedController: UIViewController {
    
//MARK: - service
    
    let postService = PostService()
    let userService = UserService()
    let likeService = LikeService.shared
    let subscribeService = SubscribeService.shared
    let authService = AuthService.shared
    
//MARK: -properties
    
    let postCell = PostTableViewCell()
    
    var post = [Post]() {
        didSet {
            tableView.reloadData()
        }
    }

    var likeItem: String?
    var likeUser: String?
    var baseUser: String?

    
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
        
        NotificationCenter.default.addObserver(self, selector: #selector(dismissedVC), name: .dissmissedVC, object: nil)

        view.addSubview(tableView)
        setupConstraints()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let id = authService.currentUserHandler {
            self.baseUser = id
            loadPost()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    

    
// MARK: - methods -

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
            
        }
        
    }
    
// MARK: - constraint -
    
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

// MARK: - Extencion -

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
