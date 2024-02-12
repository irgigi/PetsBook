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

struct UserStatus: Codable {
    let user: String
    let status: String?
}

struct UserAvatar: Codable {
    let user: String
    let avatar: String
}

final class UserService {
    
    //private let authService = AuthService()
    private let dataBase = Firestore.firestore()
    var getUserUID: (() -> String)?
    var getStatus: (() -> String)?
    
    var listenRegistration: ListenerRegistration? //firebase protocol
    
    func addObserverForEvents(completion: @escaping ([UserStatus]) -> Void) {
        dataBase.collection(.collectionName).addSnapshotListener { snapshot, error in
            if let error = error {
                print(error.localizedDescription)
            }
            // ответ приходит в главном потоке
            let info = snapshot?.documents.compactMap({ snapshot in
                // отбрасываем nil при помощи функции compactMap
                try? snapshot.data(as: UserStatus.self)
            }) ?? []
            completion(info)
        }
    }
    
    func removeListener() {
        listenRegistration?.remove()
    }
    
    func addAboutUserWithoutFetch(_ aboutUser: UserStatus) {
        _ = try? dataBase.collection(.collectionName).addDocument(from: aboutUser) { error in
            if let error = error {
                print(error.localizedDescription)
            }
            print("aboutUser DONE")
        }
    }
    
    func addUser(_ user: UserUID, completion: @escaping (Error?) -> Void) {
        
        _ = try? dataBase.collection(.collectionName).addDocument(from: user) { error in
            if let error = error {
                print(error.localizedDescription)
            }
            print("userInfo DONE")
        }
         
    }
 //MARK: - save/load user and status
    
    func addAboutUser(_ aboutUser: UserStatus, completion: @escaping ([UserStatus]) -> Void) {
        
        _ = try? dataBase.collection(.collectionName).addDocument(from: aboutUser, completion: { [weak self] error in
            if let error = error {
                print(error.localizedDescription)
            }
            print("aboutUser DONE")
            self?.fetchDocument(completion: completion)
        })
    }
    
    func fetchAboutUser(completion: @escaping ([UserStatus]) -> Void) {
        dataBase.collection(.collectionName).getDocuments { snapshot, error in
            if let error = error {
                print(error.localizedDescription)
            }
            // ответ приходит в главном потоке
            let info = snapshot?.documents.compactMap({ snapshot in
                // отбрасываем nil при помощи функции compactMap
                try? snapshot.data(as: UserStatus.self)
            }) ?? []
            
            completion(info)
        }
    }
    
    
 //MARK: - -
    
    func addImage(_ image: UIImage, completion: @escaping (Error?) -> Void) {
        guard let imageData = image.jpegData(compressionQuality: 0.5) else {
            completion(NSError(domain: "gordeeva.PetsBookApp", code: -1))
            print("error-imageData")
            return
        }
        let storageRef = Storage.storage().reference().child("image").child("\(UUID().uuidString).jpg")
        storageRef.putData(imageData, metadata: nil) { (metadata, error) in
            if let error = error {
                completion(error)
            } else {
                storageRef.downloadURL { [self] (url, error) in
                    if let error = error {
                        completion(error)
                    } else if let downloadURL = url {
                        addEventImage(imageURL: downloadURL.absoluteString, completion: completion)
                        print("DONE!")
                    }
                }
            }
            
        }
    }
    
    private func addEventImage(imageURL: String, completion: @escaping (Error?) -> Void) {
        let eventData: [String: Any] = ["image": imageURL]
        dataBase.collection(.collectionName).addDocument(data: eventData) { error in
            completion(error)
        }
    }
    
    func loadImage(user: String, completion: @escaping (UIImage?) -> Void) {
        
        let eventRef = dataBase.collection(.collectionName).document(user)
        eventRef.getDocument { (doc, error) in
            if let document = doc, document.exists {
                let evData = document.data()
                if let eventData = evData {
                    if let imageURLString = eventData["image"] as? String,
                       let imageURL = URL(string: imageURLString) {
                        let storageRef = Storage.storage().reference(forURL: imageURL.absoluteString)
                        storageRef.getData(maxSize: 5 * 1024 * 1024) { (data, error) in
                            if let _ = error {
                                completion(nil)
                            } else if let imageData = data, let image = UIImage(data: imageData) {
                                completion(image)
                            } else {
                                completion(nil)
                            }
                        }
                    }
                } else {
                    completion(nil)
                }
            }
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
    func fetchDocument(completion: @escaping ([UserStatus]) -> Void) {
        dataBase.collection(.collectionName).getDocuments { snapshot, error in
            if let error = error {
                print(error.localizedDescription)
            }
            // ответ приходит в главном потоке
            let info = snapshot?.documents.compactMap({ snapshot in
                // отбрасываем nil при помощи функции compactMap
                try? snapshot.data(as: UserStatus.self)
            }) ?? []
            
            completion(info)
        }
    }
    
}

private extension String {
    static let collectionName = "UserInfo"
}

