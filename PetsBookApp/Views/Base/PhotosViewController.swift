//
//  PhotosViewController.swift
//  PetsBookApp


import UIKit
//import iOSIntPackage

class PhotosViewController: UIViewController {

    //let imagePublisherFacade = ImagePublisherFacade()
    
    // массив для загрузки полученных картинок
    var photos: [UIImage] = []
    var fileURLs: [String] = []
    
    var didSelectPhoto: ((UIImage) -> Void)?
    
    //fileprivate lazy var profile: [Profile] = Profile.make()
    var photoCollectionService = PhotoCollectionService.shared
    
    
    let spacing = 8.0
    
    enum CellID: String {
        case base = "ViewCell_ReuseID"
    }
    
    lazy var photoButton: UIButton = {
        let button = UIButton()
        button.setTitle("Load photo", for: .normal)
        button.backgroundColor = .systemBlue
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 5
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOpacity = 0.7
        button.layer.shadowOffset = CGSize(width: 4, height: 4)
        button.addTarget(self, action: #selector(loadPhoto), for: .touchUpInside)
    
        return(button)
    }()
    
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
        view.addSubview(photoButton)
        loadSavedPhoto()
        setupCollectionView()
        setupLayouts()
    }
    
    @objc func loadPhoto() {
        presentImagePicker()
    }
    
    func presentImagePicker() {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: true)
    }
    
    func loadSavedPhoto() {
        photos = photoCollectionService.loadSavedPhoto()
        collectionView.reloadData()
    }
    
    func photoSelected(_ selectedPhoto: UIImage) {
        didSelectPhoto?(selectedPhoto)
        navigationController?.popViewController(animated: true)
    }
    
    private func setupCollectionView() {
        view.addSubview(collectionView)
        collectionView.dataSource = self
        collectionView.delegate = self
    }
    
    private func setupLayouts() {
        let safeAreaGuide = view.safeAreaLayoutGuide
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        photoButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            
            photoButton.topAnchor.constraint(equalTo: safeAreaGuide.topAnchor),
            photoButton.leadingAnchor.constraint(equalTo: safeAreaGuide.leadingAnchor, constant: 16),
            photoButton.trailingAnchor.constraint(equalTo: safeAreaGuide.trailingAnchor, constant: -16),
            photoButton.heightAnchor.constraint(equalToConstant: 60),
            
            collectionView.topAnchor.constraint(equalTo: photoButton.bottomAnchor, constant: 20),
            collectionView.bottomAnchor.constraint(equalTo: safeAreaGuide.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: safeAreaGuide.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: safeAreaGuide.trailingAnchor)
            
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
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedPhoto = photos[indexPath.item]
        didSelectPhoto?(selectedPhoto)
    }
}

extension PhotosViewController: UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let picImage = info[.originalImage] as? UIImage {
            //profileTableHeaderView.setImage(picImage)
            photoCollectionService.addCollectionPhoto(image: picImage, to: &photos)
            if let fileURL = photoCollectionService.savePhotoToFileSystem(image: picImage) {
                fileURLs.append(fileURL)
            }
            collectionView.reloadData()
        }
        picker.dismiss(animated: true)
    }
    
}
