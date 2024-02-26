//
//  OpenViewController.swift
//  PetsBookApp


import UIKit

class OpenViewController: UIViewController {
    
// MARK: - Properties
    
    let openTableHeaderView = OpenTableView()
    let profileTableHeaderView = ProfileTableHeaderView()
    private let userService = UserService()
    private let postService = PostService()
    private let subscribeService = SubscribeService.shared
    
    
    enum CellReuseID: String {
        case base = "BaseTableViewCell_ReuseID"
        case custom = "CustomTableViewCell_ReuseID"
    }
    
    private enum HeaderFooterReuseID: String {
        case base = "TableSelectionFooterHeaderView_ReuseID"
    }
    
    
// MARK: - Data
    
   // private var userUID = [UserUID]()
   // private var userStatus = [UserStatus]()
    private var post = [Post]()
    
   // var images: [UIImage] = []
    
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
    //MARK: - life cycle
    
    init(user: String?) {
        super.init(nibName: nil, bundle: nil)
        if let id = user {
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

        }
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        view.backgroundColor = .lightGray
        title = "Profile"

        tableView.addSubview(openTableHeaderView)
        view.addSubview(tableView)
        
        setupConstraints()
        tableView.reloadData()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
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
    
//MARK: - METHODS
        
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
        //cell.update(data[indexPath.row])
        cell.update(post[indexPath.row])
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
    
}
