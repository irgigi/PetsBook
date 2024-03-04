//
//  PhotoService.swift
//  PetsBookApp

import FirebaseAuth
import FirebaseFirestore
import FirebaseFirestoreSwift
import FirebaseStorage

struct UserPhoto: Codable {
    let user: String
    let photo: String
}

final class PhotoService {
    
    private let dataBase = Firestore.firestore()
    private let storage = Storage.storage().reference()
    
    
    var listenRegistration: ListenerRegistration? //firebase protocol
    
    
 //MARK: - add photo
    
    func uploadPhoto(_ image: UIImage, _ user: String, completion: @escaping (Error?) -> Void) {
        
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
                let userPhootoRef = dataBase.collection(.collectionPhoto).document()
                let data: [String: Any] = [
                    "user": user,
                    "photo": photoUrl.absoluteString
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
    
 //MARK: - отслеживание
    
    func listenForUserPhotos(completion: @escaping ([UIImage]?, Error?) -> Void) {
        
        removeListener()
        
        dataBase.collection(.collectionPhoto).addSnapshotListener { snapshot, error in
            if let error = error {
                completion(nil, error)
                return
            }
            
            var userPhoto = [UIImage]()
            
            if let docs = snapshot?.documents {
                for document in docs {
                    let data = document.data()
                   // let user = data["user"] as? String ?? ""
                    let photoRef = data["photo"] as? String ?? ""
                    
                    if let photoURL = URL(string: photoRef) {
                        let photoRef = Storage.storage().reference(forURL: photoURL.absoluteString)
                        photoRef.getData(maxSize: 5 * 1024 * 1024) { (data, error) in
                            if let _ = error {
                                completion(nil, error)
                                return
                            } else if let imageData = data, let image = UIImage(data: imageData) {
                                userPhoto.append(image)
                                completion(userPhoto, nil)
                            } else {
                                completion(nil, nil)
                            }
                        }
                    }
                }
            }
        }
    }
    
    
    func removeListener() {
        listenRegistration?.remove()
    }
    

//MARK: - -
    
    // загрузить из бд и отслеживать
    func addObserverForPhotos(completion: @escaping ([UserPhoto]) -> Void) {
        removeListener()
        dataBase.collection(.collectionPhoto).addSnapshotListener { snapshot, error in
            if let error = error {
                print(error.localizedDescription)
            }
            // ответ приходит в главном потоке
            let info = snapshot?.documents.compactMap({ snapshot in
                // отбрасываем nil при помощи функции compactMap
                try? snapshot.data(as: UserPhoto.self)
            }) ?? []
            completion(info)
        }
    }
    

    // сохранить в бд
    func addAboutUserWithoutFetch(_ photo: UserPhoto) {
        _ = try? dataBase.collection(.collectionPhoto).addDocument(from: photo) { error in
            if let error = error {
                print(error.localizedDescription)
            }
            print("photo DONE")
        }
    }
    
    //MARK: - -
      
      //добавить фото и сохранить ссылку
    
      func addPhoto(_ image: UIImage, completion: @escaping (Result<String, Error>) -> Void) {
          guard let imageData = image.jpegData(compressionQuality: 0.5) else {
              completion(.failure(NSError(domain: "gordeeva.PetsBookApp", code: -1)))
              print("error-imageData")
              return
          }
          let storageRef = Storage.storage().reference().child("image").child("\(UUID().uuidString).jpg")
          storageRef.putData(imageData, metadata: nil) { (metadata, error) in
              if let error = error {
                  completion(.failure(error))
                  return
              } else {
                  storageRef.downloadURL { (url, error) in
                      if let error = error {
                          completion(.failure(error))
                      } else if let downloadURL = url {
                          completion(.success(downloadURL.absoluteString))
                          print("DONE!")
                      }
                  }
              }
              
          }
      }
      
      
      private func addURLPhoto(imageURL: String, completion: @escaping (Error?) -> Void) {
          let eventData: [String: Any] = ["photo": imageURL]
          dataBase.collection(.collectionPhoto).addDocument(data: eventData) { error in
              completion(error)
          }
      }
      
      func loadImage(user: String, completion: @escaping (UIImage?) -> Void) {
          
          let eventRef = dataBase.collection(.collectionPhoto).document(user)
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
    
    //для загрузки фото по ссылке
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
    
    static let collectionPhoto = "Photo"
    
}
