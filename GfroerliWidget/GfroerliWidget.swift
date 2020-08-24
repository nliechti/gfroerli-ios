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
    
    func snapshot(with context: Context, completion: @escaping (Entry) -> ()) {
        
        let entry = SensorEntry(name: "Zürich", temp: 22.0)
        completion(entry)
    }
    func timeline(with context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        getData{ (modelData) in
            
            let entry = SensorEntry(name: (modelData.first?.device_name!)!, temp: (modelData.first?.last_measurement!.temperature!)!)
            completion(Timeline(entries: [entry], policy: .atEnd))
        }
        

    }
    func placeholder(in context: Context) -> SensorEntry {
        let entry = SensorEntry(name: "Zürich", temp: 22.0)
        return entry
    }
    
    
    
}

func getData(completion: @escaping ([Sensor])-> ()){
    
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
            
            completion(jsonData)
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
            HStack{
                Spacer()
                Text(String(format: "%.1f", entry.temp)+"°")
                    .foregroundColor(.white)
            }
                Spacer()
    
                
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
        }
    }
}


struct Sensor: Codable, Identifiable {
    let id : Int?
    let device_name : String?
    let caption : String?
    let latitude : Double?
    let longitude : Double?
    let sponsor_id : Int?
    let measurement_ids : [Int]?
    let created_at : String?
    let updated_at : String?
    let last_measurement : Measurement?
    let url : String?

    enum CodingKeys: String, CodingKey {

        case id = "id"
        case device_name = "device_name"
        case caption = "caption"
        case latitude = "latitude"
        case longitude = "longitude"
        case sponsor_id = "sponsor_id"
        case measurement_ids = "measurement_ids"
        case created_at = "created_at"
        case updated_at = "updated_at"
        case last_measurement = "last_measurement"
        case url = "url"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(Int.self, forKey: .id)
        device_name = try values.decodeIfPresent(String.self, forKey: .device_name)
        caption = try values.decodeIfPresent(String.self, forKey: .caption)
        latitude = try values.decodeIfPresent(Double.self, forKey: .latitude)
        longitude = try values.decodeIfPresent(Double.self, forKey: .longitude)
        sponsor_id = try values.decodeIfPresent(Int.self, forKey: .sponsor_id)
        measurement_ids = try values.decodeIfPresent([Int].self, forKey: .measurement_ids)
        created_at = try values.decodeIfPresent(String.self, forKey: .created_at)
        updated_at = try values.decodeIfPresent(String.self, forKey: .updated_at)
        last_measurement = try values.decodeIfPresent(Measurement.self, forKey: .last_measurement)
        url = try values.decodeIfPresent(String.self, forKey: .url)
    }

}


struct Measurement : Codable {
    let id : Int?
    let temperature : Double?
    let custom_attributes : String?
    let sensor_id : Int?
    let created_at : String?
    let updated_at : String?

    enum CodingKeys: String, CodingKey {

        case id = "id"
        case temperature = "temperature"
        case custom_attributes = "custom_attributes"
        case sensor_id = "sensor_id"
        case created_at = "created_at"
        case updated_at = "updated_at"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(Int.self, forKey: .id)
        temperature = try Double(values.decodeIfPresent(String.self, forKey: .temperature)!)
        custom_attributes = try values.decodeIfPresent(String.self, forKey: .custom_attributes)
        sensor_id = try values.decodeIfPresent(Int.self, forKey: .sensor_id)
        created_at = try values.decodeIfPresent(String.self, forKey: .created_at)
        updated_at = try values.decodeIfPresent(String.self, forKey: .updated_at)
    }

}


