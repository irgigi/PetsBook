//
//  UserModel.swift
//  PetsBookApp


import UIKit

struct UserAvatarAndName {
    let user: UserUID
    let ava: UIImage
}

var data: [UserAvatarAndName] = [] {
    didSet {
        print("this", data.count)
        //NotificationCenter.default.post(name: .dataButtonTapped, object: data)
    }
}
