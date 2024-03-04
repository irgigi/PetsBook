//
//  NotificationName.swift
//  PetsBookApp


import Foundation

extension Notification.Name {
    static let customButtonTapped = Notification.Name("ButtonTapped")
    static let subscribeButtonTapped = Notification.Name("SubscribeButtonTapped")
    static let unSubscribeButtonTapped = Notification.Name("UnSubscribeButtonTapped")
    static let deleteButtonTapped = Notification.Name("DeleteButtonTapped")
    static let tapped = Notification.Name("Tapped")
    static let imageTapped = Notification.Name("ImageTapped")
    static let dataButtonTapped = Notification.Name("DataButtonTapped")
    static let liked = Notification.Name("Liked")
    static let newButtonTapped = Notification.Name("NewButtonTapped")
}
