//
//  SensorOverView.swift
//  iOS
//
//  Created by Marc Kramer on 22.08.20.
//

import SwiftUI

struct SensorOverView: View {
    
    @State var sensor: Sensor
    @State var isFav = false
    @State var favorites  = UserDefaults(suiteName: "group.ch.gfroerli")?.array(forKey: "favoritesIDs") as? [Int] ?? [Int]()
    
    var body: some View {
        ScrollView{
            VStack(alignment:.leading){
                SensorOverviewLastMeasurementView(sensor: sensor).padding(.bottom)
                SensorOverViewGraph(sensorID: sensor.id!).frame(height: 300).padding(.bottom)
                SensorOverviewSponsorView(sensor: $sensor)
            }.padding(.horizontal)
        }
        
        .onAppear {
            favorites  = UserDefaults(suiteName: "group.ch.gfroerli")?.array(forKey: "favoritesIDs") as? [Int] ?? [Int]()
            isFav = favorites.contains(sensor.id!)
        }.navigationTitle(Text(sensor.device_name!))
        .navigationBarItems(trailing:
                                Button {
                                    isFav ? removeFav() : makeFav()
                                    UserDefaults(suiteName: "group.ch.gfroerli")?.set(favorites, forKey: "favoritesIDs")
                                } label: {
                                    Image(systemName: isFav ? "star.fill" : "star")
                                        .foregroundColor(isFav ? .yellow : .none)
                                })
    }
    
    
    func makeFav(){
        favorites.append(sensor.id!)
        isFav = true
        UserDefaults(suiteName: "group.ch.gfroerli")?.set(favorites, forKey: "favoritesIDs")
        
    }
    func removeFav(){
        favorites.removeFirst(sensor.id!)
        isFav=false
        UserDefaults(suiteName: "group.ch.gfroerli")?.set(favorites, forKey: "favoritesIDs")
    }
    
    
}

struct SensorOverView_Previews: PreviewProvider {
    static var previews: some View {
        SensorOverView(sensor:testSensor).makePreViewModifier()
    }
}
