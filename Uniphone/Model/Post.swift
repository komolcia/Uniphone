//
//  Post.swift
//  Uniphone
//
//  Created by Julia Komorowska on 04/04/2022.
//

import SwiftUI
import Firebase
import FirebaseFirestoreSwift
struct Post: Identifiable , Codable{
    @DocumentID var id: String?
    var title: String
    var author: String
    var postContent:[PostContent]
    var date: Timestamp
    enum CodingKeys: String ,CodingKey{
        case id
        case title
        case author
        case postContent
        case date
        
    }    
}
struct PostContent:Identifiable,Codable{
    var id=UUID().uuidString
    var value: String
    var type: PostType
    var height: CGFloat = 0
    var showImage: Bool = false
    enum CodingKeys : String,CodingKey{
      
        case type = "key"//firestore jest to key
        case value
    }
}
enum PostType: String,CaseIterable,Codable{
    case LargerParagraph = "Większy Paragraf"
    case Paragraph = "Paragraf"
    case Image = "Zdjęcie"
}
