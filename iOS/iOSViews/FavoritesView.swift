//
//  FavoritesView.swift
//  iOS
//
//  Created by Marc Kramer on 22.08.20.
//

import SwiftUI

struct FavoritesView: View {
    
    var favorites = UserDefaults(suiteName: "group.ch.gfroerli.gfroerli")?.array(forKey: "favoritesIDs") as? [Int] ?? [Int]()
    
    var body: some View {
        NavigationView{
            VStack{
                Text("Placeholder")
                ForEach(favorites, id: \.self){ fav in
                    Text(String(fav))
                    
                }
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
