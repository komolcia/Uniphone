//
//  ContentViewNews.swift
//  Uniphone
//
//  Created by Julia Komorowska on 25/04/2022.
//

import SwiftUI

struct ContentViewNews: View {
    var body: some View {
        NavigationView{
            HomeNews()
        }
    }
}

struct ContentViewNews_Previews: PreviewProvider {
    static var previews: some View {
        ContentViewNews()
    }
}
