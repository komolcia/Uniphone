//
//  UniPortViewModelNews.swift
//  Uniphone
//
//
//  UniPortViewModelNews.swift
//  Uniphone
//
//  Created by Julia Komorowska on 25/04/2022.
//
import SwiftUI
import Firebase
import FirebaseFirestore
import FirebaseDatabase
import Foundation
class UniPortViewModelNews: ObservableObject{
    @Published var posts: [Post]?
    @Published var alertMsg = ""
    @Published var showalert = false
    @Published var createPost = false
    @Published var isWriting = false
    func fetchPosts()async{
        do{
            let db = Firestore.firestore().collection("UniPortAktualnosci").order(by: "date",descending: true)
            let posts = try await db.getDocuments()
            self.posts = posts.documents.compactMap({post in
                return try? post.data(as: Post.self)
            })
            
        }catch{
            alertMsg = error.localizedDescription
            showalert.toggle()
        }
    }
    func deletePost(post: Post){
        guard let _ = posts else{return}
        let index = posts?.firstIndex(where: {
            currentPost in return currentPost.id == post.id
        }) ?? 0
        Firestore.firestore().collection("UniPortAktualnosci").document(post.id ?? "").delete()
        withAnimation{posts?.remove(at: index)}
    }
    func writePost(content: [PostContent],author: String, postTitle: String){
        do{
            withAnimation{
                isWriting = true
                
            }
        
            let post =     Post(title: postTitle, author: author, postContent: content, date: Timestamp(date: Date()))
            let _ = try Firestore.firestore().collection("UniPortAktualnosci").document().setData(from: post)
            withAnimation{
                posts?.append(post)
                isWriting = true
                createPost=false
            }
        }catch{
            print(error.localizedDescription)
        }
    }
}
