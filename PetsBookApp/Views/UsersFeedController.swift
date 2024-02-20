//
//  UsersFeedController.swift
//  PetsBookApp



import UIKit

final class UsersFeedController: UIViewController {
    
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
    }
    
    // MARK: - methods -
    
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
        return 1
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: "table",
            for: indexPath
        ) as? UsersFeedTableViewCell else {
            fatalError("could not dequeueReusableCell")
        }
        
        cell.contentView.frame.size.width = tableView.frame.width
        return cell
    }
}
