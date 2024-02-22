//
//  UIViewController+Extension.swift
//  PetsBookApp

import UIKit

extension UIViewController {
    
    func showAllert(title: String = "Ошибка", message: String = "Попробуйте ещё раз") {
        let alertViewController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default)
        alertViewController.addAction(action)
        present(alertViewController, animated: true)
    }
    
    func showAddName(completion: @escaping (String) -> Void) {
        let alertController = UIAlertController(title: "Введите имя питомца", message: nil, preferredStyle: .alert)
        alertController.addTextField { textField in
            textField.placeholder = "text"
        }
        
        let cancelAction = UIAlertAction(title: "Отмена", style: .cancel, handler: nil)
        let okAction = UIAlertAction(title: "OK", style: .default) { _ in
            if let textField = alertController.textFields?.first, let text = textField.text, !text.isEmpty {
                print("???", text)
                completion(text)
            }
        }
        alertController.addAction(cancelAction)
        alertController.addAction(okAction)
        present(alertController, animated: true)
    }
    
    //test
    /*
    func showAddPost(_ user: String, _ image: String, completion: @escaping (Post) -> Void) {
        let alertController = UIAlertController(title: "Создать описание", message: nil, preferredStyle: .alert)
        alertController.addTextField()
        alertController.addTextField()
        let okAction = UIAlertAction(title: "OK", style: .default) { _ in
            let post = Post(user: user, image: image, descript: alertController.textFields?[0].text ?? "", userName: alertController.textFields?[1].text ?? "")
            completion(post)
        }
        let cancelAction = UIAlertAction(title: "Отмена", style: .cancel, handler: nil)
        alertController.addAction(okAction)
        present(alertController, animated: true)
    }
    */
    //other way
    public func showAddInfoForPost(completion: @escaping (String?, UIImage?) -> Void) {
        let alertController = UIAlertController(title: "Создать описание", message: nil, preferredStyle: .alert)
        alertController.addTextField { (textField) in
            let heihtConstraint = NSLayoutConstraint(item: textField, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 100)
            
            textField.textAlignment = .left
            textField.contentVerticalAlignment = .top
            textField.translatesAutoresizingMaskIntoConstraints = false
            textField.addConstraint(heihtConstraint)
        }
        
        let addPhotoAction = UIAlertAction(title: "Добавить фото", style: .default) { _ in
            self.openPhotoVC { img in
                let description = alertController.textFields?[0].text ?? ""
                completion(description, img)
            }
            
        }
        alertController.addAction(addPhotoAction)
        
        let cancelAction = UIAlertAction(title: "Отмена", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true)
    }
    
    private func openPhotoVC(completion: @escaping (UIImage?) -> Void) {
        let photoVC = PhotosViewController()
        photoVC.didSelectPhoto = { [weak self] photo in
            self?.handleSelectedPhoto(photo)
            completion(photo)
        }
        present(photoVC, animated: true)
    }
    
    private func handleSelectedPhoto(_ photo: UIImage) {
        dismiss(animated: true)
        loadViewIfNeeded()
    }
}
