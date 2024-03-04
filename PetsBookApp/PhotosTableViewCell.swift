//
//  PhotosTableViewCell.swift
//  PetsBookApp
//


import UIKit


class PhotosTableViewCell: UITableViewCell {

    //let data = PostModel.make()
    //private var events = [Event]()
    let subscribeService = SubscribeService()
    
    var addImages: (([UIImage]) -> Void)?
    
    
    var images: [UIImage] = [] {
        didSet {
            collectionView.reloadData()
        }
    }
    
    var names: [UserUID] = [] {
        didSet {
            collectionView.reloadData()
        }
    }
    
    var info: [UserAvatarAndName] = [] {
        didSet {
            collectionView.reloadData()
        }
    }

    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.sizeToFit()
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(CollectionViewCell.self, forCellWithReuseIdentifier: "Cell")
        layout.scrollDirection = .horizontal
        //collectionView.register(ElementsCollectionViewCell.self, forCellWithReuseIdentifier: "Cell_2")
        //collectionView.register(ElementCollectionView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: "element")

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
        //collectionView.addSubview(imageCollection)
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
    
   /*
    @objc private func unSubscribeButtonTapped(_ notification: Notification) {
        print("nnn - here")
        
        print("nnn ->", selectedUser)
            //let openVC = OpenViewController(user: selectedUser.user)
            //self?.present(openVC, animated: true)
        
    }
*/
    
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
        /*
        if section == 1 {
    
            return  info.count
        }
        return 1
         */
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
        
        
        
        /*
        if indexPath.section == 1 {
            
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: "Cell",
                for: indexPath
            ) as? CollectionViewCell else {
                fatalError("error collection cell")
            }
// changed
            //cell.setupImage(images[indexPath.row])
            
            //cell.setupImage(images[indexPath.row])
            //cell.nameLabel.text = names[indexPath.row].userName
            
            cell.setupImage(info[indexPath.row])
            cell.contentView.frame.size.width = collectionView.bounds.width
            return cell
        } else {
            
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: "Cell_2",
                for: indexPath
            ) as? ElementsCollectionViewCell else {
                fatalError("error collection cell")
            }
            
            cell.textLabel.text = "Мои подписки"
            cell.arrowButton.setImage(UIImage(systemName: "arrowshape.forward.fill"), for: .normal)
            return cell
        }
       */
    }
    /*
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        guard let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "element", for: indexPath) as? ElementCollectionView else { fatalError() }

        headerView.textLabel.text = "Мои подписки"
        return headerView
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 100)
    }
    */
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let selectItem = info[indexPath.row]
        subscribeService.selectedUser = selectItem.user
        
        /*
        if indexPath.section == 0 {
            let controller = PhotosViewController()
            collectionView.deselectItem(at: indexPath, animated: true)
            
            var responder: UIResponder? = self
            while responder != nil {
                responder = responder?.next
                if let viewController = responder as? UIViewController {
                    viewController.navigationController?.pushViewController(controller, animated: true)
                }
            }
        } else if indexPath.section == 1 {
            
            let selectItem = info[indexPath.row]
            subscribeService.selectedUser = selectItem.user

        }
         
         */
    
    }
    
}
extension PhotosTableViewCell: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let with = contentView.frame.width //UIScreen.main.bounds.width
        
        let numberOfColumns: CGFloat = 4.5
        let cellWith = with / numberOfColumns
        
        return CGSize(width: cellWith, height: cellWith)
        
        /*
        
        let with = contentView.frame.width //UIScreen.main.bounds.width
        
        if indexPath.section == 1 {
            
            let numberOfColumns: CGFloat = 4.5
            let cellWith = with / numberOfColumns
            
            return CGSize(width: cellWith, height: cellWith)
        }
        
        return CGSize(width: with, height: 80)
        */

    }

    
}
