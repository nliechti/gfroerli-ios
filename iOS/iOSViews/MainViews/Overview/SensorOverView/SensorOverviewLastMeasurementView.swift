//
//  SensorOverviewLastMeasurementView.swift
//  iOS
//
//  Created by Marc Kramer on 11.09.20.
//

import SwiftUI

struct SensorOverviewLastMeasurementView: View {
    var sensor : Sensor
    var body: some View {
        VStack{
            HStack(alignment: .firstTextBaseline){
                VStack(alignment: .leading){
                    Text("Latest").font(.title)
                        .bold()
                    Text(String(format: "%.1f", sensor.latestTemp!)+"°" )
                        .font(.system(size: 50))
                    Spacer()
                }.fixedSize()
                .layoutPriority(1)
                .minimumScaleFactor(0.1)
                .lineLimit(1)
                Spacer(minLength: 25)
                    .layoutPriority(1)
                VStack(alignment: .leading) {
                    Text("All time:").font(.title2)
                        .bold()
                    HStack {
                        Text("Average:")
                        Spacer()
                        Text(String(format: "%.1f", sensor.avgTemp!)+"°")
                    }
                    HStack {
                        Text("Highest:")
                        Spacer()
                        Text(String(format: "%.1f", sensor.maxTemp!)+"°")
                    }
                    HStack {
                        Text("Lowest:")
                        Spacer()
                        Text(String(format: "%.1f", sensor.minTemp!)+"°")
                    }
                    Spacer()
                }
                .fixedSize()
                .layoutPriority(1)
                .lineLimit(1)
                .minimumScaleFactor(0.1)
                }
                
            
            HStack(spacing: 0){
                Text("Measured at ").font(.headline)
                Text(sensor.lastTempTime!, style: .time).font(.headline)
                if !areSameDay(date1: Date(), date2: sensor.lastTempTime!){
                    Text(createStringFromDate(date: sensor.lastTempTime!, format: ", dd. MMM. YYYY")).font(.headline)
                }
                Spacer()
            }.layoutPriority(1)
            .lineLimit(1)
            .minimumScaleFactor(0.1)
        }.padding()
        .frame(maxWidth:.infinity,alignment: .topLeading)
    }

}

struct SensorOverviewLastMeasurementView_Previews: PreviewProvider {
    static var previews: some View {
        SensorOverviewLastMeasurementView(sensor:testSensor1)
            .environment(\.sizeCategory, .large)
            .boxStyle()
            .padding(.top)
            .background(Color.green)
            .makePreViewModifier()
    }
}
