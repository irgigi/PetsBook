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
    
}
