//
//  UserService.swift
//  PetsBookApp


import FirebaseAuth
import FirebaseFirestore
import FirebaseFirestoreSwift
import FirebaseStorage

struct UserUID: Codable {
    let user: String
    let userName: String?
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
    
    private let dataBase = Firestore.firestore()
    private let storage = Storage.storage().reference()
    
    var getUserUID: (() -> String)?
    
    var listenRegistration: ListenerRegistration? //firebase protocol
    
    
    func removeListener() {
        listenRegistration?.remove()
    }

    
  //MARK: - USER NAME -
    
    func addUser(_ user: UserUID, completion: @escaping (Error?) -> Void) {
        
        _ = try? dataBase.collection(.collectionUserName).addDocument(from: user) { error in
            if let error = error {
                print(error.localizedDescription)
            }
            print("userName DONE")
        }
         
    }
    
    func fetchName(user: String, completion: @escaping (UserUID?, Error?) -> Void) {
        
        let query = dataBase.collection(.collectionUserName)
        query.whereField("user", isEqualTo: user).getDocuments { (snapshot, error) in
            
            if let error = error {
                print(error.localizedDescription)
                completion(nil, error)
            } else {
                if let document = snapshot?.documents.first {
                    do {
                        let userName = try document.data(as: UserUID.self)
                        completion(userName, nil)
                    } catch {
                        completion(nil, error)
                    }

                } else {
                    completion(nil, nil)
                }
            }
        }
    }
    
    func checkName(user: String, completion: @escaping (Bool, Error?) -> Void) {
        let query = dataBase.collection(.collectionUserName)
        query.whereField("user", isEqualTo: user).getDocuments { (snapshot, error) in
            if let error = error {
                print(error.localizedDescription)
                completion(false, error)
            } else {
                if let count = snapshot?.documents.count, count > 0 {
                    completion(true, nil)
                } else {
                    completion(false, nil)
                }
            }
        }
    }
    
    func updateName(_ user: String, _ userName: String) {
        let query = dataBase.collection(.collectionUserName)
        query.whereField("user", isEqualTo: user).getDocuments { (snapshot, error) in
            if let error = error {
                print(error.localizedDescription)
            } else {
                if let document = snapshot?.documents {
                    for doc in document {
                        doc.reference.updateData(["userName": userName]) { error in
                            if let error = error {
                                print(error.localizedDescription)
                            } else {
                               print("update!")
                            }
                        }
                    }
                }
            }
        }
    }
    
    
 //MARK: - save/load user and status
    
    func addAboutUser(_ aboutUser: UserStatus, completion: @escaping (UserStatus) -> Void) {
        
        _ = try? dataBase.collection(.collectionName).addDocument(from: aboutUser, completion: { error in
            if let error = error {
                print(error.localizedDescription)
            }
            print("aboutUser DONE")
        })
    }
    
    func fetchStatus(user: String, completion: @escaping (UserStatus?, Error?) -> Void) {
        
        let query = dataBase.collection(.collectionName)
        query.whereField("user", isEqualTo: user).getDocuments { (snapshot, error) in
            
            if let error = error {
                print(error.localizedDescription)
                completion(nil, error)
            } else {
                if let document = snapshot?.documents.first {
                    do {
                        let userStatus = try document.data(as: UserStatus.self)
                        completion(userStatus, nil)
                    } catch {
                        completion(nil, error)
                    }

                } else {
                    completion(nil, nil)
                }
            }
        }
    }
    
    
 //MARK: -check
    
    func checkStatus(user: String, completion: @escaping (Bool, Error?) -> Void) {
        let query = dataBase.collection(.collectionName)
        query.whereField("user", isEqualTo: user).getDocuments { (snapshot, error) in
            if let error = error {
                print(error.localizedDescription)
                completion(false, error)
            } else {
                if let count = snapshot?.documents.count, count > 0 {
                    completion(true, nil)
                } else {
                    completion(false, nil)
                }
            }
        }
    }

 //MARK: -updatete
    
    func updateStatus(_ user: String, _ status: String) {
        let query = dataBase.collection(.collectionName)
        query.whereField("user", isEqualTo: user).getDocuments { (snapshot, error) in
            if let error = error {
                print(error.localizedDescription)
            } else {
                if let document = snapshot?.documents {
                    for doc in document {
                        doc.reference.updateData(["status": status]) { error in
                            if let error = error {
                                print(error.localizedDescription)
                            } else {
                               print("update!")
                            }
                        }
                    }
                }
            }
        }
    }

    
    
