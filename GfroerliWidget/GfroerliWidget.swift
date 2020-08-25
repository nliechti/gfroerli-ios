//
//  GfroerliWidget.swift
//  GfroerliWidget
//
//  Created by Marc Kramer on 24.08.20.
//

import WidgetKit
import SwiftUI
import Combine

struct SensorEntry: TimelineEntry{
    var date: Date = Date()
    var name: String
    var temp: Double
}

struct Provider: TimelineProvider {
    typealias Entry = SensorEntry
    @AppStorage("widgetSensorID", store: UserDefaults(suiteName: "group.ch.gfroerli.gfroerli")) var widgetSensorID: Int = -1

    
    func snapshot(with context: Context, completion: @escaping (Entry) -> ()) {
        
        let entry = SensorEntry(name: "Zürich", temp: 22.0)
        completion(entry)
    }
    func timeline(with context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var date = Date()
        let update = Calendar.current.date(byAdding: .minute,value: 30, to: date)
        getData(id: widgetSensorID){ (modelData) in
            let entry = SensorEntry(name: (modelData.name), temp: (modelData.temp))
            completion(Timeline(entries: [entry], policy: .after(update!)))

            }

        }
        
    func placeholder(in context: Context) -> SensorEntry {
        let entry = SensorEntry(name: "Zürich", temp: 22.0)
        return entry
    }
    
    
    
}

func getData(id: Int,completion: @escaping (SensorEntry)-> ()){
    
    var request = URLRequest(url: URL(string: "https://watertemp-api.coredump.ch/api/sensors")!)
    request.setValue("Bearer XTZA6H0Hg2f02bzVefmVlr8fIJMy2FGCJ0LlDlejj2Pi0i1JvZiL0Ycv1t6JoZzD", forHTTPHeaderField: "Authorization")
    request.httpMethod = "GET"
    
    let session = URLSession.shared
    
    session.dataTask(with: request) { (data, _, err) in
        
        if err != nil{
            
            print(err!.localizedDescription)
            
            return
        }
        
        do{
            
            let jsonData = try JSONDecoder().decode([Sensor].self, from: data!)
            
            for sensor in jsonData{
                if sensor.id! == id{
                    completion(SensorEntry( name: sensor.device_name!, temp: sensor.last_measurement!.temperature!))
                }else{
                    completion(SensorEntry(name: "Configure in Settings", temp: 0.0))
                }
                
            }
            
        }
        catch{
            
            print(error.localizedDescription)
        }
    }.resume()
}



struct WidgetView:View {
    let entry: Provider.Entry
    
    var body: some View{
        ZStack {
            Wave(strength: 7, frequency: 8, offset: -30).fill(LinearGradient(gradient: Gradient(colors: [ Color.blue,Color("GfroerliBlue")]), startPoint: .bottom, endPoint: .top)).offset(y:30)
            Wave(strength: 10, frequency: 10, offset: -40).fill(Color("GfroerliLightBlue").opacity(0.3)).offset(y:20).rotation3DEffect(
                .degrees(180),
                axis: (x: 0.0, y: 1.0, z: 0.0),
                anchor: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/,
                anchorZ: /*@START_MENU_TOKEN@*/0.0/*@END_MENU_TOKEN@*/,
                perspective: /*@START_MENU_TOKEN@*/1.0/*@END_MENU_TOKEN@*/
            )

            HStack{
                Image(systemName: "thermometer").font(.system(size: 56.0)).foregroundColor(.red).frame(width: 50, height: 50).offset(y:40)
                Spacer()
            }
            VStack{
            HStack {
                Text(entry.name)
                    .foregroundColor(.white)

                Spacer()
            }.padding(.bottom,4)
                if entry.temp != 0.0{
            HStack{
                Spacer()
                Text(String(format: "%.1f", entry.temp)+"°")
                    .foregroundColor(.white)
            }
                }
                Spacer()
    
                Text(entry.date, style: .time)
            }.padding()
        }.frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color("GfroerliDarkBlue"))
        
    }
}




@main
struct GfroerliWidget: Widget {
    private let kind = "GfroerliWidget"
    var body: some WidgetConfiguration{
        StaticConfiguration(kind: kind, provider: Provider()){entry in
            WidgetView(entry: entry)
        }.supportedFamilies([.systemSmall,.systemMedium])
    }
}





