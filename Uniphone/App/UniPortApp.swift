//
//  UniPortApp.swift
//  Uniphone
//
//  Created by Julia Komorowska on 05/04/2022.
//

import SwiftUI
import Firebase

struct UniPortApp: App{
    init(){
        FirebaseApp.configure()
    }
    var body: some Scene{
        WindowGroup{
            ContentView()
        }
    }
}



