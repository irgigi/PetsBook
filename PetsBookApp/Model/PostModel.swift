//
//  PostModel.swift
//  PetsBookApp


import UIKit

struct PostModel {
    
    var user: String
    var image: UIImage
    var descript: String?
    var userName: String
    
}



class PostClass {
    
    var postService = PostService()
    var posts: [PostModel]?
    
    init() {}
    
    func loadPost() {
        postService.addForPost { [weak self] allPosts in
            for item in 0...allPosts.count {
                self?.posts?[item].user = allPosts[item].user
                self?.posts?[item].userName = allPosts[item].userName
                self?.posts?[item].descript = allPosts[item].descript
                
                self?.postService.getPhotoFromURL(from: allPosts[item].image) {[weak self] photo in
                    DispatchQueue.main.sync {
                        guard let img = photo else { return }
                        self?.posts?[item].image = img
                    }
                }
                
            }

        }
    }
    
}

/*
 
 PostModel(author: "Alex",
           description: NSLocalizedString("Me in 2 mounth", comment: "-"),
           image: UIImage(named: "felix1"),
           likes: 1,
           views: 1),
 
 ----
 
 func loadPost() {
     postService.addForPost { [weak self] allPosts in
         self?.post = []
         self?.post.append(contentsOf: allPosts)
         self?.tableView.reloadData()
     }
 }
 
 */

    
    

