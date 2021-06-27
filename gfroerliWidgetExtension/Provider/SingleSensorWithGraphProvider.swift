//
//  SingleSensorWithGraphProvider.swift
//  Gfror.li
//
//  Created by Marc on 13.04.21.
//

import Foundation
import WidgetKit
import SwiftUI
import Intents

struct SingleSensorWithGraphProvider: IntentTimelineProvider {

    func placeholder(in context: Context) -> SingleSensorWithGraphEntry {
        SingleSensorWithGraphEntry(
            date: Date(),
            device_id: "Placeholder",
            configuration: SingleSensorIntent(),
            timeSpan: .day,
            sensor: nil,
            dataDay: [],
            dataWeek: [],
            dataMonth: [])
    }

    func getSnapshot(
        for configuration: SingleSensorIntent,
        in context: Context,
        completion: @escaping (SingleSensorWithGraphEntry) -> Void) {

        let entry = SingleSensorWithGraphEntry(
            date: Date(),
            device_id: "1",
            configuration: configuration,
            timeSpan: configuration.timeSpan,
            sensor: testSensor1,
            dataDay: HourlyAggregation.hourlyExampleData,
            dataWeek: [],
            dataMonth: [])
        completion(entry)
    }

    func getTimeline(
        for configuration: SingleSensorIntent,
        in context: Context,
        completion: @escaping (Timeline<SingleSensorWithGraphEntry>) -> Void) {
        var entries: [SingleSensorWithGraphEntry] = []
        let singleSensorVM = SingleSensorViewModel()
        let hourlyAggregVM = HourlyAggregationsViewModel()
        let weeklyAggregVM = WeeklyAggregationsViewModel()
        let monthlyAggregVM = MonthlyAggregationsViewModel()

        let selectableSensor = configuration.sensor
        
        hourlyAggregVM.id = Int(configuration.sensor?.identifier ?? "0")!
        weeklyAggregVM.id = Int(configuration.sensor?.identifier ?? "0")!
        monthlyAggregVM.id = Int(configuration.sensor?.identifier ?? "0")!

        async{ await singleSensorVM.load(sensorId: Int(configuration.sensor?.identifier ?? "0")!)}
        hourlyAggregVM.load()
        weeklyAggregVM.load()
        monthlyAggregVM.load()

        // Wait for async/await
        let seconds = 1.0
        DispatchQueue.main.asyncAfter(deadline: .now() + seconds) {

            let entry = SingleSensorWithGraphEntry(
                date: Date(),
                device_id: selectableSensor?.identifier ?? "",
                configuration: configuration,
                timeSpan: configuration.timeSpan,
                sensor: singleSensorVM.sensor,
                dataDay: hourlyAggregVM.dataDay,
                dataWeek: weeklyAggregVM.dataWeek,
                dataMonth: monthlyAggregVM.dataMonth
            )
            entries.append(entry)

            let timeline = Timeline(
                entries: entries,
                policy: .after(Calendar.current.date(byAdding: .minute, value: 10, to: Date())!)
            )
            completion(timeline)
        }
    }
}

struct SingleSensorWithGraphEntry: TimelineEntry {
    var date: Date
    let device_id: String // swiftlint:disable:this identifier_name
    let configuration: SingleSensorIntent
    let timeSpan: TimeSpan
    let sensor: Sensor?
    let dataDay: [HourlyAggregation?]
    let dataWeek: [DailyAggregation]
    let dataMonth: [DailyAggregation]
}
