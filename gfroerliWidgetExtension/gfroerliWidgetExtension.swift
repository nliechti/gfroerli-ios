//
//  gfroerliWidgetExtension.swift
//  gfroerliWidgetExtension
//
//  Created by Marc on 25.03.21.
//

import WidgetKit
import SwiftUI
import Intents

struct Provider: IntentTimelineProvider {
    
    
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(),device_name: "Placeholder", temperature: 0.0, configuration: SelectSensorIntent())
    }

    func getSnapshot(for configuration: SelectSensorIntent, in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry = SimpleEntry(date: Date(),device_name: "Placeholder", temperature: 0.0, configuration: configuration)
        completion(entry)
    }

    func getTimeline(for configuration: SelectSensorIntent, in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var entries: [SimpleEntry] = []

        let selectableSensor = configuration.sensor
        let currentDate = Date()
        for hourOffset in 0 ..< 5 {
            let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
            let entry = SimpleEntry(date: entryDate,device_name: selectableSensor?.displayString ?? "" , temperature: Double(selectableSensor?.temperature ?? 0.0), configuration: configuration)
            entries.append(entry)
        }

        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let device_name: String
    let temperature: Double
    let configuration: SelectSensorIntent
}

struct gfroerliWidgetExtensionEntryView : View {
    var entry: Provider.Entry

    var body: some View {
        VStack{
        Text(entry.date, style: .time)
            Text(entry.device_name)
            Text(String(entry.temperature))
        }
    }
}

@main
struct gfroerliWidgetExtension: Widget {
    let kind: String = "gfroerliWidgetExtension"

    var body: some WidgetConfiguration {
        IntentConfiguration(kind: kind, intent: SelectSensorIntent.self, provider: Provider()) { entry in
            gfroerliWidgetExtensionEntryView(entry: entry)
        }
        .configurationDisplayName("My Widget")
        .description("This is an example widget.")
    }
}

struct gfroerliWidgetExtension_Previews: PreviewProvider {
    static var previews: some View {
        gfroerliWidgetExtensionEntryView(entry: SimpleEntry(date: Date(),device_name: "Placeholder", temperature: 0.0, configuration: SelectSensorIntent()))
            .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}
