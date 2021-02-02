//
//  SingleSensorGraphWidget.swift
//  iOS
//
//  Created by Marc on 29.01.21.
//

import WidgetKit
import SwiftUI
import Combine


struct SingleSensorGraphEntry: TimelineEntry{
    var date: Date = Date()
    var name: String
    var temp: Double
    var hourlyAggs: [HourlyAggregation?]
    var dailyAggs: [DailyAggregation]
    var id: Int
    var graphSelection: Options = .week
}



struct SingleSensorGraphTimeline: IntentTimelineProvider{
    
    typealias Entry = SingleSensorGraphEntry
    
    @AppStorage("widgetSensorID", store: UserDefaults(suiteName: "group.ch.gfroerli")) var widgetSensorID: Int = -1
    
    func placeholder(in context: Context) -> SingleSensorGraphEntry {
        let entry = SingleSensorGraphEntry(date: Date(), name: "test", temp: 0.0, hourlyAggs: [nil], dailyAggs: [DailyAggregation](), id: 0, graphSelection: .day)
        return entry
    }
    
    public func getSnapshot(for configuration: ConfigurationIntent,in context: Context, completion: @escaping(SingleSensorGraphEntry) -> ()) {
        
        SingleSensorGraphLoader.loadSens(id: 1) { (result) in
            let sensor: Sensor
            if case .success(let loadedSensor) = result {
                sensor = loadedSensor
            } else {
                sensor = Sensor(id: 0, device_name: "Error while fetching data", caption: nil, latitude: nil, longitude: nil, sponsor_id: nil, created_at: nil, latestTemp: 0.0, maxTemp: nil, minTemp: nil, avgTemp: nil)
            }
            SingleSensorGraphLoader.loadDailyAggs(id: 1) { (result) in
                let aggs: [HourlyAggregation?]
                if case .success(let loadedAggs) = result {
                    aggs = loadedAggs
                } else {
                    aggs = [nil]
                }
                
                let entry = SingleSensorGraphEntry(date: Date(), name: sensor.device_name, temp: sensor.latestTemp!, hourlyAggs: aggs, dailyAggs: [DailyAggregation](), id: sensor.id, graphSelection: .day)
                completion(entry)
            }
        }
    }
    
    
    public func getTimeline(for configuration: ConfigurationIntent ,in context: Context, completion: @escaping (Timeline<SingleSensorGraphEntry>) -> ()) {
        let currentDate = Date()
        let refreshDate = Calendar.current.date(byAdding: .minute, value: 15, to: currentDate)!
        
        SingleSensorGraphLoader.loadSens(id: widgetSensorID) { (result) in
        
            let sensor: Sensor
            if case .success(let loadedSensor) = result {
                sensor = loadedSensor
            } else {
                sensor = Sensor(id: 0, device_name: "Error while fetching data", caption: nil, latitude: nil, longitude: nil, sponsor_id: nil, created_at: nil, latestTemp: 0.0, maxTemp: nil, minTemp: nil, avgTemp: nil)
            }
            
            if configuration.options == .day{
                SingleSensorGraphLoader.loadDailyAggs(id: widgetSensorID) { (result) in
                    let aggs: [HourlyAggregation?]
                    if case .success(let loadedAggs) = result {
                        aggs = loadedAggs
                    } else {
                        aggs = [nil]
                    }
                    
                    let entry = SingleSensorGraphEntry(date: Date(), name: sensor.device_name, temp: sensor.latestTemp!, hourlyAggs: aggs, dailyAggs: [DailyAggregation](), id: sensor.id, graphSelection: .day)
                    let timeline = Timeline(entries: [entry], policy: .after(refreshDate))
                    completion(timeline)
                }
                
            }else if configuration.options == .month{
                SingleSensorGraphLoader.loadMonthlyAggs(id: widgetSensorID) { (result) in
                    let aggs: [DailyAggregation]
                    if case .success(let loadedAggs) = result {
                        aggs = loadedAggs
                    } else {
                        aggs = [DailyAggregation]()
                    }
                    
                    let entry = SingleSensorGraphEntry(date: Date(), name: sensor.device_name, temp: sensor.latestTemp!, hourlyAggs: [nil], dailyAggs: aggs, id: sensor.id, graphSelection: .month)
                    let timeline = Timeline(entries: [entry], policy: .after(refreshDate))
                    completion(timeline)
                }
            }else{
                SingleSensorGraphLoader.loadWeeklyAggs(id: widgetSensorID) { (result) in
                    let aggs: [DailyAggregation]
                    if case .success(let loadedAggs) = result {
                        aggs = loadedAggs
                    } else {
                        aggs = [DailyAggregation]()
                    }
                    
                    let entry = SingleSensorGraphEntry(date: Date(), name: sensor.device_name, temp: sensor.latestTemp!, hourlyAggs: [nil], dailyAggs: aggs, id: sensor.id, graphSelection: .week)
                    let timeline = Timeline(entries: [entry], policy: .after(refreshDate))
                    completion(timeline)
                }
            }
        }
    }
}

