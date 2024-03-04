//
//  LikeService.swift
//  PetsBookApp


import FirebaseAuth
import FirebaseFirestore
import FirebaseFirestoreSwift
import FirebaseStorage

struct Like: Codable {
    let userFrom: String
    let postID: String
}

class LikeService {
    
    static let shared = LikeService()
    private let dataBase = Firestore.firestore()
    var listenRegistration: ListenerRegistration? //firebase protocol
    
    func addLike(_ postID: String, _ userFrom: String, completion: @escaping (Error?) -> Void) {
        
        let likeRef = dataBase.collection(.collectionLike)
        
        likeRef.whereField("postID", isEqualTo: postID)
            .whereField("userFrom", isEqualTo: userFrom)
            .getDocuments { snapshot, error in
                if let error = error {
                    completion(error)
                    return
                }
                
                guard let snapshot = snapshot else {
                    completion(nil)
                    return
                }
                
                if snapshot.isEmpty {
                    let likeData: [String: Any] = [
                        "postID": postID,
                        "userFrom": userFrom
                    ]
                    
                    likeRef.addDocument(data: likeData) { error in
                        if let error = error {
                            completion(error)
                        } else {
                            completion(nil)
                        }
                    }
                } else {
                    completion(nil)
                }
            }
    }

    func countLikes(forPostID postID: String, completion: @escaping (Int) -> Void) {
        
        let likesRef = dataBase.collection(.collectionLike)
        
        likesRef.whereField("postID", isEqualTo: postID).getDocuments { (snapshot, error) in
            if let error = error {
                print(error.localizedDescription)
                completion(0)
                return
            }
            
            guard let snapshot = snapshot else {
                completion(0)
                return
            }
            completion(snapshot.documents.count)
        }
    }
    
    func checkLike(_ postID: String, _ userFrom: String, completion: @escaping (Bool) -> Void) {
        
        let likesRef = dataBase.collection(.collectionLike)
        
        likesRef.whereField("postID", isEqualTo: postID)
            .whereField("userFrom", isEqualTo: userFrom)
            .getDocuments { snapshot, error in
                if let error = error {
                    completion(false)
                    return
                }
                
                guard let snapshot = snapshot else {
                    completion(false)
                    return
                }
                
                completion(!snapshot.isEmpty)
            }
    }
    
    func unlikepost(_ postID: String, _ userFrom: String, completion: @escaping (Error?) -> Void) {
        let likesRef = dataBase.collection(.collectionLike)
        
        likesRef.whereField("postID", isEqualTo: postID)
            .whereField("userFrom", isEqualTo: userFrom)
            .getDocuments { snapshot, error in
                if let error = error {
                    completion(error)
                    return
                }
                
                guard let snapshot = snapshot else {
                    completion(nil)
                    return
                }
                
                if !snapshot.isEmpty {
                    for document in snapshot.documents {
                        likesRef.document(document.documentID).delete { error in
                            if let error = error {
                                completion(error)
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

private extension String {
    
    static let collectionLike = "Like"
    
}
