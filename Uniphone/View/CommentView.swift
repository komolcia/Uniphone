//
//  CommentView.swift
//  Uniphone
//
//  Created by Julia Komorowska on 02/05/2022.
//

import Foundation
import FirebaseStorage
import Firebase
import SwiftUI
struct CommentView: View {
   let idPost : String

    @EnvironmentObject var uniportComment : UniPortComment
    @State var comment = ""
    @State var authorName = Auth.auth().currentUser?.email
    
    var body: some View {
        NavigationView{
            ScrollView(.vertical,showsIndicators: false,content: {
                VStack( spacing: 15){
                    VStack(alignment: .leading,spacing: 11){
                        Text("Autor:").font(.caption.bold())
                        Text(authorName!).font(.caption.italic())
                        Divider()
                    }
                    VStack(alignment: .leading){
                        TextField("Komentarz", text: $comment).font(.title2).onReceive(comment.publisher.collect()) {
                            comment = String($0.prefix(30))
                }
                        Divider()
                    }
                .padding(.top,5).padding(.bottom,20)
                }
            }).navigationTitle((authorName == "" ? "Author": authorName)!).navigationBarTitleDisplayMode(.inline).toolbar{
            
            
        
        ToolbarItem(placement: .navigationBarLeading){
            Button("Anuluj"){
                uniportComment.createPost.toggle()
            
            }
        }
       
        ToolbarItem(placement: .navigationBarTrailing){
            Button("Opublikuj"){
                uniportComment.writePost(author: authorName!, comment: comment, idPost: idPost)
                
                
            }
        }
                       }
        }}
}
struct CommentView_Previews: PreviewProvider {
    static var previews: some View {
        CommentView(idPost: "")
    }
}
