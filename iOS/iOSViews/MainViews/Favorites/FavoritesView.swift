//
//  FavoritesView.swift
//  iOS
//
//  Created by Marc Kramer on 22.08.20.
//

import SwiftUI
import MapKit

struct FavoritesView: View {
    @State var favorites =  [Int]()
    @ObservedObject var sensorsVm : SensorListViewModel
    @State var loadingState: loadingState = .loading
    
    var body: some View {
        NavigationView{
            VStack{
                if favorites.isEmpty{
                    VStack{
                        Spacer()
                        HStack{
                            Spacer()
                            Text("No Favorites").font(.largeTitle).foregroundColor(.gray)
                            Spacer()
                        }
                        Spacer()
                    }
                }else{
                    AsyncContentView(source: sensorsVm) { sensors in
                        ScrollView{
                            ForEach(sensors){ sensor in
                                if favorites.contains(sensor.id){
                                    NavigationLink(
                                        destination: SensorOverView(id: sensor.id),
                                        label: {
                                            SensorScrollItem(sensor: sensor)
                                        }).buttonStyle(PlainButtonStyle())
                                }
                            }
                            Spacer()
                        }
                    }
                }
            }
            .background(Color.systemGroupedBackground.ignoresSafeArea())
            .navigationTitle("Favorites")
        }.onAppear {
            favorites = UserDefaults(suiteName: "group.ch.gfroerli")?.array(forKey: "favoritesIDs") as? [Int] ?? [Int]()
        }
    }
}

struct FavoritesView_Previews: PreviewProvider {
    static var previews: some View {
        FavoritesView(sensorsVm: SensorListViewModel(), loadingState: .loaded).makePreViewModifier()
    }
}
