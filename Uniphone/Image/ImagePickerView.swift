import UIKit
import SwiftUI
import Firebase
import FirebaseStorage

var imagestring = ""
class Singleton {
    var imageString :String?
    
    static let sharedInstance = Singleton()
    private init(){
        
    }
}
struct ImagePickerView: UIViewControllerRepresentable {

    @Binding var selectedImage: UIImage?

       @Environment(\.presentationMode) var isPresented
       var sourceType: UIImagePickerController.SourceType
           
       func makeUIViewController(context: Context) -> UIImagePickerController {
           let imagePicker = UIImagePickerController()
           imagePicker.sourceType = self.sourceType
           imagePicker.delegate = context.coordinator // confirming the delegate
           return imagePicker
       }

       func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {

       }

       func makeCoordinator() -> Coordinator {
           return Coordinator(picker: self)
       }
}
class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    var picker: ImagePickerView
    
    init(picker: ImagePickerView) {
        self.picker = picker
    }
    
    
      func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
          print("Tutaj")
          if let selectedImage = info[.originalImage] as? UIImage{
                  
                    self.uploadImage(image: selectedImage )
                    self.picker.selectedImage = selectedImage
              Singleton.sharedInstance.imageString = imagestring
              self.picker.isPresented.wrappedValue.dismiss()
              
          }
              
               
               
                
             
        }
            func uploadImage(image: UIImage)
                {
                    let storage = Storage.storage()
                    let storageref = storage.reference()
                    var newSize:CGSize
                    newSize = CGSize(width: 300.0,height: 300.0)
                    let rect = CGRect(origin: .zero, size: newSize)
                    UIGraphicsBeginImageContextWithOptions(newSize,false,1.0)
                    image.draw(in: rect)
                    let newImage = UIGraphicsGetImageFromCurrentImageContext()
                    UIGraphicsEndImageContext()
                    print(Singleton.sharedInstance.imageString)
                   
                    let imagenode = storageref.child(Singleton.sharedInstance.imageString!)
              
                   
                    imagenode.putData(newImage!.pngData()!)
                   
                }
}


            
