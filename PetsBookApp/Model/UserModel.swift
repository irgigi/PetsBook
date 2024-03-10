//
//  UserModel.swift
//  PetsBookApp


import UIKit

struct UserAvatarAndName {
    let user: UserUID
    let ava: UIImage
}

class UserAvatarAndNameModel {
    
    var data: [UserAvatarAndName] = [] {
        didSet {
            print("this", data.count)
        }
    }
    
    init() {}
}



