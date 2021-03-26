//
//  SingleSensorWithGraphView.swift
//  iOS
//
//  Created by Marc on 26.03.21.
//

import WidgetKit
import SwiftUI
import Intents

struct SingleSensorWithGraphView: View {
    var entry: SingleSensorWithGraphProvider.Entry
    var body: some View {
        VStack{
        Text(entry.date, style: .time)
            Text(entry.device_name)
            Text(String(entry.temperature))
        }
    }
}

struct SingleSensorWithGraphWidget: Widget {
    let kind: String = "gfroerliWidgetExtension"

    var body: some WidgetConfiguration {
        IntentConfiguration(kind: kind, intent: SingleSensorWithGraphIntent.self, provider: SingleSensorWithGraphProvider()) { entry in
            SingleSensorWithGraphView(entry: entry)
        }
        .supportedFamilies([.systemMedium,.systemLarge])
        .configurationDisplayName("My Widget")
        .description("This is an example widget.")
    }
}

struct SingleSensorWithGraphView_Previews: PreviewProvider {
    static var previews: some View {
        SingleSensorWithGraphView(entry: SingleSensorWithGraphEntry(date: Date(),device_name: "Placeholder", temperature: 0.0, configuration: SingleSensorWithGraphIntent()))
            .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}
