//
//  PhotoCollectionService.swift
//  PetsBookApp


import UIKit

class PhotoCollectionService {
    
    static let shared = PhotoCollectionService()
    
    private init() {}
    
    //MARK: - COLLECTION methods -
      
    func addCollectionPhoto(image: UIImage, to collection: inout [UIImage]) {
        collection.append(image)
    }
    
    func savePhotoToFileSystem(image: UIImage) -> String? {
        if let data = image.jpegData(compressionQuality: 1.0) {
            let filename = getDocumentDirectory().appendingPathComponent(UUID().uuidString + ".jpeg")
            do {
                try data.write(to: filename)
                return filename.absoluteString
            } catch {
                return nil
            }
        }
        return nil
    }
    
    func deleteCollectionPhoto(at index: Int, from collection: inout [UIImage], fileURLs: inout [String]) {
        if index < collection.count {
            collection.remove(at: index)
            fileURLs.remove(at: index)
        }
    }
    
    private func getDocumentDirectory() -> URL {
        let path = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return path[0]
    }
    
    func loadSavedPhoto() -> [UIImage] {
        var loadedImages: [UIImage] = []
        let documentDirectory = getDocumentDirectory()
        do {
            let fileURLs = try FileManager.default.contentsOfDirectory(at: documentDirectory, includingPropertiesForKeys: nil)
            for fileURL in fileURLs {
                if let imageData = try? Data(contentsOf: fileURL), let image = UIImage(data: imageData) {
                    loadedImages.append(image)
                }
            }
        } catch {
            print(error)
        }
        return loadedImages
    }
    
}
