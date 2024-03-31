//
//  UIViewController+Extension.swift
//  PetsBookApp

import UIKit

extension UIViewController {
    
    func showAllert(title: String = NSLocalizedString("Error!", comment: ""), message: String = NSLocalizedString("Try again!", comment: "")) {
        let alertViewController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default)
        alertViewController.addAction(action)
        present(alertViewController, animated: true)
    }
    
    func showAddName(completion: @escaping (String) -> Void) {
        let alertController = UIAlertController(title: NSLocalizedString("Enter pet's name", comment: ""), message: nil, preferredStyle: .alert)
        alertController.addTextField { textField in
            textField.placeholder = NSLocalizedString("text", comment: "")
        }
        
        let cancelAction = UIAlertAction(title: NSLocalizedString("Cancel", comment: ""), style: .cancel, handler: nil)
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
    
    //for create post
    public func showAddInfoForPost(completion: @escaping (String?, UIImage?) -> Void) {
        let alertController = UIAlertController(title: NSLocalizedString("Create description", comment: ""), message: nil, preferredStyle: .alert)
        let textView = UITextView()
        textView.textAlignment = .left
        textView.isEditable = true
        textView.isScrollEnabled = true
        
        alertController.view.addSubview(textView)
        textView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            textView.topAnchor.constraint(equalTo: alertController.view.topAnchor, constant: 20),
            textView.leadingAnchor.constraint(equalTo: alertController.view.leadingAnchor, constant: 20),
            textView.trailingAnchor.constraint(equalTo: alertController.view.trailingAnchor, constant: -20),
            textView.heightAnchor.constraint(equalToConstant: 300),
            textView.widthAnchor.constraint(equalToConstant: 250),
            
            alertController.view.widthAnchor.constraint(equalToConstant: 300),
            alertController.view.heightAnchor.constraint(equalToConstant: 400)
        ])

        let addPhotoAction = UIAlertAction(title: NSLocalizedString("Add photo", comment: ""), style: .default) { _ in
            self.openPhotoVC { img in
                //let description = alertController.textFields?[0].text ?? ""
                let description = textView.text
                completion(description, img)
            }
            
        }
        alertController.addAction(addPhotoAction)
        
        let cancelAction = UIAlertAction(title: NSLocalizedString("Cancel", comment: ""), style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true)
    }
    
    private func openPhotoVC(completion: @escaping (UIImage?) -> Void) {
        let photoVC = PhotosViewController()
        photoVC.didSelectPhoto = { [weak self] photo in
            self?.handleSelectedPhoto(photo)
            completion(photo)
        }
        photoVC.photoButton.isHidden = true
        present(photoVC, animated: true)
    }
    
    private func handleSelectedPhoto(_ photo: UIImage) {
        dismiss(animated: true)
        loadViewIfNeeded()
    }
}
