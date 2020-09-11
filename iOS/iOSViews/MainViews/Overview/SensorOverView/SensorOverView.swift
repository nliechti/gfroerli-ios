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
    @State var pickerSelection = 0
    @State var pickerOptions = ["Day", "Week", "Month"]
    
    @State var favorites  = UserDefaults(suiteName: "group.ch.gfroerli.gfroerli")?.array(forKey: "favoritesIDs") as? [Int] ?? [Int]()
    var body: some View {
        
        VStack(alignment:.leading){
            SensorOverviewLastMeasurementView(sensor: $sensor).padding(.bottom)
            SensorOverViewGraph()
            SensorOverviewSponsorView(sensor: $sensor)
            Spacer()
        }.padding()
        .onAppear {
            isFav = favorites.contains(sensor.id!)
        }.navigationTitle(Text(sensor.device_name!))
        .navigationBarItems(trailing:
                                Button {
                                    isFav ? removeFav() : makeFav()
                                    UserDefaults(suiteName: "group.ch.gfroerli.gfroerli")?.set(favorites, forKey: "favoritesIDs")
                                } label: {
                                    Image(systemName: isFav ? "star.fill" : "star")
                                        .foregroundColor(isFav ? .yellow : .none)
                                })
    }
    
    
    func makeFav(){
        favorites.append(sensor.id!)
        isFav = true
    }
    func removeFav(){
        favorites.removeFirst(sensor.id!)
        isFav=false
    }
    
    
}

struct SensorOverView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView{
            SensorOverView(sensor: testSensor)
        }
    }
}






