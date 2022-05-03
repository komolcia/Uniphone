
//  Home.swift
//  Uniphone
//
//  Created by Julia Komorowska on 04/04/2022.
//

import SwiftUI
import FirebaseStorage
import Firebase
import SDWebImageSwiftUI

struct Home: View {
    @Environment(\.defaultMinListRowHeight) var minRowHeight
    @StateObject var uniPortData = UniPortViewModel()
    @StateObject var uniPortComments = UniPortComment()
    @Environment(\.colorScheme) var scheme//kolorki<3
    @State var url = [String]()
    @State var i = 0
    @State var czyJest = ""
               
    var body: some View {
        VStack{
            if let posts=uniPortData.posts{
                if posts.isEmpty{
                    (
                    Text(Image(systemName: "rectangle.and.pencil.and.ellipsis"))
                    +
                    Text("Start Writing on UniPort")
                    )
                    .font(.title).fontWeight(.semibold)
                    .foregroundColor(.primary)
                    
                }else{
                    
                
                List(posts){post in
                    //cardview
                    CardView(post: post)
                    //Swipe do usuniecia
                        .swipeActions(edge: .trailing, allowsFullSwipe: true){
                            Button(role: .destructive){
                                if Auth.auth().currentUser?.email == post.author{
                                    uniPortData.deletePost(post: post)
                                    
                                }
                            } label:{
                            if Auth.auth().currentUser?.email == post.author{
                            Image(systemName: "trash")
                                }
                            }}
                    
                    
                }.listStyle(.insetGrouped)
            }
            }else{
                ProgressView()
            }
        }
        .navigationTitle("UniPort").frame(maxWidth: .infinity, maxHeight: .infinity).overlay(
            Button(action: {
                uniPortData.createPost.toggle()
                
            }, label: {
                Image(systemName: "plus").font(.title2.bold()).foregroundColor(scheme == .dark ? Color.black : Color.white).padding().background(.primary, in: Circle())})
            .padding().foregroundStyle(.primary) ,alignment: .bottomTrailing
        )
        .task {
            await uniPortData.fetchPosts()
            await uniPortComments.fetchPosts()
            
        }.fullScreenCover(isPresented: $uniPortData.createPost,content: {
            PostView().environmentObject(uniPortData)
        }).fullScreenCover(isPresented: $uniPortComments.createPost,content: {
            CommentView().environmentObject(uniPortComments)
        })
        .alert(uniPortComments.alertMsg, isPresented: $uniPortComments.showalert){
            
        }
        .alert(uniPortData.alertMsg, isPresented: $uniPortData.showalert){
            
        }
    }
    
    @ViewBuilder
    func CardView(post: Post)->some View{
        VStack(alignment: .leading, spacing: 10){
            Text(post.title).fontWeight(.bold)
            Text("Written By: \(post.author)").font(.callout).foregroundColor(.gray)
      
            ForEach(post.postContent){ content in
                
                if content.type == .Image{
                    VStack{
                        if downloadimagefromfirebase(mystring: content.value) != "" {
                            AnimatedImage(url: URL(string: downloadimagefromfirebase(mystring: content.value))!).resizable().aspectRatio(contentMode: .fit).frame(width: 300, height: 300).padding()}
                        else{
                            Loader()
                        }
                    }
                    

                       
                   
                }
                else{
                    Text(content.value).font(.system(size: getFontSize(type: content.type)))
                }
            }
            Text("Written: \(    post.date.dateValue().formatted(date: .numeric, time: .shortened))").font(.caption.bold()).foregroundColor(.gray)
            Button(action: {
                uniPortComments.createPost.toggle()
                
            }, label: {
                Text("Dodaj Komentarz")})
            .padding().foregroundStyle(.primary)
        
            
            if let posts1 = uniPortComments.posts {
                if posts1.isEmpty{
                    
                }else{
                List(posts1){ comment in
                   
                          CommentsView(comment: comment).swipeActions(edge: .trailing, allowsFullSwipe: true){
                                Button(role: .destructive){
                                    if Auth.auth().currentUser?.email == comment.author{
                                        uniPortComments.deleteComment(post: comment)
                                        
                                    }
                                } label:{
                                if Auth.auth().currentUser?.email == post.author{
                                Image(systemName: "trash")
                                    }
                                }}}.frame(minHeight: minRowHeight * 3).border(Color.red)
                        
                    .listStyle(.insetGrouped)
                }
                
            }
        }.onAppear{
            if czyJest == "jest"{
                self.i += 1}}
                   
    }
@ViewBuilder
func CommentsView(comment: Comment)->some View{
    VStack(alignment: .trailing, spacing: 10){
        Text("Written By: \(comment.author)").font(.callout).foregroundColor(.black)
        Text(comment.comment).fontWeight(.bold).font(.caption.bold()).font(.system(size: 22))
    }.onAppear{
        print("Zobaczmy czy dziala")
    }
}

func downloadimagefromfirebase(mystring: String)->String{
   @State var myurl : String
    myurl = ""
    self.czyJest = "jest"
    let storage = Storage.storage().reference()
   
        storage.child(mystring).downloadURL{
            (url,err) in
            if err != nil{
                print((err?.localizedDescription))
                print("OOOO nIIIIEEEE")
                return
            }
         
            myurl = "\(url!)"
            
            
            self.url.append("\(url!)")
            
            
    }
    var j = 0
    if url.indices.contains(i) == true{
        for string in url {
            if string.contains(mystring) == true{
                return url[j]
            }
            j += 1
        }
       return url[i]
    }
    else{
        return ""
    }
}
struct Home_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
           
    }
}
/*func takeimage(){
    let storage = Storage.storage()
    
    print(mystring)
    let mystring1 = "gs://uniphone-e2c89.appspot.com/"+mystring
    let islandRef = storage.reference(forURL: mystring1)
    var image : UIImage
    image = UIImage(systemName: "heart.fill")!
 
    islandRef.getData(maxSize: 1 * 20000000 * 200000) { data, error in
      if let error = error {
        // Uh-oh, an error occurred!
          print(error)
      } else {
        
          let image1 = UIImage(data: data!)!
          print("udalo sie")
          
          Image(uiImage: image1)
              .resizable()
              .aspectRatio(contentMode: .fit)
              .frame(width: 300, height: 300)
        
        
      }
    }
    
   return image
}
 */

struct Loader : UIViewRepresentable{
    func makeUIView(context: UIViewRepresentableContext<Loader>) -> UIActivityIndicatorView {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.startAnimating()
        return indicator
    }
    func updateUIView(_ uiView: UIViewType, context: Context) {
        
    }
}
}
