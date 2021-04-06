//
//  SingleSensorWidget.swift
//  iOS
//
//  Created by Marc on 26.03.21.

import WidgetKit
import SwiftUI
import Intents

struct SingleSensorWidgetView: View {
    var entry: SingleSensorProvider.Entry
    var config: SingleSensorIntent
    var body: some View {
        
        ZStack{
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
            
            if entry.sensor != nil {
                SensorView(entry: entry)
            }else{
                VStack{
                    HStack{
                        if !Reachability.isConnectedToNetwork(){
                            Text("No internet connection")
                                .foregroundColor(.white)
                        }else{
                            Text("Press and hold to select location")
                                .foregroundColor(.white)
                        }
                        Spacer()
                    }
                    Spacer()
                }.padding()
            
        }
    }.background(Color("GfroerliDarkBlue"))
}
}

struct SensorView: View {
    var entry: SingleSensorProvider.Entry
    @Environment(\.widgetFamily) var size
    var body: some View{
        
        VStack{
            HStack{
                Text(entry.sensor!.device_name)
                    .foregroundColor(.white)
                Spacer()
            }
            
            HStack{
                Spacer()
                VStack(alignment:.trailing,spacing: 0){
                    
                    Text(String(format: "%.1f", entry.sensor!.latestTemp!)+"°")
                    .font(.title2)
                    .foregroundColor(.white)
                        .padding(.vertical,0.1)
                    
                    Text("at "+createStringFromDate(date: entry.sensor!.lastTempTime!, format: getDateFormat(date1: Date(), date2: entry.sensor!.lastTempTime!)))
                        .font(.caption)
                    .foregroundColor(.white)
                        
                    
                }
            }
            Spacer()
        }.padding()
        
    }
    
    func getDateFormat(date1: Date,date2:Date) -> String{
        let calendar = Calendar.current
        let dayComp2 = calendar.dateComponents([.day], from: date1)
        let dayComp1 = calendar.dateComponents([.day], from: date2)
        
        if dayComp1.day == dayComp2.day {
            return "HH:MM"
        }
        return "HH:MM, dd.MM.yy"
    }
}

struct SingleSensorWidget: Widget {
    let kind: String = "gfroerliWidgetExtension"
    
    var body: some WidgetConfiguration {
        IntentConfiguration(kind: kind, intent: SingleSensorIntent.self, provider: SingleSensorProvider()) { entry in
            SingleSensorWidgetView(entry: entry, config: SingleSensorIntent())
        }
        .supportedFamilies([.systemSmall])
        .configurationDisplayName("My small Widget")
        .description("This is an example small widget.")
    }
}

struct SingleSensorWidgetView_Previews: PreviewProvider {
    static var previews: some View {
        SingleSensorWidgetView(entry: SingleSensorEntry(date: Date(),device_id: "Placeholder", configuration: SingleSensorIntent(), timeSpan: .day, sensor: nil), config: SingleSensorIntent())
            .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}
