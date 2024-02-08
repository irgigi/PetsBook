//
//  UserService.swift
//  PetsBookApp


import FirebaseAuth
import FirebaseFirestore
import FirebaseFirestoreSwift
import FirebaseStorage

struct UserUID: Codable {
    let userUID: String
}

final class UserService {
    
    //private let authService = AuthService()
    private let dataBase = Firestore.firestore()
    var getUserUID: (() -> String)?
    
    func addUser(_ user: UserUID, completion: @escaping (Error?) -> Void) {
        
        _ = try? dataBase.collection(.collectionName).addDocument(from: user) { error in
            if let error = error {
                print(error.localizedDescription)
            }
            print("userInfo DONE")
        }
         
    }
    
    
    /*
    func addInfo(_ userServiceFB: UserServiceFB, completion: @escaping ([UserServiceFB]) -> Void) {
        if let user = getUserUID {
            _ = try? dataBase.collection(.collectionName).addDocument(from: userServiceFB, completion: { [weak self] error in
                if let error = error {
                    print(error.localizedDescription)
                }
                print("userInfo DONE")
                // подгружаем данные
                self?.fetchDocument(completion: completion)
            })
        }
    }
    */
    func fetchDocument(completion: @escaping ([UserUID]) -> Void) {
        dataBase.collection(.collectionName).getDocuments { snapshot, error in
            if let error = error {
                print(error.localizedDescription)
            }
            // ответ приходит в главном потоке
            let info = snapshot?.documents.compactMap({ snapshot in
                // отбрасываем nil при помощи функции compactMap
                try? snapshot.data(as: UserUID.self)
            }) ?? []
            
            completion(info)
        }
    }
    
}

private extension String {
    static let collectionName = "UserInfo"
}

