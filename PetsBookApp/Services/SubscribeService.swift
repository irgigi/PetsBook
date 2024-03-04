//
//  SubscribeService.swift
//  PetsBookApp


import FirebaseAuth
import FirebaseFirestore
import FirebaseFirestoreSwift
import FirebaseStorage


struct Subscribe: Codable {
    let user: String
    let addUser: String
}


class SubscribeService {
    
    static let shared = SubscribeService()
    
    private let dataBase = Firestore.firestore()
    
    var value: String? {
        didSet {
            if let newValue = value {
                subUser?(newValue)
            }
        }
    }
    
    var selectedUser: UserUID? {
        didSet {
            if let newUser = selectedUser {
                NotificationCenter.default.post(name: .unSubscribeButtonTapped, object: newUser)
            }
        }
    }
    
    
    
    var listenRegistration: ListenerRegistration? //firebase protocol
    var subUser: ((String) -> Void)?
    
   
    
    func checkSubscribe(_ user: String, addUser: String, completion: @escaping (Bool, Error?) -> Void) {
        let subscribeRef = dataBase.collection(.collectionSubscribe)
        subscribeRef.whereField("addUser", isEqualTo: addUser)
            .whereField("user", isEqualTo: user)
            .getDocuments { query, error in
                if let error = error {
                    print(error.localizedDescription)
                } else {
                    if let documents = query?.documents {
                        let info = !documents.isEmpty
                        completion(info, nil)
                    } else {
                        completion(false, nil)
                    }
                }
            }
    }

    
    func addUserToUser(_ subscribe: Subscribe, completion: @escaping (Subscribe?, Error?) -> Void) {
        
        _ = try? dataBase.collection(.collectionSubscribe).addDocument(from: subscribe) { [weak self] error in
            if let error = error {
                print(error.localizedDescription)
            }
            if subscribe.user == subscribe.addUser {
                print("НЕЛЬЗЯ ПОДПИСАТЬСЯ НА СЕБЯ")
                return
            }
            
            self?.fetchSubscribe(completion: completion)
            
            
            print("userName DONE")
        }
    }
    
    
    
    
    func fetchSubscribe(completion: @escaping (Subscribe?, Error?) -> Void) {
        
        let query = dataBase.collection(.collectionSubscribe)
        query.getDocuments { (snapshot, error) in
            
            if let error = error {
                print(error.localizedDescription)
                completion(nil, error)
            } else {
                if let document = snapshot?.documents.first {
                    do {
                        let users = try document.data(as: Subscribe.self)
                        completion(users, nil)
                    } catch {
                        completion(nil, error)
                    }

                } else {
                    completion(nil, nil)
                }
            }
        }
    }
    
    
    func deleteSubscribe(_ subscribe: Subscribe, completion: @escaping (Error?) -> Void) {
        removeListener()
        let collection = dataBase.collection(.collectionSubscribe)
        let query = collection.whereField("user", isEqualTo: subscribe.user)
            .whereField("addUser", isEqualTo: subscribe.addUser)
            .limit(to: 1)
        query.addSnapshotListener { (snapshot, error) in
            if let error = error {
                completion(error)
            } else {
                guard let document = snapshot?.documents.first else {
                    completion(nil)
                    return
                }
                // удаляем подписку
                document.reference.delete { error in
                    if let error = error {
                        completion(error)
                    } else {
                        //подписка удалена
                        completion(nil)
                    }
                }
            }
        }
        
    }
    
    //загрузка подписок пользователя
    func getAddedUsers(_ user: String, completion: @escaping ([Subscribe]) -> Void) {
        let query = dataBase.collection(.collectionSubscribe)
        query.whereField("user", isEqualTo: user).getDocuments { snapshot, error in
            if let error = error {
                print(error.localizedDescription)
            } else {
                var subscribers: [Subscribe] = []
                if let informations = snapshot?.documents {
                    for document in informations {
                        if let addUser = document.data()["addUser"] as? String {
                            let subscribe = Subscribe(user: user, addUser: addUser)
                            subscribers.append(subscribe)
                        }
                    }
                }
                completion(subscribers)
                
            }
            
            
            
            
           /*
            // ответ приходит в главном потоке
            let subscribes = snapshot?.documents.compactMap({ snapshot in
                try? snapshot.data(as: Subscribe.self)
            }) ?? []
            print("---", subscribes)
            completion(subscribes)
           */
        }
    }
    
    func removeListener() {
        listenRegistration?.remove()
    }
    
}

private extension String {
    
    static let collectionSubscribe = "Subscribe"
    
}