struct PlaceholderView : View {
    var body: some View {
        ZStack {
            ZStack(alignment: .center){
                Wave(strength: 14, frequency: 14, offset: -300).fill(LinearGradient(gradient: Gradient(colors: [ Color.blue.opacity(0.6),Color("GfroerliLightBlue").opacity(0.4)]), startPoint: .leading, endPoint: .trailing)).offset(y:30)
                Wave(strength: 10, frequency: 12, offset: -10.0).fill(LinearGradient(gradient: Gradient(colors: [ Color("GfroerliLightBlue").opacity(0.5),Color.blue.opacity(0.4)]), startPoint: .trailing, endPoint: .leading)).offset(x:0,y:20).rotation3DEffect(
                    .degrees(180),
                    axis: (x: 0.0, y: 1.0, z: 0.0),
                    anchor: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/,
                    anchorZ: /*@START_MENU_TOKEN@*/0.0/*@END_MENU_TOKEN@*/,
                    perspective: /*@START_MENU_TOKEN@*/1.0/*@END_MENU_TOKEN@*/
                )
            }
        }
        .background(Color("GfroerliDarkBlue"))
    }
}
struct SingleSensorGraphWidgetView: View {
    let entry: SingleSensorGraphEntry
    
    
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
                            if entry.graphSelection == .day{
                                Text("Last 24h:").foregroundColor(.white).font(.system(size: 13))

                            }else if entry.graphSelection == .month{
                                Text("Last Month:").foregroundColor(.white).font(.system(size: 13))

                            }else{
                                Text("Last Week:").foregroundColor(.white).font(.system(size: 13))

                            }
                            Spacer()
                        }
                        GeometryReader{ g in
                            if entry.graphSelection == .day{
                                HourlyChartView(showMax: .constant(false), showMin: .constant(false), showAvg: .constant(true), showCircles: .constant(true), data: entry.hourlyAggs, lineWidth: 2, pointSize: 2, frame: g.frame(in: .local), avgColor: .white).colorScheme(.dark)
                            }else if entry.graphSelection == .month{
                                MonthlyChartView(showMax: .constant(false), showMin: .constant(false), showAvg: .constant(true), showCircles: .constant(true), avgColor: .white, daySpan: .month, data: entry.dailyAggs, lineWidth: 2, pointSize: 2, frame: g.frame(in: .local)).colorScheme(.dark)
                            }else{
                                WeeklyChartView(showMax: .constant(false), showMin: .constant(false), showAvg: .constant(true), showCircles: .constant(true), avgColor: .white, daySpan: .month, data: entry.dailyAggs, lineWidth: 2, pointSize: 2, frame: g.frame(in: .local)).colorScheme(.dark)
                            }
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

struct SingleSensorGraphWidget: Widget {
    private let kind: String = "SingleSensorGraphWidget"
    
    public var body: some WidgetConfiguration {
        IntentConfiguration(kind: kind, intent: ConfigurationIntent.self, provider: SingleSensorGraphTimeline(), content: { entry  in
            SingleSensorGraphWidgetView(entry: entry)
        })
        .configurationDisplayName("Single Sensor History")
        .description("Shows the temperature history of a Sensor.")
        .supportedFamilies([.systemMedium])
    }
}

struct SingleSensorWidget_Previews: PreviewProvider {
    static var previews: some View {
        EmptyView()
    }
}

