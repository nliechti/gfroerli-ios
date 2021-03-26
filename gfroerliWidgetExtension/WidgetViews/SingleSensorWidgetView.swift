//
//  SingleSensorWidget.swift
//  iOS
//
//  Created by Marc on 26.03.21.
//

import WidgetKit
import SwiftUI
import Intents

struct SingleSensorWidgetView: View {
    var entry: SingleSensorProvider.Entry
    var body: some View {
        VStack{
            Text(entry.date, style: .time)
            Text(entry.device_name)
        }
    }
}

struct SingleSensorWidget: Widget {
    let kind: String = "gfroerliWidgetExtension"

    var body: some WidgetConfiguration {
        IntentConfiguration(kind: kind, intent: SingleSensorIntent.self, provider: SingleSensorProvider()) { entry in
            SingleSensorWidgetView(entry: entry)
        }
        .supportedFamilies([.systemSmall])
        .configurationDisplayName("My Widget")
        .description("This is an example widget.")
    }
}

struct SingleSensorWidgetView_Previews: PreviewProvider {
    static var previews: some View {
        SingleSensorWidgetView(entry: SingleSensorEntry(date: Date(),device_name: "Placeholder", configuration: SingleSensorIntent()))
            .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}
