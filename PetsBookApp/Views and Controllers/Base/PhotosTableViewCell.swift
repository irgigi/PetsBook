//
//  PhotosTableViewCell.swift
//  PetsBookApp
//


import UIKit


class PhotosTableViewCell: UITableViewCell {

//MARK: - properties
    
    let subscribeService = SubscribeService()

    var info: [UserAvatarAndName] = [] {
        didSet {
            collectionView.reloadData()
        }
    }

//MARK: - Subview
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.sizeToFit()
        collectionView.backgroundColor = Colors.almostWhite
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(CollectionViewCell.self, forCellWithReuseIdentifier: "Cell")
        layout.scrollDirection = .horizontal

        return collectionView
    }()
    
    
//MARK: - init
    
    override init(
        style: UITableViewCell.CellStyle,
        reuseIdentifier: String?
    ) {
        super.init(
            style: .default,
            reuseIdentifier: reuseIdentifier
        )
        NotificationCenter.default.addObserver(self, selector: #selector(dataButtonTapped), name: .dataButtonTapped, object: nil)
        collectionView.delegate = self
        collectionView.dataSource = self

        contentView.addSubview(collectionView)
        constraint()

    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
//MARK: -methods
    
    @objc func dataButtonTapped(_ notification: Notification) {
        guard let data = notification.object as? [UserAvatarAndName] else { return }
        info = data
        collectionView.reloadData()
    }
    
    func constraint() {
        NSLayoutConstraint.activate([
            
            collectionView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            collectionView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12),
            collectionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),
            collectionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12),
            collectionView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            collectionView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            collectionView.widthAnchor.constraint(equalTo: contentView.widthAnchor)
        
        ])
    }
    
}

extension PhotosTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        
        return 1
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return info.count

    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: "Cell",
            for: indexPath
        ) as? CollectionViewCell else {
            fatalError("error collection cell")
        }
        cell.setupImage(info[indexPath.row])
        cell.contentView.frame.size.width = collectionView.bounds.width
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let selectItem = info[indexPath.row]
        subscribeService.selectedUser = selectItem.user
    
    }
    
}
extension PhotosTableViewCell: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let with = contentView.frame.width //UIScreen.main.bounds.width
        
        let numberOfColumns: CGFloat = 4.5
        let cellWith = with / numberOfColumns
        
        return CGSize(width: cellWith, height: cellWith)

    }
}
