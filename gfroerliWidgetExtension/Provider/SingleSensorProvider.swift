//
//  SingleSensorProvider.swift
//  iOS
//
//  Created by Marc on 26.03.21.
//

import WidgetKit
import SwiftUI
import Intents

struct SingleSensorProvider: IntentTimelineProvider {
    
    
    func placeholder(in context: Context) -> SingleSensorEntry {
        SingleSensorEntry(date: Date(),device_id: "Placeholder", configuration: SingleSensorIntent(), timeSpan: .day, sensor: nil)
    }

    func getSnapshot(for configuration: SingleSensorIntent, in context: Context, completion: @escaping (SingleSensorEntry) -> ()) {
        
        let entry = SingleSensorEntry(date: Date(),device_id: "Placeholder", configuration: configuration,timeSpan: configuration.timeSpan,sensor: nil)
        completion(entry)
    }

    func getTimeline(for configuration: SingleSensorIntent, in context: Context, completion: @escaping (Timeline<SingleSensorEntry>) -> ()) {
        var entries: [SingleSensorEntry] = []
        let singleSensorVM = SingleSensorViewModel()
    
        let selectableSensor = configuration.sensor
        
        singleSensorVM.id = Int(configuration.sensor?.identifier ?? "0")!
        
        singleSensorVM.load()
        
        //Wait for async/await
        let seconds = 2.0
        DispatchQueue.main.asyncAfter(deadline: .now() + seconds) {
            let entry = SingleSensorEntry(date: Date(), device_id: selectableSensor?.identifier ?? "",  configuration: configuration, timeSpan: configuration.timeSpan, sensor: singleSensorVM.sensor)
            entries.append(entry)
            print(entry)
            let timeline = Timeline(entries: entries, policy: .after(Calendar.current.date(byAdding: .minute, value: 10, to: Date())!))
            completion(timeline)
        }
    }
}

struct SingleSensorEntry: TimelineEntry {
    var date: Date
    let device_id: String
    let configuration: SingleSensorIntent
    let timeSpan: TimeSpan
    let sensor: Sensor?
}
