//
//  SingleSensorWidget.swift
//  Gfror.li
//
//  Created by Marc on 29.01.21.
//
import WidgetKit
import SwiftUI
import Combine


struct SingleSensorEntry: TimelineEntry{
    var date: Date = Date()
    var name: String
    var temp: Double
    var id: Int
}

struct SingleSensorLoader{
    
    static func load(id: Int, completion: @escaping(Result<Sensor,Error>) -> Void) {
        var url = URLRequest(url: URL(string: "https://watertemp-api.coredump.ch/api/mobile_app/sensors/\(id)")!)
        url.setValue("Bearer XTZA6H0Hg2f02bzVefmVlr8fIJMy2FGCJ0LlDlejj2Pi0i1JvZiL0Ycv1t6JoZzD", forHTTPHeaderField: "Authorization")
        url.httpMethod = "GET"
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            DispatchQueue.main.async {
                do {
                    if let data = data {
                        // success: convert to  Sensors
                        let jsonDecoder = JSONDecoder()
                        let sensor = try jsonDecoder.decode(Sensor.self, from: data)
                        completion(.success(sensor))
                        
                    } else {
                        // other cases
                        completion(.failure(error!))
                    }
                    // decoding failed
                }catch{
                    completion(.failure(error))
                }
            }
        }.resume()
    }
    
}

struct SingleSensorTimeline: TimelineProvider{
    
    typealias Entry = SingleSensorEntry
    
    @AppStorage("widgetSensorID", store: UserDefaults(suiteName: "group.ch.gfroerli")) var widgetSensorID: Int = -1
    
    func placeholder(in context: Context) -> SingleSensorEntry {
        let entry = SingleSensorEntry(date: Date(), name: "test", temp: 22.0, id: 0)
        return entry
    }
    
    public func getSnapshot(in context: Context, completion: @escaping(SingleSensorEntry) -> ()) {
        
        SingleSensorLoader.load(id: 1) { (result) in
            let sensor: Sensor
            if case .success(let loadedSensor) = result {
                sensor = loadedSensor
            } else {
                sensor = Sensor(id: 0, device_name: "Error while fetching data", caption: nil, latitude: nil, longitude: nil, sponsor_id: nil, created_at: nil, latestTemp: 0.0, maxTemp: nil, minTemp: nil, avgTemp: nil)
            }
            let entry = SingleSensorEntry(date: Date(), name: sensor.device_name, temp: sensor.latestTemp!, id: sensor.id)
            completion(entry)
        }
    }
    
    
    public func getTimeline(in context: Context, completion: @escaping (Timeline<SingleSensorEntry>) -> ()) {
        
        let currentDate = Date()
        let refreshDate = Calendar.current.date(byAdding: .minute, value: 15, to: currentDate)!

        SingleSensorLoader.load(id: widgetSensorID) { (result) in
            let sensor: Sensor
            
            if case .success(let loadedSensor) = result {
                sensor = loadedSensor
            }else if widgetSensorID == -1{
                sensor = Sensor(id: 0, device_name: "Tap to configure Sensor", caption: nil, latitude: nil, longitude: nil, sponsor_id: nil, created_at: nil, latestTemp: 0.0, maxTemp: nil, minTemp: nil, avgTemp: nil)
            } else {
                sensor = Sensor(id: 0, device_name: "Error while fetching data", caption: nil, latitude: nil, longitude: nil, sponsor_id: nil, created_at: nil, latestTemp: 0.0, maxTemp: nil, minTemp: nil, avgTemp: nil)
            }
            
            let entry = SingleSensorEntry(date: Date(), name: sensor.device_name, temp: sensor.latestTemp!, id: sensor.id)
            let timeline = Timeline(entries: [entry], policy: .after(refreshDate))
            completion(timeline)
        }
    }
}

struct PlaceholderGraphView : View {
    var body: some View {
        ZStack {
            Wave(strength: 10, frequency: 8, offset: -300).fill(LinearGradient(gradient: Gradient(colors: [ Color.blue.opacity(0.6),Color("GfroerliLightBlue").opacity(0.4)]), startPoint: .leading, endPoint: .trailing)).offset(y:40)
            Wave(strength: 10, frequency: 10, offset: -10.0).fill(LinearGradient(gradient: Gradient(colors: [ Color("GfroerliLightBlue").opacity(0.5),Color.blue.opacity(0.4)]), startPoint: .trailing, endPoint: .leading)).offset(x:0,y:20).rotation3DEffect(
                .degrees(180),
                axis: (x: 0.0, y: 1.0, z: 0.0),
                anchor: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/,
                anchorZ: /*@START_MENU_TOKEN@*/0.0/*@END_MENU_TOKEN@*/,
                perspective: /*@START_MENU_TOKEN@*/1.0/*@END_MENU_TOKEN@*/
            )
        }
        .background(Color("GfroerliDarkBlue"))
    }
}
struct SingleSensorWidgetView: View {
    let entry: SingleSensorEntry
    @Environment(\.widgetFamily) var size
    var body: some View{
        ZStack {
            Wave(strength: 10, frequency: 8, offset: -300).fill(LinearGradient(gradient: Gradient(colors: [ Color.blue.opacity(0.6),Color("GfroerliLightBlue").opacity(0.4)]), startPoint: .leading, endPoint: .trailing)).offset(y:40)
            Wave(strength: 10, frequency: 10, offset: -10.0).fill(LinearGradient(gradient: Gradient(colors: [ Color("GfroerliLightBlue").opacity(0.5),Color.blue.opacity(0.4)]), startPoint: .trailing, endPoint: .leading)).offset(x:0,y:20).rotation3DEffect(
                .degrees(180),
                axis: (x: 0.0, y: 1.0, z: 0.0),
                anchor: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/,
                anchorZ: /*@START_MENU_TOKEN@*/0.0/*@END_MENU_TOKEN@*/,
                perspective: /*@START_MENU_TOKEN@*/1.0/*@END_MENU_TOKEN@*/
            )
            HStack{
                Image(systemName: "thermometer").font(.system(size: 40.0)).foregroundColor(.red).frame(width: 50, height: 50).offset(y:40)
                Spacer()
            }
            VStack{
                if entry.temp != 0.0{
                HStack {
                    Text(entry.name)
                        .foregroundColor(.white)
                    
                    Spacer()
                }.padding(.bottom,4)
                
                    HStack{
                        Spacer()
                        Text(String(format: "%.1f", entry.temp)+"°")
                            .font(.title2)
                            .foregroundColor(.white)
                    }
                }else{
                    HStack{
                        Text(entry.name)
                        .foregroundColor(.white)
                        Spacer()
                    }
                }
                Spacer()
                
                
            }.padding()
        }
        .background(Color("GfroerliDarkBlue"))
        .widgetURL(entry.temp != 0.0 ? URL(string: "ch.coredump.gfroerli://home/\(entry.id)") : URL(string: "ch.coredump.gfroerli://settings/widgetSettings"))
    }
}

struct SingleSensorWidget: Widget {
    private let kind: String = "SingleSensorWidget"
    
    public var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: SingleSensorTimeline(), content: { entry  in
            SingleSensorWidgetView(entry: entry)
        })
        .configurationDisplayName("Single Sensor")
        .description("Shows the latest temperature of a Sensor.")
        .supportedFamilies([.systemSmall])
    }
}

struct SingleSensorGraphWidget_Previews: PreviewProvider {
    static var previews: some View {
        EmptyView()
    }
}
