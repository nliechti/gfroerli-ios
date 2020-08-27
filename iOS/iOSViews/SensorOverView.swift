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
    
    @State var favorites  = UserDefaults(suiteName: "group.ch.gfroerli.gfroerli")?.array(forKey: "favoritesIDs") as? [Int] ?? [Int]()
    var body: some View {
        
        VStack(alignment:.leading){
            
            VStack(alignment: .leading){
                HStack {
                    Text("Last Measurement").font(.headline)
                    Spacer()
                }
                Text(String(format: "%.1f", sensor.last_measurement!.temperature!)+"°" ?? "Unavailable").font(.system(size: 50))
                HStack {
                    Text(createGoodDate(string: sensor.last_measurement!.created_at!), style: .time)
                    Text(createGoodDate(string: sensor.last_measurement!.created_at!), style: .date)
                }
                HStack {
                    Text("History").font(.headline)
                    Spacer()
                }
                HStack {
                    Text("Description").font(.headline)
                    Spacer()
                }
                Text(sensor.caption!)
                HStack {
                    Text("Sponsor").font(.headline)
                    Spacer()
                }
            }
            Text("TBD")
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
    func createGoodDate(string: String)->Date{
        print(string)
        var newDate = string
        newDate.removeLast(5)
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX") // set locale to reliable US_POSIX
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        let date = dateFormatter.date(from:newDate)!
        return date
    }
}

struct SensorOverView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView{
        SensorOverView(sensor: testSensor)
        }
    }
}
