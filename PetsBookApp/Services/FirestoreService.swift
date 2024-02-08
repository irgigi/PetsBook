//
//  FirestoreService.swift
//  PetsBookApp

import FirebaseStorage
import FirebaseFirestore
import FirebaseFirestoreSwift

struct Event: Codable {
    @DocumentID var docID: String?
    let authorUID: String
    let author: String
    let description: String
    let image: String?
    let likes: Int
    let views: Int
}

final class FirestoreService {
    
    private let dataBase = Firestore.firestore()
    
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
    
    func loadImage(eventID: String, completion: @escaping (UIImage?) -> Void) {
        
        let eventRef = dataBase.collection(.collectionName).document(eventID)
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
    
    func addEvent(_ event: Event, completion: @escaping ([Event]) -> Void) {
        _ = try? dataBase.collection(.collectionName).addDocument(from: event, completion: { [weak self] error in
            if let error = error {
                print(error.localizedDescription)
            }
            // подгружаем данные
            self?.fetchDocument(completion: completion)
        })
    }
    
    func deleteEvent(_ event: Event, completion: @escaping ([Event]) -> Void) {
        guard let docID = event.docID else { return }
        dataBase.collection(.collectionName).document(docID).delete { [weak self] error in
            if let error = error {
                print(error.localizedDescription)
            }
            // подгружаем данные
            self?.fetchDocument(completion: completion)
        }
    }
    
    func fetchDocument(completion: @escaping ([Event]) -> Void) {
        dataBase.collection(.collectionName).getDocuments { snapshot, error in
            if let error = error {
                print(error.localizedDescription)
            }
            // ответ приходит в главном потоке
            let events = snapshot?.documents.compactMap({ snapshot in
                // отбрасываем nil при помощи функции compactMap
                try? snapshot.data(as: Event.self)
            }) ?? []
            
            completion(events)
        }
    }
    
}

private extension String {
    static let collectionName = "Events"
}

