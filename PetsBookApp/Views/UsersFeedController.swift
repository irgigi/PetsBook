//
//  UsersFeedController.swift
//  PetsBookApp



import UIKit
import FirebaseAuth

final class UsersFeedController: UIViewController {
    
    let postService = PostService()
    let userService = UserService()
    let subscribeService = SubscribeService.shared
    
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
        view.addSubview(tableView)
        setupConstraints()
        loadPost()
    }
    
// MARK: - methods -
    
    func loadPost() {
        postService.addObserverForPost { [weak self] allPosts in
            //self?.post = []
            self?.post.append(contentsOf: allPosts)
            self?.tableView.reloadData()
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
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedItem = post[indexPath.row]
        //subscribeService.subUser?(selectedItem.user)
        subscribeService.value = selectedItem.user
        let openVC = OpenViewController(user: selectedItem.user)
        present(openVC, animated: true)
    }
}
