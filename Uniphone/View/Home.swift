
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
    @StateObject var uniPortData = UniPortViewModel()
    @Environment(\.colorScheme) var scheme//kolorki<3
    @State var url = ""
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
                                uniPortData.deletePost(post: post)
                            } label:{
                            Image(systemName: "trash")
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
            
        }.fullScreenCover(isPresented: $uniPortData.createPost,content: {
            PostView().environmentObject(uniPortData)
        })
        .alert(uniPortData.alertMsg, isPresented: $uniPortData.showalert){
            
        }
    }
    @ViewBuilder
    func CardView(post: Post)->some View{
        VStack(alignment: .leading, spacing: 12){
            Text(post.title).fontWeight(.bold)
            Text("Written By: \(post.author)").font(.callout).foregroundColor(.gray)
      
            ForEach(post.$postContent){ $content in
                
                if content.type == .Image{
                    VStack{
                    if url != ""{
                        AnimatedImage(url: URL(string: String(content.value))!).frame(width: 200, height: 200).cornerRadius(25).padding()
                    }
                    else{
                        Loader()
                    }
                    }.onAppear{
                        let storage = Storage.storage().reference()
                        storage.child(String(content.value)).downloadURL{
                            (url,err) in
                            if err != nil{
                                print((err?.localizedDescription))
                                return
                            }
                            $content.value = "\(url!)"
                            print(url)
                        }
                    }
                   
                }
                else{
                    Text(content.value).font(.system(size: getFontSize(type: content.type)))
                }
            }
            Text("Written: \(    post.date.dateValue().formatted(date: .numeric, time: .shortened))").font(.caption.bold()).foregroundColor(.gray)
            

        }
    }
}


struct Home_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
           
    }
}
func takeimage(mystring : String)->UIImage{
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

struct Loader : UIViewRepresentable{
    func makeUIView(context: UIViewRepresentableContext<Loader>) -> UIActivityIndicatorView {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.startAnimating()
        return indicator
    }
    func updateUIView(_ uiView: UIViewType, context: Context) {
        
    }
}
