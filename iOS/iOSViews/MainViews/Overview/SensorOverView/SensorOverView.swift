//
//  SensorOverView.swift
//  iOS
//
//  Created by Marc Kramer on 22.08.20.
//

import SwiftUI

struct SensorOverView: View {
    
    @StateObject var sensorVM = SingleSensorViewModel()
    @State var isFav = false
    @State var favorites  = UserDefaults(suiteName: "group.ch.gfroerli")?.array(forKey: "favoritesIDs") as? [Int] ?? [Int]()
    
    var id : Int
    
    var body: some View {
            AsyncContentView(source: sensorVM) { sensor in
                ScrollView{
                    VStack{
                        SensorOverviewLastMeasurementView(sensor: sensor)
                            .boxStyle()
                        
                        SensorOverViewGraph(sensorID: id)
                            .boxStyle()
                        
                        SensorOverviewMap(inSensor: sensor)
                            .boxStyle()
                        
                        SensorOverviewSponsorView(sensor: sensor)
                            .boxStyle()
                        
                    }
                    .padding(.vertical)
                }
                .navigationBarTitle(sensor.device_name,displayMode: .inline)
            }
            .background(Color.systemGroupedBackground.ignoresSafeArea())
            .toolbar{favoriteToolBarItem}
        .background(Color.systemGroupedBackground.ignoresSafeArea()).onAppear(perform: {
            sensorVM.id = id
            sensorVM.load()
            favorites  = UserDefaults(suiteName: "group.ch.gfroerli")?.array(forKey: "favoritesIDs") as? [Int] ?? [Int]()
            isFav = favorites.contains(id)
        })
    }
    
    var favoriteToolBarItem: some ToolbarContent {
        ToolbarItem(placement: .navigationBarTrailing) {
            HStack{
                Button {
                    sensorVM.load()
                } label: {
                    Image(systemName:"arrow.clockwise")
                        .imageScale(.large)
                }
                
                Button {
                    isFav ? removeFav() : makeFav()
                    UserDefaults(suiteName: "group.ch.gfroerli")?.set(favorites, forKey: "favoritesIDs")
                } label: {
                    Image(systemName: isFav ? "star.fill" : "star")
                        .foregroundColor(isFav ? .yellow : .none)
                        .imageScale(.large)
                }}
        }
    }
    
    func makeFav(){
        favorites.append(id)
        isFav = true
        UserDefaults(suiteName: "group.ch.gfroerli")?.set(favorites, forKey: "favoritesIDs")
    }
    
    func removeFav(){
        favorites.removeFirst(id)
        isFav=false
        UserDefaults(suiteName: "group.ch.gfroerli")?.set(favorites, forKey: "favoritesIDs")
    }
}

struct SensorOverView_Previews: PreviewProvider {
    static var previews: some View {
        SensorOverView(id: 1).makePreViewModifier()
    }
}
