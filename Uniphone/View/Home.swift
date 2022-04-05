//
//  Home.swift
//  Uniphone
//
//  Created by Julia Komorowska on 04/04/2022.
//

import SwiftUI

struct Home: View {
    @StateObject var uniPortData = UniPortViewModel()
    @Environment(\.colorScheme) var scheme//kolorki<3
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
                
            }, label: {
                Image(systemName: "plus").font(.title2.bold()).foregroundColor(scheme == .dark ? Color.black : Color.white).padding().background(.primary, in: Circle())})
            .padding().foregroundStyle(.primary) ,alignment: .bottomTrailing
        )
        .task {
            await uniPortData.fetchPosts()
            
        }.alert(uniPortData.alertMsg, isPresented: $uniPortData.showalert){
            
        }
    }
    @ViewBuilder
    func CardView(post: Post)->some View{
        VStack(alignment: .leading, spacing: 12){
            Text(post.title).fontWeight(.bold)
            Text("Written By: \(post.author)").font(.callout).foregroundColor(.gray)
      
            Text("Written By: \(    post.date.dateValue().formatted(date: .numeric, time: .shortened))").font(.caption.bold()).foregroundColor(.gray)

        }
    }
}

struct Home_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
           
    }
}
