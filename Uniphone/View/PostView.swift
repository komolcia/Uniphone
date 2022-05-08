//
//  PostView.swift
//  Uniphone
//
//  Created by Julia Komorowska on 05/04/2022.
//
import FirebaseStorage
import Firebase
import SDWebImageSwiftUI
import SwiftUI
class StorageManager: ObservableObject {
    let storage = Storage.storage()
}


struct PostView: View {
    @EnvironmentObject var uniportData : UniPortViewModel
    @State var postTitle = ""
    @State var authorName = Auth.auth().currentUser?.email
    @State var postContent : [PostContent] = []
    private let storage = Storage.storage().reference()
    @State private var sourceType: UIImagePickerController.SourceType = .photoLibrary
    @State private var selectedImage: UIImage?
    @State var url = [String]()
    @State var i = 0
    @State var czyJest = ""
    @State private var isImagePickerDisplay = false
    var body: some View {
        NavigationView{
            ScrollView(.vertical,showsIndicators: false,content: {
                VStack( spacing: 15){
                    VStack(alignment: .leading){
                        TextField("Post Title", text: $postTitle).font(.title2)
                        Divider()
                    }
                    VStack(alignment: .leading,spacing: 11){
                        Text("Author:").font(.caption.bold())
                        Text(authorName!).font(.caption.italic())
                        Divider()
                    }
                .padding(.top,5).padding(.bottom,20)
                    ForEach($postContent){$content in
                         
                        VStack{
                            if content.type == .Image {
                            
                                
                                
                                            VStack {
                                                
                                                if selectedImage != nil {
                                                  
                                                    if downloadimagefromfirebase(mystring: content.value) != "" {
                                                        AnimatedImage(url: URL(string: downloadimagefromfirebase(mystring: content.value))!).resizable().aspectRatio(contentMode: .fit).frame(width: 300, height: 300).padding().onAppear{
                                                            content.value=downloadimagefromfirebase(mystring: content.value)
                                                            
                                                                print(content.value)
                                                                print("Jestem hejka naklejka")
                                                                
                                                                         
                                                                         
                                                            
                                                            }
                                                    }
                                                    else{
                                                        Loader()
                                                    }
                                                    }else {
                                                
                                             
                                                Button(action: {
                                                    self.sourceType = .photoLibrary
                                                    self.isImagePickerDisplay.toggle()
                                                    var mystrin = "\(UUID().uuidString)"
                                                    content.value = mystrin
                                                    Singleton.sharedInstance.imageString = mystrin
                                                   
                                                }, label: {
                                                    Text("Photo").fontWeight(.bold)})
                                                }
                                                
                                                
                                                    
                                                
                                                
                                            }
                                            

                                            .sheet(isPresented: self.$isImagePickerDisplay) {
                                                ImagePickerView(selectedImage: self.$selectedImage, sourceType: self.sourceType)
                                                
                                                
                                            }
                                            
                                
                                } else{
                                TextView(text: $content.value, height: $content.height, fontSize: getFontSize(type: content.type)).frame(height: content.height == 0 ? getFontSize(type: content.type) * 2: content.height).background(
                                    Text(content.type.rawValue).font(.system(size: getFontSize(type: content.type))).foregroundColor(.gray).opacity(content.value == "" ? 0.7 : 0).padding(.leading,5),alignment: .leading)
                            }
                        }
                 
                        
                      
                    }
                Menu {
                    ForEach(PostType.allCases,id: \.rawValue){
                            type in Button(type.rawValue){
                                 withAnimation{
                                 
                                     postContent.append(PostContent(value: "",type: type))
                                 }
                            
                        }
                       
                        
                        
                    }
                }label: {
                    Image(systemName: "plus.circle.fill").font(.title2).foregroundStyle(.primary)
                    
                }.foregroundStyle(.primary).frame( maxWidth: .infinity, alignment: .leading)
                }.padding()
            }).navigationTitle(postTitle == "" ? "PostTitle": postTitle).navigationBarTitleDisplayMode(.inline).toolbar{
                ToolbarItem(placement: .navigationBarLeading){
                    NavigationLink(destination: Home()) {
                        Text("Cancel").onTapGesture {
                                uniportData.createPost.toggle()
                                
                            }
                    }
                   // Button("Cancel"){
//uniportData.createPost.toggle()
                  //
                  //  }
                }
               
                ToolbarItem(placement: .navigationBarTrailing){
                    NavigationLink(destination: Home()) {
                        Text("Post").onTapGesture{
                            uniportData.writePost(content: postContent, author: authorName!, postTitle: postTitle)}
                    }
                    //Button("Post"){
                     //   uniportData.writePost(content: postContent, author: authorName!, postTitle: postTitle)//
                   //
                        
                   // }
                }
            }
            
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

struct PostView_Previews: PreviewProvider {
    static var previews: some View {
        PostView()
    }
}
func getFontSize(type: PostType)->CGFloat{
    switch type{
    case .LargerParagraph:
        return 22
    case .Paragraph:
        return 18
    case .Image:
        return 18
    }
}

