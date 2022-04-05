//
//  UniPortViewModel.swift
//  Uniphone
//
//  Created by Julia Komorowska on 04/04/2022.
//

import SwiftUI
import Firebase
import FirebaseFirestore
import FirebaseFirestoreSwift
import FirebaseDatabase
import Foundation
class UniPortViewModel: ObservableObject{
    @Published var posts: [Post]?
    @Published var alertMsg = ""
    @Published var showalert = false
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
}


