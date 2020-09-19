//
//  FavoritesView.swift
//  iOS
//
//  Created by Marc Kramer on 22.08.20.
//

import SwiftUI
import MapKit

struct FavoritesView: View {
    
    @State var favorites = UserDefaults(suiteName: "group.ch.gfroerli.gfroerli")?.array(forKey: "favoritesIDs") as? [Int] ?? [Int]()
    @ObservedObject var sensorsVm: SensorListViewModel
    @Binding var loadingState: loadingState
    
    var body: some View {
        NavigationView{
            VStack{
                if favorites.isEmpty{
                    VStack{
                        Spacer()
                        Text("no Favorites").font(.largeTitle).foregroundColor(.gray)
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
                                    destination: SensorOverView(sensor: sensor),
                                    label: {
                                        SensorScrollItem(sensor: sensor, region: MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: sensor.latitude!, longitude: sensor.longitude!), span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)))
                                    }).buttonStyle(PlainButtonStyle())
                                    
                                }
                            }
                        }
                    case .error:
                        ErrorView()
                    }
                }
                }
            }.navigationTitle("Favorites")
        }
    }
}

struct FavoritesView_Previews: PreviewProvider {
    static var previews: some View {
        FavoritesView(sensorsVm: SensorListViewModel(), loadingState: .constant(.loaded))
    }
}
