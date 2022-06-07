//
//  Comment.swift
//  Uniphone
//
//  Created by Julia Komorowska on 02/05/2022.
//

import Foundation
import SwiftUI
import Firebase
import FirebaseFirestoreSwift
struct Comment: Identifiable , Codable{
    @DocumentID var id: String?
    var comment: String
    var author: String
    var idPost: String?
    var date: Timestamp
}
