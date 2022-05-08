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
                        Text("Author:").font(.caption.bold())
                        Text(authorName!).font(.caption.italic())
                        Divider()
                    }
                    VStack(alignment: .leading){
                        TextField("Comment", text: $comment).font(.title2)
                        Divider()
                    }
                .padding(.top,5).padding(.bottom,20)
                }
            }).navigationTitle((authorName == "" ? "Author": authorName)!).navigationBarTitleDisplayMode(.inline).toolbar{
            
            
        
        ToolbarItem(placement: .navigationBarLeading){
            Button("Cancel"){
                uniportComment.createPost.toggle()
            
            }
        }
       
        ToolbarItem(placement: .navigationBarTrailing){
            Button("Post"){
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
