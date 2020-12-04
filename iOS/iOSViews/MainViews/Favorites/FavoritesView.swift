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
    @StateObject var sensorsVm = SensorListViewModel()
    @State var loadingState: loadingState = .loading
    
    var body: some View {
        NavigationView{
            VStack{
                if favorites.isEmpty{
                    VStack{
                        Spacer()
                        Text("No Favorites").font(.largeTitle).foregroundColor(.gray)
                        Spacer()
                    }
                }else{
                ScrollView(.vertical){
                    switch loadingState{
                    case .loading:
                        LoadingView()
                    case .loaded:
                        VStack(alignment: .center,spacing:0){
                            ForEach(sensorsVm.sensorArray){ sensor in
                                if favorites.contains(sensor.id!){
                                NavigationLink(
                                    destination: SensorOverView(id: sensor.id!),
                                    label: {
                                        SensorScrollItem(sensor: sensor)
                                    }).buttonStyle(PlainButtonStyle())
                                    
                                }
                            }
                        }
                    case .error:
                        ErrorView()
                    }
                }
                }
            }.onAppear(perform: {
                load()
            })
            .navigationTitle("Favorites")
           /* .toolbar(content: {
                ToolbarItem{
                    Button(action: {
                        load()
                        print(favorites)
                    }, label: {
                        Image(systemName:"arrow.clockwise")
                    })
                }
            })*/
        }
    }
    
    func load(){
        favorites = UserDefaults(suiteName: "group.ch.gfroerli")?.array(forKey: "favoritesIDs") as? [Int] ?? [Int]()
        loadingState = .loading
        sensorsVm.getAllSensors { (result) in
            switch result {
            case .success(let str):
                loadingState = .loaded
                print(str)
            case .failure(let error):
                loadingState = .error
                switch error {
                case .badURL:
                    print("Bad URL")
                case .requestFailed:
                    print("Network problems")
                case.decodeFailed:
                    print("Decoding data failed")
                case .unknown:
                    print("Unknown error")
                }
            }
            
        }
    }
}

struct FavoritesView_Previews: PreviewProvider {
    static var previews: some View {
        FavoritesView(sensorsVm: SensorListViewModel(), loadingState: .loaded).makePreViewModifier()
    }
}
