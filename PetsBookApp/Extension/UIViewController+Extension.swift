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
    
}