 //MARK: - AVA -
    
    //сохранение авы и получение ссылки
    func saveAvatar(_ user: String, _ image: UIImage, completion: @escaping (Result<String, Error>) -> Void) {
        guard let imageData = image.jpegData(compressionQuality: 0.5) else {
            completion(.failure(NSError(domain: "gordeeva.PetsBookApp", code: -1)))
            print("error-imageData")
            return
        }
         
        let imagePath = "avatars/\(user).jpg"
        let imageRef = storage.child(imagePath)
        
        imageRef.putData(imageData, metadata: nil) { metadata, error in
            if let error = error {
                completion(.failure(error))
            } else {
                imageRef.downloadURL { url, error in
                    if let error = error {
                        completion(.failure(error))
                    } else if let downloadURL = url {
                        let avatarURLString = downloadURL.absoluteString
                        completion(.success(avatarURLString))
                    }
                }
            }
        }
    }
    //добавление записи юзер - ссылка на аватарку
    func addUserAvatar(_ avaUser: UserAvatar, completion: @escaping (UserAvatar) -> Void) {
        
        _ = try? dataBase.collection(.collectionAvatar).addDocument(from: avaUser, completion: { error in
            if let error = error {
                print(error.localizedDescription)
            } else {
                print("aboutUser DONE")
            }
            
        })
    }
    //получение данных
    func fetchAvatar(user: String, completion: @escaping (UserAvatar?, Error?) -> Void) {
        
        let query = dataBase.collection(.collectionAvatar)
        query.whereField("user", isEqualTo: user).getDocuments { (snapshot, error) in
            
            if let error = error {
                print(error.localizedDescription)
                completion(nil, error)
            } else {
                if let document = snapshot?.documents.first {
                    do {
                        let userAvatar = try document.data(as: UserAvatar.self)
                        completion(userAvatar, nil)
                    } catch {
                        completion(nil, error)
                    }

                } else {
                    completion(nil, nil)
                }
            }
        }
    }

    //для загрузки подписок
    func getListenerhAvatar(user: String, completion: @escaping (UserAvatar?, Error?) -> Void) {
        removeListener()
        let query = dataBase.collection(.collectionAvatar)
        query.whereField("user", isEqualTo: user).addSnapshotListener { (snapshot, error) in
            
            if let error = error {
                print(error.localizedDescription)
                completion(nil, error)
            } else {
                if let document = snapshot?.documents.first {
                    do {
                        let userAvatar = try document.data(as: UserAvatar.self)
                        print("service - ", userAvatar.user)
                        completion(userAvatar, nil)
                    } catch {
                        completion(nil, error)
                    }

                } else {
                    completion(nil, nil)
                }
            }
        }
    }
    //для загрузки фото по ссылке
    func getAvaFromURL(from urlString: String, completion: @escaping (UIImage?) -> Void) {
        guard let url = URL(string: urlString) else {
            completion(nil)
            return
        }
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let data = data, let image = UIImage(data: data) {
                completion(image)
            } else {
                completion(nil)
            }
        } .resume()
    }
    
    //метод обновления данных в базе при добавлении
    func updateUserAvatar(_ avaUser: UserAvatar, completion: @escaping (UserAvatar) -> Void) {
        let query = dataBase.collection(.collectionAvatar).whereField("user", isEqualTo: avaUser.user)
        
        query.getDocuments { [self] (snapshot, error) in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            
    
            if let documents = snapshot?.documents, !documents.isEmpty {
                //если найдены документы, то обновляем
                guard let document = documents.first else {
                    return
                }
                
                let docID = document.documentID 
                
                dataBase.collection(.collectionAvatar).document(docID).delete()
                
                let _ = try? dataBase.collection(.collectionAvatar).addDocument(from: avaUser) { error in
                    if let error = error {
                        print(error.localizedDescription)
                        return
                    }
                    completion(avaUser)
                }
                

            } else {
                // если документы не найдены, то добавляем
                let _ = try? dataBase.collection(.collectionAvatar).addDocument(from: avaUser) { error in
                    if let error = error {
                        print(error.localizedDescription)
                        return
                    }
                    completion(avaUser)
                }
                
            }
            
        }
    }

}

private extension String {
    static let collectionName = "UserInfo"
    static let collectionAvatar = "UserAvatar"
    static let collectionUserName = "UserName"
}

