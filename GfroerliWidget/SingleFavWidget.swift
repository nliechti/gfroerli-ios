//
//  GfroerliWidget.swift
//  GfroerliWidget
//
//  Created by Marc Kramer on 24.08.20.
//

import WidgetKit
import SwiftUI
import Combine

struct SingleSensorEntry: TimelineEntry{
    var date: Date = Date()
    var name: String
    var temp: Double
    var data: [Double]
}



struct SingleProvider: TimelineProvider {
    typealias Entry = SingleSensorEntry
    @AppStorage("widgetSensorID", store: UserDefaults(suiteName: "group.ch.test")) var widgetSensorID: Int = -1
    
    
    func getSnapshot(in context: Context, completion: @escaping (Entry) -> ()) {
        
        let entry = SingleSensorEntry(name: "Zürich", temp: 22.0, data: [22.0,22.5,22.5,20.3,29.8])
        completion(entry)
    }
    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        print("timeline requested")
        
        var date = Date()
        let update = Calendar.current.date(byAdding: .second,value: 30, to: date)
        getSingleSensor(id: 1) { (sens) in
            completion(Timeline(entries: [sens], policy: .after(update!)))
        }
        
    }
    
    func placeholder(in context: Context) -> SingleSensorEntry {
        let entry = SingleSensorEntry(name: "Zürich", temp: 22.0,data:[22.0,22.5,22.5,20.3,29.8])
        return entry
    }
    
    
    
}



func getMeasurements(id: Int,completion: @escaping ([Double]) -> ()){
    
    let df = DateFormatter()
    df.dateFormat = "yyyy-MM-ddThh:mm:ss"
    let now = df.string(from: Calendar.current.date(byAdding: .day, value:-1, to:Date())!)
    var request = URLRequest(url: URL(string: "https://watertemp-api.coredump.ch/api/measurements?id="+String(id)+"&created_after=\(now)")!)
    var request2 = URLRequest(url: URL(string: "http://10.99.0.57:3000/api/measurements?id="+String(id)+"&created_after=\(now)")!)
    
    request.setValue("Bearer XTZA6H0Hg2f02bzVefmVlr8fIJMy2FGCJ0LlDlejj2Pi0i1JvZiL0Ycv1t6JoZzD", forHTTPHeaderField: "Authorization")
    request.httpMethod = "GET"
    let session = URLSession.shared
    
    session.dataTask(with: request) { (data, _, err) in
        var values = [Double]()
        if err != nil{
            
            print(err!.localizedDescription)
            
            return
        }
        
        do{
            
            let jsonData = try JSONDecoder().decode([Measurement].self, from: data!)
            
            for meas in jsonData{
                values.append(meas.temperature!)
            }
                completion(values)
            
            
            
            
        }
        catch{
            
            print(error.localizedDescription)
        }
    }.resume()
}

func getSingleSensor(id: Int,completion: @escaping (SingleSensorEntry) -> ()){
    
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
                    getMeasurements(id: id) { (data) in
                        completion(SingleSensorEntry(name: sensor.device_name!, temp: sensor.last_measurement!.temperature!, data: data))
                    }
                    
                }else{
                    completion(SingleSensorEntry(name: "no", temp: 0.0, data: [Double]()))
                }
                
            }
            
        }
        catch{
            
            print(error.localizedDescription)
        }
    }.resume()
}


struct SingleFavWidgetViewSmall:View {
    let entry: SingleProvider.Entry
    @Environment(\.widgetFamily) var size
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
                
                
            }.padding()
        }
        .background(Color("GfroerliDarkBlue"))
        .widgetURL(URL(string: "ch.coredump.gfroerli://settings/widgetSettings"))
    }
}

struct SingleFavWidgetViewMedium:View {
    let entry: SingleProvider.Entry
    @Environment(\.widgetFamily) var size
    var body: some View{
        GeometryReader{ geo in
            ZStack(alignment: .center){
                Wave(strength: 7, frequency: 8, offset: -30).fill(LinearGradient(gradient: Gradient(colors: [ Color.blue,Color("GfroerliBlue")]), startPoint: .bottom, endPoint: .top)).offset(y:30)
                Wave(strength: 10, frequency: 10, offset: -40).fill(Color("GfroerliLightBlue").opacity(0.3)).offset(y:20).rotation3DEffect(
                    .degrees(180),
                    axis: (x: 0.0, y: 1.0, z: 0.0),
                    anchor: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/,
                    anchorZ: /*@START_MENU_TOKEN@*/0.0/*@END_MENU_TOKEN@*/,
                    perspective: /*@START_MENU_TOKEN@*/1.0/*@END_MENU_TOKEN@*/
                )
                
                VStack{
                    HStack {
                        Text(entry.name)
                            .font(.system(size: 15))
                            .foregroundColor(.white)
                        
                        if entry.temp != 0.0{
                            Spacer()
                            Text(String(format: "%.1f", entry.temp)+"°")
                                .foregroundColor(.white)
                                .font(.system(size: 15))
                        }
                        Image(systemName: "thermometer").foregroundColor(.red).font(.system(size: 15))
                    }.padding([.horizontal, .top])
                    HStack{
                    Text("Last 24h:").foregroundColor(.white).font(.system(size: 8))
                     Spacer()
                    }.padding(.horizontal)
                    LineView(data: entry.data).padding(9).background(Color.white).cornerRadius(15).padding([.horizontal,.bottom],9)
                        
                    
                    
                }
            }
            .background(Color("GfroerliDarkBlue"))
        }
    }
}




struct smallWidgetView: View{
    @Environment(\.widgetFamily) var size
    let entry: SingleProvider.Entry
    var body: some View{
        switch size{
        case .systemSmall:
            SingleFavWidgetViewSmall(entry: entry)
        default:
            SingleFavWidgetViewMedium(entry: entry)
        }
    }
    
}

struct SingleFavWidget: Widget {
    @Environment(\.widgetFamily) var size
    
    var body: some WidgetConfiguration{
        StaticConfiguration(kind: "SingleFavWidget", provider: SingleProvider()){entry in
            smallWidgetView(entry: entry)
        }.supportedFamilies([.systemSmall, .systemMedium])
        .configurationDisplayName("Single Sensor")
        .description("Shows the latest Measurement of a single Sensor")
    }
}


struct GfroerliWidget_Previews: PreviewProvider {
    static var previews: some View {
        Group{
            smallWidgetView(entry: SingleSensorEntry(name: "test", temp: 20.0, data: [30.0])).previewContext(WidgetPreviewContext(family: .systemSmall))
        }
    }
}
