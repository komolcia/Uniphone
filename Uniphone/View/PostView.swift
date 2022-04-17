//
//  PostView.swift
//  Uniphone
//
//  Created by Julia Komorowska on 05/04/2022.
//
import FirebaseStorage
import Firebase
import SwiftUI


struct PostView: View {
    @EnvironmentObject var uniportData : UniPortViewModel
    @State var postTitle = ""
    @State var authorName = ""
    @State var postContent : [PostContent] = []
    private let storage = Storage.storage().reference()
    @State private var sourceType: UIImagePickerController.SourceType = .photoLibrary
    @State private var selectedImage: UIImage?
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
                        TextField("Me", text: $authorName)
                        Divider()
                    }
                .padding(.top,5).padding(.bottom,20)
                    ForEach($postContent){$content in
                        
                        VStack{
                            if content.type == .Image {
                            
                                
                                
                                            VStack {
                                                
                                                if selectedImage != nil {
                                                    Image(uiImage: selectedImage!)
                                                        .resizable()
                                                        .aspectRatio(contentMode: .fit)
                                                        .frame(width: 300, height: 300)
                                                    
                                                  
                                                 
                                                    
                                                } else {
                                                
                                                Button("Camera") {
                                                    self.sourceType = .camera
                                                    self.isImagePickerDisplay.toggle()
                                                }.padding()
                                                
                                                Button("photo") {
                                                    self.sourceType = .photoLibrary
                                                    self.isImagePickerDisplay.toggle()
                                                }.padding()
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
                                 
                                     postContent.append(PostContent(value: "", type: type))
                                 }
                            
                        }
                       
                        
                        
                    }
                }label: {
                    Image(systemName: "plus.circle.fill").font(.title2).foregroundStyle(.primary)
                    
                }.foregroundStyle(.primary).frame( maxWidth: .infinity, alignment: .leading)
                }.padding()
            }).navigationTitle(postTitle == "" ? "PostTitle": postTitle).navigationBarTitleDisplayMode(.inline).toolbar{
                ToolbarItem(placement: .navigationBarLeading){
                    Button("Cancel"){
                        uniportData.createPost.toggle()
                    
                    }
                }
               
                ToolbarItem(placement: .navigationBarTrailing){
                    Button("Post"){
                        uniportData.writePost(content: postContent, author: authorName, postTitle: postTitle)
                        
                        
                    }
                }
            }
            
        }
     }
    func persistImageToStorage(){
        
        
    }
}

struct PostView_Previews: PreviewProvider {
    static var previews: some View {
        PostView()
    }
}
func getFontSize(type: PostType)->CGFloat{
    switch type{
    case .header:
        return 24
    case .subheading:
        return 22
    case .Paragraph:
        return 18
    case .Image:
        return 18
    }
}

private func persistImageToStorage() {
        guard let uid = FirebaseManager.shared.auth.currentUser?.uid else { return }
        let ref = FirebaseManager.shared.storage.reference(withPath: uid)
        guard let imageData = self.image?.jpegData(compressionQuality: 0.5) else { return }
        ref.putData(imageData, metadata: nil) { metadata, err in
            if let err = err {
                self.loginStatusMessage = "Failed to push image to Storage: \(err)"
                return
            }

            ref.downloadURL { url, err in
                if let err = err {
                    self.loginStatusMessage = "Failed to retrieve downloadURL: \(err)"
                    return
                }

                self.loginStatusMessage = "Successfully stored image with url: \(url?.absoluteString ?? "")"
                print(url?.absoluteString)
            }
        }
    }
