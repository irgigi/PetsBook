//
//  PostService.swift
//  PetsBookApp


import FirebaseAuth
import FirebaseFirestore
import FirebaseFirestoreSwift
import FirebaseStorage

struct Post: Codable {
    let user: String
    let image: String
    let descript: String?
    let userName: String
}

class PostService {
    
    private let dataBase = Firestore.firestore()
    private let storage = Storage.storage().reference()
    
    var listenRegistration: ListenerRegistration? //firebase protocol
    
    //MARK: - add photo
       
    func uploadPost(_ image: UIImage, _ user: String, _ descript: String?, _ userName: String?, completion: @escaping (Error?) -> Void) {
           
           // сначала загружаем фото в Storage
           let storageRef = Storage.storage().reference().child("image").child("\(UUID().uuidString).jpg")
           guard let imageData = image.jpegData(compressionQuality: 0.5) else {
               let error = NSError(domain: "gordeeva.PetsBookApp", code: -1)
               print("error-imageData")
               completion(error)
               return
           }
           
           let metadata = StorageMetadata()
           metadata.contentType = "image/jpeg"
           
           storageRef.putData(imageData, metadata: metadata) { metadata, error in
               if let error = error {
                   completion(error)
                   return
               }
               
               // если фото успешно загружено, то получаем ссылку на него
               storageRef.downloadURL { [self] url, error in
                   if let error = error {
                       completion(error)
                       return
                   }
                   
                   guard let photoUrl = url else {
                       let error = NSError()
                       completion(error)
                       return
                   }
                   
                   // сохраняем ссылку на фото в cloud firestore
                   let userPhootoRef = dataBase.collection(.collectionPost).document()
                   let data: [String: Any] = [
                       "user": user,
                       "image": photoUrl.absoluteString,
                       "descript": descript ?? "",
                       "userName": userName ?? ""
                   ]
                   
                   userPhootoRef.setData(data) { error in
                       if let error = error {
                           completion(error)
                       } else {
                           completion(nil)
                       }
                   }
               }
           }
       }
       
    
    func addObserverForPost(completion: @escaping (Post) -> Void) {
        dataBase.collection(.collectionPost).addSnapshotListener { snapshot, error in
            if let error = error {
                print(error.localizedDescription)
            }
            // ответ приходит в главном потоке
            if let info = snapshot?.documents.first {
                do {
                    let post = try info.data(as: Post.self)
                    completion(post)
                } catch {
                    print(error)
                }
            } 
        }
    }
    
    func removeListener() {
        listenRegistration?.remove()
    }
    
}

private extension String {
    
    static let collectionPost = "Post"
    
}
