//
//  FavoritesView.swift
//  iOS
//
//  Created by Marc Kramer on 22.08.20.
//

import SwiftUI

struct FavoritesView: View {
    var body: some View {
        NavigationView{
            VStack{
                Text("Placeholder")
                Divider()
                Spacer()
            }.navigationTitle("Favorites")
            .background(Color.gray.opacity(0.001))
            
        }
    }
}

struct FavoritesView_Previews: PreviewProvider {
    static var previews: some View {
        FavoritesView()
    }
}
