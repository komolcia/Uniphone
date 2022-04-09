import SwiftUI
import Firebase
import FirebaseFirestore
import FirebaseDatabase
import Foundation
class UniPortViewModel: ObservableObject{
    @Published var posts: [Post]?
    @Published var alertMsg = ""
    @Published var showalert = false
    @Published var createPost = false
    func fetchPosts()async{
        do{
            let db = Firestore.firestore().collection("UniPort")
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
        withAnimation{posts?.remove(at: index)}
    }
}


