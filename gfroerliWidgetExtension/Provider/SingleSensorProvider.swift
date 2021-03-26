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
        SingleSensorEntry(date: Date(),device_name: "Placeholder", configuration: SingleSensorIntent(), timeSpan: .day)
    }

    func getSnapshot(for configuration: SingleSensorIntent, in context: Context, completion: @escaping (SingleSensorEntry) -> ()) {
        
        let entry = SingleSensorEntry(date: Date(),device_name: "Placeholder", configuration: configuration,timeSpan: configuration.timeSpan)
        completion(entry)
    }

    func getTimeline(for configuration: SingleSensorIntent, in context: Context, completion: @escaping (Timeline<SingleSensorEntry>) -> ()) {
        var entries: [SingleSensorEntry] = []

        let selectableSensor = configuration.sensor
        var name = ""
        if configuration.timeSpan == .day {
            name="day"
        }else if configuration.timeSpan == .week {
            name = "week"
        }
        let entry = SingleSensorEntry(date: Date(), device_name: name,  configuration: configuration, timeSpan: configuration.timeSpan)
        entries.append(entry)
        
        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
}

struct SingleSensorEntry: TimelineEntry {
    var date: Date
    let device_name: String
    let configuration: SingleSensorIntent
    let timeSpan: TimeSpan
}
