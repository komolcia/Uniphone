//
//  HomeNews.swift
//  Uniphone
//
//  Created by Julia Komorowska on 25/04/2022.
//

import SwiftUI
import FirebaseStorage
import Firebase
import SDWebImageSwiftUI

struct HomeNews: View {
    @StateObject var uniPortData = UniPortViewModelNews()
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
                    Text("Aktualności")
                    )
                    .font(.title).fontWeight(.semibold)
                    .foregroundColor(.primary)
                    
                }else{
                    
                
                List(posts){post in
                    //cardview
                    CardView(post: post).fixedSize(horizontal: true, vertical: false)
                    //Swipe do usuniecia
                        .swipeActions(edge: .trailing, allowsFullSwipe: true){
                            Button{
                                if Auth.auth().currentUser?.email == "komolcia@gmail.com"{
                                    uniPortData.deletePost(post: post)}
                            } label:{
                                if Auth.auth().currentUser?.email == "komolcia@gmail.com"{
                            Image(systemName: "trash")
                                }
                            }}
                    
                }.listStyle(.insetGrouped)
            }
            }else{
                ProgressView()
            }
        }.navigationBarTitle("Aktualnosci" , displayMode: .inline)
            .frame(maxWidth: .infinity, maxHeight: .infinity).overlay(
                Button(action: {
                    if Auth.auth().currentUser?.email == "komolcia@gmail.com"{
                        uniPortData.createPost.toggle()}
                    
                }, label: {
                    if Auth.auth().currentUser?.email == "komolcia@gmail.com"{
                        Image(systemName: "plus").font(.title2.bold()).foregroundColor(.white).padding().background(Color(UIColor(red: 0.74, green: 0.41, blue: 0.32, alpha: 1.00)), in: Circle())}})
                .padding().foregroundStyle(.primary) ,alignment: .bottomTrailing
            ).onAppear{
                let appearance = UINavigationBarAppearance()
                appearance.backgroundImage = UIImage(named: "j")
                UINavigationBar.appearance().isTranslucent = false
                UINavigationBar.appearance().standardAppearance=appearance
                UINavigationBar.appearance().scrollEdgeAppearance = appearance
               // UINavigationBar.appearance().setBackgroundImage(UIImage(named: "j"), for: .default)
            
                 //   UINavigationBar.appearance().backgroundColor=UIColor.purple
               // UINavigationBar.appearance().setBackgroundImage(UIImage(named: "j"), for: .default)
            }.task {
            await uniPortData.fetchPosts()
            
        }.fullScreenCover(isPresented: $uniPortData.createPost,content: {
            PostViewNews().environmentObject(uniPortData)
        })
        .alert(uniPortData.alertMsg, isPresented: $uniPortData.showalert){
            
        }
    }
    
    @ViewBuilder
    func CardView(post: Post)->some View{
        VStack(alignment: .leading, spacing: 12){
            Text(post.title).fontWeight(.bold).fixedSize(horizontal: false, vertical: true)
            Text("Autor: \(post.author)").font(.callout).foregroundColor(.gray).fixedSize(horizontal: false, vertical: true)
      
            ForEach(post.postContent){ content in
                
                if content.type == .Image{
                    VStack{
                        AnimatedImage(url: URL(string: content.value)).resizable().aspectRatio(contentMode: .fit).frame(width: 300, height: 300).padding()
                    }
                    

                       
                   
                }
                else{
                    Text(content.value).font(.system(size: getFontSize(type: content.type))).fixedSize(horizontal: false, vertical: true)
                }
            }
            Text("Data: \(    post.date.dateValue().formatted(date: .numeric, time: .shortened))").font(.caption.bold()).foregroundColor(.gray).fixedSize(horizontal: false, vertical: true)
            

        }.onAppear{
            if czyJest == "jest"{
                self.i += 1}}
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
struct HomeNews_Previews: PreviewProvider {
    static var previews: some View {
        ContentViewNews()
           
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

