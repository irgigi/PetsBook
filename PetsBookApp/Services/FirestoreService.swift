//
//  FirestoreService.swift
//  PetsBookApp


import FirebaseFirestore
import FirebaseFirestoreSwift

struct Event: Codable {
    @DocumentID var docID: String?
    let author: String
    let description: String
    let image: String?
    let likes: Int
    let views: Int
}

final class FirestoreService {
    
    private let dataBase = Firestore.firestore()
    
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

