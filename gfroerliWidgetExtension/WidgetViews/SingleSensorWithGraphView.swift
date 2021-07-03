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
        ZStack {

            Wave(strength: 10, frequency: 8, offset: -300)
                .fill(
                    LinearGradient(
                        gradient: Gradient(colors: [Color.blue.opacity(0.6), Color("GfroerliLightBlue").opacity(0.4)]),
                        startPoint: .leading, endPoint: .trailing)
                    ).offset(y: 40)

            Wave(strength: 10, frequency: 10, offset: -10.0)
                .fill(
                LinearGradient(
                    gradient: Gradient(colors: [Color("GfroerliLightBlue").opacity(0.5), Color.blue.opacity(0.4)]),
                    startPoint: .trailing, endPoint: .leading)
                )
                .offset(x: 0, y: 20)
                .rotation3DEffect(
                    .degrees(180),
                    axis: (x: 0.0, y: 1.0, z: 0.0),
                    anchor: .center/*@END_MENU_TOKEN@*/,
                    anchorZ: 0.0/*@END_MENU_TOKEN@*/,
                    perspective: 1.0/*@END_MENU_TOKEN@*/
                )

            if entry.sensor != nil {
                SensorWithGraphView(entry: entry)
            } else {
                VStack {
                    HStack {
                        if !Reachability.isConnectedToNetwork() {
                            Text("No internet connection")
                                .foregroundColor(.white)
                        } else {
                            Text("Press and hold to select location")
                                .foregroundColor(.white)
                        }
                        Spacer()
                        Image(systemName: "thermometer")
                            .foregroundColor(.red)
                            .imageScale(.large)
                    }
                    Spacer()
                }.padding()
            }
        }
        .background(Color("GfroerliDarkBlue"))
        .widgetURL(entry.sensor != nil ?
                   URL(string: "ch.coredump.gfroerli://home/\(entry.sensor!.id)") : URL(string: "ch.coredump.gfroerli"))
    }
}

struct SensorWithGraphView: View {
    var entry: SingleSensorWithGraphProvider.Entry
    @Environment(\.widgetFamily) var size
    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Text(entry.sensor!.device_name)
                    .font(.system(size: 20))
                    .foregroundColor(.white)
                    .minimumScaleFactor(0.1)
                Spacer()
                Text(String(format: "%.1f", entry.sensor!.latestTemp!)+"°")
                    .foregroundColor(.white)
                    .font(.system(size: 20))
                Image(systemName: "thermometer").foregroundColor(.red).font(.system(size: 20))
            }

            HStack(spacing: 0) {
                Text("Measured at: ").font(.caption)
                    .foregroundColor(.white)
                Text(entry.sensor!.lastTempTime!, style: .time).font(.caption)
                    .foregroundColor(.white)
                Spacer()
            }
            VStack {
                Spacer()
                GeometryReader { geo in
                    if entry.configuration.timeSpan == .day {
                        HourlyChartView(
                            showMax: .constant(false),
                            showMin: .constant(false),
                            showAvg: .constant(true),
                            showCircles: .constant(true),
                            data: entry.dataDay,
                            lineWidth: 2,
                            pointSize: 2,
                            frame: geo.frame(in: .local),
                            avgColor: .white
                        ).colorScheme(.dark)
                    } else if entry.configuration.timeSpan == .month {
                        MonthlyChartView(
                            showMax: .constant(false),
                            showMin: .constant(false),
                            showAvg: .constant(true),
                            showCircles: .constant(true),
                            avgColor: .white,
                            daySpan: .month,
                            data: entry.dataMonth,
                            lineWidth: 2,
                            pointSize: 2,
                            frame: geo.frame(in: .local)
                        ).colorScheme(.dark)
                    } else {
                        WeeklyChartView(
                            showMax: .constant(false),
                            showMin: .constant(false),
                            showAvg: .constant(true),
                            showCircles: .constant(true),
                            avgColor: .white,
                            daySpan: .month,
                            data: entry.dataWeek,
                            lineWidth: 2,
                            pointSize: 2,
                            frame: geo.frame(in: .local)
                        ).colorScheme(.dark)
                    }
                }
            }.padding(.vertical, 10)
        }.padding()
    }
}

struct SingleSensorWithGraphWidget: Widget {
    let kind: String = "gfroerliWidgetExtension1"

    var body: some WidgetConfiguration {
        IntentConfiguration(
            kind: kind,
            intent: SingleSensorIntent.self,
            provider: SingleSensorWithGraphProvider()) { entry in
            SingleSensorWithGraphView(entry: entry)
        }
            .supportedFamilies([.systemMedium, .systemLarge])
            .configurationDisplayName("Single Location with Graph")
            .description("Displays the temperature history of a location.")
    }
}

struct SingleSensorWithGraphView_Previews: PreviewProvider {
    static var previews: some View {
        SingleSensorWithGraphView(
            entry: SingleSensorWithGraphEntry(
                date: Date(),
                device_id: "Placeholder",
                configuration: SingleSensorIntent(),
                timeSpan: .day,
                sensor: nil,
                dataDay: [],
                dataWeek: [],
                dataMonth: [])
        )
            .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}
