//
//  gfroerliWidgetExtension.swift
//  gfroerliWidgetExtension
//
//  Created by Marc on 25.03.21.
//

import WidgetKit
import SwiftUI
import Intents

struct SingleSensorWithGraphProvider: IntentTimelineProvider {
    
    
    func placeholder(in context: Context) -> SingleSensorWithGraphEntry {
        SingleSensorWithGraphEntry(date: Date(),device_name: "Placeholder", temperature: 0.0, configuration: SingleSensorWithGraphIntent())
    }

    func getSnapshot(for configuration: SingleSensorWithGraphIntent, in context: Context, completion: @escaping (SingleSensorWithGraphEntry) -> ()) {
        let entry = SingleSensorWithGraphEntry(date: Date(),device_name: "Placeholder", temperature: 0.0, configuration: configuration)
        completion(entry)
    }

    func getTimeline(for configuration: SingleSensorWithGraphIntent, in context: Context, completion: @escaping (Timeline<SingleSensorWithGraphEntry>) -> ()) {
        var entries: [SingleSensorWithGraphEntry] = []

        let selectableSensor = configuration.sensor
        let currentDate = Date()
        for hourOffset in 0 ..< 5 {
            let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
            let entry = SingleSensorWithGraphEntry(date: entryDate,device_name: selectableSensor?.displayString ?? "", temperature: 0.0 , configuration: configuration)
            entries.append(entry)
        }

        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
}

struct SingleSensorWithGraphEntry: TimelineEntry {
    let date: Date
    let device_name: String
    let temperature: Double
    let configuration: SingleSensorWithGraphIntent
}






