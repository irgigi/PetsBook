//
//  PhotosViewController.swift
//  PetsBookApp


import UIKit
//import iOSIntPackage

class PhotosViewController: UIViewController {

    //let imagePublisherFacade = ImagePublisherFacade()
    
    // массив для загрузки полученных картинок
    var photos: [UIImage] = []
    
    //fileprivate lazy var profile: [Profile] = Profile.make()
    
    
    
    let spacing = 8.0
    
    enum CellID: String {
        case base = "ViewCell_ReuseID"
    }
    
    private let collectionView: UICollectionView = {
        let  viewLayout = UICollectionViewFlowLayout()
        
        let collectionView = UICollectionView(
            frame: .zero,
            collectionViewLayout: viewLayout
        )
        collectionView.register(
            PhotosCollectionViewCell.self,
            forCellWithReuseIdentifier: CellID.base.rawValue
        )
        return collectionView
    }()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //загрузка своих фото в массив
        /*
        for i in 0...profile.count-1 {
            photos.append(UIImage(imageLiteralResourceName: profile[i].img))
        }
         */
        //подготовка перед отображением
        //imagePublisherFacade.subscribe(self) //подписка
        //imagePublisherFacade.addImagesWithTimer(time: 0.5, repeat: 21, userImages: photos) //загрузка с задержкой
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        //завершающие операции,когда представление исчезло с экрана
        //imagePublisherFacade.removeSubscription(for: self) //удаление подписки
        //imagePublisherFacade.rechargeImageLibrary() //очистка библиотеки загруженных фото
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Photo Gallery"
        view.backgroundColor = .white
        setupCollectionView()
        setupLayouts()
        


    }
    
    private func setupCollectionView() {
        view.addSubview(collectionView)
        collectionView.dataSource = self
        collectionView.delegate = self
    }
    
    private func setupLayouts() {
        let sefeAreaGuide = view.safeAreaLayoutGuide
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            
            collectionView.topAnchor.constraint(equalTo: sefeAreaGuide.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: sefeAreaGuide.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: sefeAreaGuide.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: sefeAreaGuide.trailingAnchor)
            
        ])
    }
}

extension PhotosViewController:  UICollectionViewDataSource, UICollectionViewDelegateFlowLayout { //ImageLibrarySubscriber {
    
    
    
    func receive(images: [UIImage]) {
        self.photos = images //загружаем в массив полученные фото
        self.collectionView.reloadData() //обновление
    
    }
    
    
    func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int
    ) -> Int {
        photos.count // количество ячеек в секции
        //profile.count - было
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: CellID.base.rawValue,
            for: indexPath) as! PhotosCollectionViewCell
        
        //let prof = profile[indexPath.row]
        //cell.setup(with: prof)
        cell.profileImageView.image = photos[indexPath.row]  //размещение картинок
        return cell
    }
    
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        let width = view.frame.width
        let numberOfColumns: CGFloat = 3.5
        let cellWidth = width / numberOfColumns

        return CGSize(width: cellWidth, height: cellWidth)
        
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        insetForSectionAt section: Int
    ) -> UIEdgeInsets {
        
        UIEdgeInsets(
            top: spacing,
            left: spacing,
            bottom: spacing,
            right: spacing)
        
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        minimumInteritemSpacingForSectionAt section: Int
    ) -> CGFloat {
        spacing
    }
}
