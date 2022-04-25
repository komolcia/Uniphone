//
//  UniPortApp1.swift
//  Uniphone
//
//  Created by Julia Komorowska on 25/04/2022.
//


import SwiftUI
import Firebase

struct UniPortApp1: App{
    init(){
        FirebaseApp.configure()
    }
    var body: some Scene{
        WindowGroup{
            ContentView1()
        }
    }
}
