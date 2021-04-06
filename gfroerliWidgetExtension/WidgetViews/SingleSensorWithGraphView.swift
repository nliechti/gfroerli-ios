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
    var entry: SingleSensorProvider.Entry
    var body: some View {
        VStack{
            Text(entry.date, style: .time)
            Text(entry.device_id)
        }
    }
}



struct SingleSensorWithGraphWidget: Widget {
    let kind: String = "gfroerliWidgetExtension"

    var body: some WidgetConfiguration {
        IntentConfiguration(kind: kind, intent: SingleSensorIntent.self, provider: SingleSensorProvider()) { entry in
            SingleSensorWithGraphView(entry: entry)
        }
        .supportedFamilies([.systemMedium,.systemLarge])
        .configurationDisplayName("My big Widget")
        .description("This is an example big widget.")
    }
}

struct SingleSensorWithGraphView_Previews: PreviewProvider {
    static var previews: some View {
        SingleSensorWithGraphView(entry: SingleSensorEntry(date: Date(),device_id: "Placeholder", configuration: SingleSensorIntent(),timeSpan: .day, sensor: nil))
            .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}
