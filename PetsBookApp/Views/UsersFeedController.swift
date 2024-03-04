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
    
    var count: Int? {
        didSet {
            print("... count", count)
        }
    }
    
    
// MARK: - table -
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView.init(
            frame: .zero,
            style: .grouped
        )
        
        tableView.rowHeight = UITableView.automaticDimension
        
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
        view.backgroundColor = .systemBrown
        loadPost()
       // NotificationCenter.default.addObserver(self, selector: #selector(liked), name: .liked, object: nil)

        view.addSubview(tableView)
        setupConstraints()
        
        if let id = authService.currentUserHandler {
            self.baseUser = id
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        tableView.reloadData()
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
                    self?.likeService.unlikepost(idPost, id) { error in
                        if let error = error {
                            print(error.localizedDescription)
                        }
                        self?.tableView.reloadData()
                    }
                } else {
                    self?.likeService.addLike(idPost, id) { error in
                        if let error = error {
                            print(error.localizedDescription)
                        } else {
                            print("... liked!")
                        }
                        self?.tableView.reloadData()
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
        
        for _ in post {
            likeService.checkLike(post, id) { result in
                if result {
                    cell.likesButton.isSelected = true
                } else {
                    cell.likesButton.isSelected = false
                }
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
}
