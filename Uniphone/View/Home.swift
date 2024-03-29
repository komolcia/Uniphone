
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
                    Text(Image(systemName: "pencil.and.outline"))
                    +
                    Text("UniPort")
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
        }.navigationBarTitle("UniPort" , displayMode: .inline)
        .frame(maxWidth: .infinity, maxHeight: .infinity).overlay(
            Button(action: {
                uniPortData.createPost.toggle()
                
            }, label: {
                Image(systemName: "plus").font(.title2.bold()).foregroundColor(.white).padding().background(Color(UIColor(red: 0.74, green: 0.41, blue: 0.32, alpha: 1.00)), in: Circle())})
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
            await uniPortComments.fetchPosts()
        }.fullScreenCover(isPresented: $uniPortData.createPost,content: {
            PostView().environmentObject(uniPortData)
        })
        .alert(uniPortData.alertMsg, isPresented: $uniPortData.showalert){
            
        }
    }

    
    @ViewBuilder
    func CardView(post: Post)->some View{
       
        NavigationLink{
            Home1( post: post)
        } label: {
            VStack(alignment: .leading, spacing: 15){
            
            Text(post.title).fontWeight(.bold).fixedSize(horizontal: false, vertical: true)
            Text("Autor: \(post.author)").font(.callout).foregroundColor(.gray).fixedSize(horizontal: false, vertical: true)
      
            ForEach(post.postContent){ content in
                
                if content.type == .Image{
                    VStack{
                        if String(content.value).count >= 40{
                            AnimatedImage(url: URL(string: content.value)).resizable().aspectRatio(contentMode: .fit).frame(width: 300, height: 300).padding()
                        }
                        
                    }
                    

                       
                   
                }
                else{
                    Text(content.value).font(.system(size: getFontSize(type: content.type))).fixedSize(horizontal: false, vertical: true)
                }
            }
            Text("Data: \(    post.date.dateValue().formatted(date: .numeric, time: .shortened))").font(.caption.bold()).foregroundColor(.gray).fixedSize(horizontal: false, vertical: true)
            
            
 
        }.onAppear{

       
          
            if czyJest == "jest"{
                self.i += 1}
               
          
                        
        }.task {
            await uniPortData.fetchPosts()
            await uniPortComments.fetchPosts()
        }}
       
        
                   
    }
@ViewBuilder
func CommentsView(comment: Comment)->some View{
    ScrollView{
        VStack( spacing: 15){
        Text("Autor: \(comment.author)").font(.system(size:10))
        Text(comment.comment).fontWeight(.bold).font(.system(size:14))
    }.frame(maxWidth: .infinity, alignment: .trailing)}
}
    func getImageFrom(gradientLayer:CAGradientLayer) -> UIImage? {
        var gradientImage:UIImage?
        UIGraphicsBeginImageContext(gradientLayer.frame.size)
        if let context = UIGraphicsGetCurrentContext() {
            gradientLayer.render(in: context)
            gradientImage = UIGraphicsGetImageFromCurrentImageContext()?.resizableImage(withCapInsets: UIEdgeInsets.zero, resizingMode: .stretch)
        }
        UIGraphicsEndImageContext()
        return gradientImage
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
/*func takeimage(mystring: String)->String{
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
          self.url.append("\(url!)")
          print("udalo sie")
          
          Image(uiImage: image1)
              .resizable()
              .aspectRatio(contentMode: .fit)
              .frame(width: 300, height: 300)
        
        
      }
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
    
   
}*/
 

struct Loader : UIViewRepresentable{
    func makeUIView(context: UIViewRepresentableContext<Loader>) -> UIActivityIndicatorView {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.startAnimating()
        return indicator
    }
    func updateUIView(_ uiView: UIViewType, context: Context) {
        
    }
}
    final class Loader2 : ObservableObject {
        @Published var data : Data?

        init(_ id: String){
            // the path to the image
            let url = "\(id)"
            print("load image with id: \(id)")
            let storage = Storage.storage()
            let ref = storage.reference().child(url)
            ref.getData(maxSize: 1 * 1024 * 1024) { data, error in
                if let error = error {
                    print("\(error)")
                }

                DispatchQueue.main.async {
                    self.data = data
                }
            }
        }
    }
    }

struct Home1: View {
    @Environment(\.defaultMinListRowHeight) var minRowHeight
    @StateObject var uniPortData = UniPortViewModel()
    @StateObject var uniPortComments = UniPortComment()
    @Environment(\.colorScheme) var scheme//kolorki<3
    @State var url = [String]()
    @State var i = 0
    @State var czyJest = ""
    @State var post: Post
    var body: some View {
        ScrollView{
           
            VStack(alignment: .center, spacing: 15){
                Spacer()
                     .frame(height: 40)
                Text(post.title).fontWeight(.bold).fixedSize(horizontal: false, vertical: true)
                Text("Autor: \(post.author)").font(.callout).foregroundColor(.gray).fixedSize(horizontal: false, vertical: true)
          
                ForEach(post.postContent){ content in
                    
                    if content.type == .Image {
                       
                        VStack{
                            if String(content.value).count >= 40{
                                AnimatedImage(url: URL(string: content.value)).resizable().aspectRatio(contentMode: .fit).frame(width: 300, height: 300).padding()
                            
                            }
                        }
                        

                           
                       
                   
                    }
                    else{
                        Text(content.value).font(.system(size: getFontSize(type: content.type))).fixedSize(horizontal: false, vertical: true)
                    }
                }
                Text("Data: \(    post.date.dateValue().formatted(date: .numeric, time: .shortened))").font(.caption.bold()).foregroundColor(.gray)
                Button(action: {
                    uniPortComments.createPost.toggle()
                    
                }, label: {
                    Text("Dodaj Komentarz")})
                .padding().foregroundStyle(.blue)
               
                
                
                if let posts1 = uniPortComments.posts {
                    if posts1.isEmpty{
                        
                    }else{
                    List(posts1){ comment in
                        if comment.idPost == post.id {
                              CommentsView(comment: comment).swipeActions(edge: .trailing, allowsFullSwipe: true){
                                    Button{
                                        if Auth.auth().currentUser?.email == comment.author{
                                            uniPortComments.deleteComment(post: comment)
                                            
                                        }
                                    } label:{
                                    if Auth.auth().currentUser?.email == comment.author{
                                           Image(systemName: "trash")
                                        }
                                    }}}}.frame(minHeight: minRowHeight * 40)
                            
                            .listStyle(.insetGrouped)
                    }
                    
                }
                
     
            }
        }.task {
            await uniPortData.fetchPosts()
            await uniPortComments.fetchPosts()
        }.fullScreenCover(isPresented: $uniPortComments.createPost){
            task{
                await uniPortComments.fetchPosts()}
        }content: {
            CommentView(idPost: post.id!).environmentObject(uniPortComments)
        }.alert(uniPortComments.alertMsg, isPresented: $uniPortComments.showalert){
            
        }.onAppear{
            i += 1
        }
    }
    @ViewBuilder
    func CommentsView(comment: Comment)->some View{
        ScrollView{
            VStack( spacing: 15){
            Text("Autor: \(comment.author)").font(.system(size:10))
            Text(comment.comment).fontWeight(.bold).font(.system(size:14))
            }.frame(maxWidth: .infinity, alignment: .trailing).task {
                await uniPortData.fetchPosts()
                await uniPortComments.fetchPosts()
            }}
    }
}
        
