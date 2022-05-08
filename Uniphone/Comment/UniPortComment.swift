//
//  UniPortComment.swift
//  Uniphone
import SwiftUI
import Firebase
import FirebaseFirestore
import FirebaseDatabase
class UniPortComment: ObservableObject{
    @Published var posts: [Comment]?
    @Published var alertMsg = ""
    @Published var showalert = false
    @Published var createPost = false
    @Published var isWriting = false
    func fetchPosts()async{
        do{
            let db = Firestore.firestore().collection("Komentarz")
            let posts = try await db.getDocuments()
            self.posts = posts.documents.compactMap({post in
                return try? post.data(as: Comment.self)
            })
            
        }catch{
            alertMsg = error.localizedDescription
            showalert.toggle()
        }
    }
    
    func deleteComment(post: Comment){
        guard let _ = posts else{return}
        let index = posts?.firstIndex(where: {
            currentPost in return currentPost.id == post.id
        }) ?? 0
        Firestore.firestore().collection("Komentarze").document(post.id ?? "").delete()
        withAnimation{posts?.remove(at: index)}
    }
    func writePost(author: String, comment:String,idPost: String){
        do{
            withAnimation{
                isWriting = true
                
            }
        
            let post =     Comment(comment: comment, author: author, idPost: idPost)
            let _ = try Firestore.firestore().collection("Komentarz").document().setData(from: post)
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


