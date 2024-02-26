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
       
    func uploadPost(_ image: UIImage, _ user: String, _ descript: String?, _ userName: String?, completion: @escaping ([Post], Error?) -> Void) {
           
           // сначала загружаем фото в Storage
           let storageRef = Storage.storage().reference().child("image").child("\(UUID().uuidString).jpg")
           guard let imageData = image.jpegData(compressionQuality: 0.5) else {
               let error = NSError(domain: "gordeeva.PetsBookApp", code: -1)
               print("error-imageData")
               completion([], error)
               return
           }
           
           let metadata = StorageMetadata()
           metadata.contentType = "image/jpeg"
           
           storageRef.putData(imageData, metadata: metadata) { metadata, error in
               if let error = error {
                   completion([], error)
                   return
               }
               
               // если фото успешно загружено, то получаем ссылку на него
               storageRef.downloadURL { [self] url, error in
                   if let error = error {
                       completion([], error)
                       return
                   }
                   
                   guard let photoUrl = url else {
                       let error = NSError()
                       completion([], error)
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
                           completion([], error)
                       } 
                   }
               }
           }
       }
    //Загрузка постов конкретного пользователя
    func getPost(_ user: String,completion: @escaping ([Post]) -> Void) {
        removeListener()
        let query = dataBase.collection(.collectionPost)
        query.whereField("user", isEqualTo: user).addSnapshotListener { snapshot, error in
            if let error = error {
                print(error.localizedDescription)
            }
            // ответ приходит в главном потоке
            
            let post = snapshot?.documents.compactMap({ snapshot in
                try? snapshot.data(as: Post.self)
            }) ?? []
            completion(post)
        }
    }
    
       
   // Загрузка постов с отслеживанием
    func addObserverForPost(completion: @escaping ([Post]) -> Void) {
        removeListener()
        dataBase.collection(.collectionPost).addSnapshotListener { snapshot, error in
            if let error = error {
                print(error.localizedDescription)
            }
            // ответ приходит в главном потоке
            
            let post = snapshot?.documents.compactMap({ snapshot in
                try? snapshot.data(as: Post.self)
            }) ?? []
            completion(post)
        }
    }
    
    func removeListener() {
        listenRegistration?.remove()
    }
    
    //для преобразования ссылки на фото в UIImage
    func getPhotoFromURL(from urlString: String, completion: @escaping (UIImage?) -> Void) {
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

    
}

private extension String {
    
    static let collectionPost = "Post"
    
}
