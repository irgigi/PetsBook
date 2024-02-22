//
//  PhotosTableViewCell.swift
//  PetsBookApp
//


import UIKit

class PhotosTableViewCell: UITableViewCell {
    

    //let data = PostModel.make()
    //private var events = [Event]()
    
    let photoCollectionService = PhotoCollectionService.shared
    var images: [UIImage] = []

    
    let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.sizeToFit()
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(CollectionViewCell.self, forCellWithReuseIdentifier: "Cell")
        collectionView.register(ElementsCollectionViewCell.self, forCellWithReuseIdentifier: "Cell_2")
        
        return collectionView
    }()
    

    
    override init(
        style: UITableViewCell.CellStyle,
        reuseIdentifier: String?
    ) {
        super.init(
            style: .default,
            reuseIdentifier: reuseIdentifier
        )
        
        collectionView.delegate = self
        collectionView.dataSource = self

        contentView.addSubview(collectionView)
        //collectionView.addSubview(imageCollection)
        constraint()
        
        loadSavedPhoto()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func loadSavedPhoto() {
        images = photoCollectionService.loadSavedPhoto()
    }

    
    func constraint() {
        NSLayoutConstraint.activate([
            
            collectionView.topAnchor.constraint(equalTo: contentView.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12),
            collectionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),
            collectionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12),
            collectionView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            collectionView.widthAnchor.constraint(equalTo: contentView.widthAnchor)
        
        ])
    }
    
}
extension PhotosTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        
        return 2
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 1 {
            return 1//images.count //data.count
        }
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
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
            cell.contentView.frame.size.width = collectionView.bounds.width
            return cell
        } else {
            
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: "Cell_2",
                for: indexPath
            ) as? ElementsCollectionViewCell else {
                fatalError("error collection cell")
            }
            //cell.setupImage(data[indexPath.row])
            cell.textLabel.text = "Photos"
            cell.arrowButton.setImage(UIImage(systemName: "arrow.forward"), for: .normal)
            return cell
        }
       // return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionHeader {
            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "Cell_2", for: indexPath)
            return headerView
        }
        return UICollectionReusableView()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
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
        }
    }
        
}
extension PhotosTableViewCell: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let with = contentView.frame.width //UIScreen.main.bounds.width
        
        if indexPath.section == 1 {
            
            let numberOfColumns: CGFloat = 4.5
            let cellWith = with / numberOfColumns
            
            return CGSize(width: cellWith, height: cellWith)
        }
        
        return CGSize(width: with, height: 80)
        

    }

    
}
