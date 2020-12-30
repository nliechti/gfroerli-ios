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
    var data: [DailyAggregation]
    var id: Int
}



struct SingleProvider: TimelineProvider {
    typealias Entry = SingleSensorEntry
    var singleSensVM = SingleSensorViewModel()
    var aggVM = TempAggregationsViewModel()
    @AppStorage("widgetSensorID", store: UserDefaults(suiteName: "group.ch.gfroerli")) var widgetSensorID: Int = -1
    
    
    func getSnapshot(in context: Context, completion: @escaping (Entry) -> ()) {
        
        let entry = SingleSensorEntry(name: "Zürich", temp: 22.0, data: [DailyAggregation(id: "1", date: "0000-00-00", maxTemp: 0.0, minTemp: 0.0, avgTemp: 10.0),DailyAggregation(id: "1", date: "0000-00-00",  maxTemp: 0.0, minTemp: 0.0, avgTemp: 10.0),DailyAggregation(id: "1", date: "0000-00-00",  maxTemp: 0.0, minTemp: 0.0, avgTemp: 20.0)], id: 0)
        completion(entry)
    }
    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var data = [DailyAggregation]()
        aggVM.loadAggregationsWeek(sensorID: widgetSensorID) { (result) in
            switch result {
            case .success(let str):
                data = aggVM.dataWeek
            case .failure(let error):
                switch error {
                default:
                    data = [DailyAggregation(id: "1", date: "0000-00-00", maxTemp: 0.0, minTemp: 0.0, avgTemp: 0.0)]
                }
            }
        }
        
        
        singleSensVM.getSensor(id: widgetSensorID) { (result) in
            switch result {
            case .success(let str):
                completion(Timeline(entries: [SingleSensorEntry(name: singleSensVM.sensor?.device_name ?? "A", temp: singleSensVM.sensor?.latestTemp! ?? 0.0 , data: data, id: singleSensVM.sensor?.id! ?? 0)], policy: .after(Calendar.current.date(byAdding: .second,value: 5, to: Date())!)))
            case .failure(let error):
                switch error {
                default:
                    completion(Timeline(entries: [SingleSensorEntry(name: "A", temp: 0.0 , data: data, id: 0)], policy: .after(Calendar.current.date(byAdding: .second,value: 5, to: Date())!)))
                }
            }
            
        }
        
        print(singleSensVM.sensor)
        

            
    }
    
    func placeholder(in context: Context) -> SingleSensorEntry {
        let entry = SingleSensorEntry(name: "Zürich", temp: 22.0, data: [DailyAggregation(id: "1", date: "0000-00-00",  maxTemp: 0.0, minTemp: 0.0, avgTemp: 10.0),DailyAggregation(id: "1", date: "0000-00-00",  maxTemp: 0.0, minTemp: 0.0, avgTemp: 10.0),DailyAggregation(id: "1", date: "0000-00-00", maxTemp: 0.0, minTemp: 0.0, avgTemp: 20.0)], id: 0)
        return entry
    }
        
}







struct SingleFavWidgetViewSmall:View {
    let entry: SingleProvider.Entry
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
                    Text("Tap to configure Sensor")
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

struct SingleFavWidgetViewMedium:View {
    let entry: SingleProvider.Entry
    @Environment(\.widgetFamily) var size
    var body: some View{
        GeometryReader{ geo in
            ZStack(alignment: .center){
                Wave(strength: 14, frequency: 14, offset: -300).fill(LinearGradient(gradient: Gradient(colors: [ Color.blue.opacity(0.6),Color("GfroerliLightBlue").opacity(0.4)]), startPoint: .leading, endPoint: .trailing)).offset(y:30)
                Wave(strength: 10, frequency: 12, offset: -10.0).fill(LinearGradient(gradient: Gradient(colors: [ Color("GfroerliLightBlue").opacity(0.5),Color.blue.opacity(0.4)]), startPoint: .trailing, endPoint: .leading)).offset(x:0,y:20).rotation3DEffect(
                    .degrees(180),
                    axis: (x: 0.0, y: 1.0, z: 0.0),
                    anchor: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/,
                    anchorZ: /*@START_MENU_TOKEN@*/0.0/*@END_MENU_TOKEN@*/,
                    perspective: /*@START_MENU_TOKEN@*/1.0/*@END_MENU_TOKEN@*/
                )
                
                VStack{
                    HStack {
                        if entry.temp != 0.0 {
                            Text(entry.name)
                                .font(.system(size: 20))
                                .foregroundColor(.white)
                        } else {
                            Text("Tap to configure Sensor")
                                .font(.system(size: 20))
                                .foregroundColor(.white)
                        }
                        Spacer()
                        if entry.temp != 0.0{
                            
                            Text(String(format: "%.1f", entry.temp)+"°")
                                .foregroundColor(.white)
                                .font(.system(size: 20))
                        }
                        
                        Image(systemName: "thermometer").foregroundColor(.red).font(.system(size: 20))
                    }
                    
                    
                    if entry.temp != 0.0{
                        HStack{
                            Text("Last Week:").foregroundColor(.white).font(.system(size: 13))
                         Spacer()
                        }
                        GeometryReader{ g in
                            DailyChartView(showMax: .constant(false), showMin: .constant(false), showAvg: .constant(true), showCircles: .constant(false),avgColor: .white, daySpan: .week, data: entry.data, frame: g.frame(in: .local)).colorScheme(.dark)
                        }
                        Divider().hidden()
                    }else{
                        Spacer()
                    }
                    
                }.padding()
            }
            .background(Color("GfroerliDarkBlue"))
            .widgetURL(entry.temp != 0.0 ? URL(string: "ch.coredump.gfroerli://home/\(entry.id)") : URL(string: "ch.coredump.gfroerli://settings/widgetSettings"))
            .preferredColorScheme(.dark)
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
            /*smallWidgetView(entry: SingleSensorEntry(name: "HSR Badewiese", temp: 20.0, data: [30.0])).previewContext(WidgetPreviewContext(family: .systemSmall))
            smallWidgetView(entry: SingleSensorEntry(name: "Tap to configure Sensor", temp: 0.0, data: [0.0])).previewContext(WidgetPreviewContext(family: .systemSmall))
                .preferredColorScheme(.dark)
            smallWidgetView(entry: SingleSensorEntry(name: "HSR Badewiese", temp: 20.0, data: [20.0,15.0,30.0])).previewContext(WidgetPreviewContext(family: .systemMedium))
            smallWidgetView(entry: SingleSensorEntry(name: "Tap to configure Sensor", temp: 0.0, data: [0.0]))
                .preferredColorScheme(.dark)
                .previewContext(WidgetPreviewContext(family: .systemMedium))
                */
            EmptyView()
        }
    }
}

