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
            VStack{
                SensorOverviewLastMeasurementView(sensor: sensor)
                    .fixedSize(horizontal: false, vertical: true)
                    .background(Color.secondarySystemGroupedBackground)
                    .cornerRadius(15)
                    .padding(.bottom)
                    .padding(.horizontal)
                SensorOverViewGraph(sensorID: sensor.id!)
                    .frame(minHeight: 400)
                    .background(Color.secondarySystemGroupedBackground)
                    .cornerRadius(15)
                    .padding(.bottom)
                    .padding(.horizontal)
                SensorOverviewMap(inSensor: sensor)
                    .frame(minHeight: 400)
                    .background(Color.secondarySystemGroupedBackground)
                    .cornerRadius(15)
                    .padding(.bottom)
                    .padding(.horizontal)
                SensorOverviewSponsorView(sensor: $sensor)
                    .fixedSize(horizontal: false, vertical: true)
                    .background(Color.secondarySystemGroupedBackground)
                    .cornerRadius(15)
                    .padding(.horizontal)
                
            }
            
        }
        
        .onAppear {
            favorites  = UserDefaults(suiteName: "group.ch.gfroerli")?.array(forKey: "favoritesIDs") as? [Int] ?? [Int]()
            isFav = favorites.contains(sensor.id!)
        }.navigationTitle(Text(sensor.device_name!))
        .background(Color.systemGroupedBackground.ignoresSafeArea())
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
