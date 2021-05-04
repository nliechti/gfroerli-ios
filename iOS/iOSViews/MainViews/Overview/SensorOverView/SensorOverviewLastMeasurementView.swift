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
            HStack{
                VStack(alignment: .leading){
                    Text("Latest").font(.largeTitle).bold()
                    Text(String(format: "%.1f", sensor.latestTemp!)+"°" ).font(.system(size: 50))
                    Spacer()
                }
                Spacer()
                VStack(alignment: .leading) {
                    Text("All time:").bold()
                    Text("Average:")
                    Text("Highest:")
                    Text("Lowest:")
                }
                VStack(alignment: .trailing) {
                    Text("").font(.largeTitle).bold()
                    Text(String(format: "%.1f", sensor.avgTemp!)+"°")
                    Text(String(format: "%.1f", sensor.maxTemp!)+"°")
                    Text(String(format: "%.1f", sensor.minTemp!)+"°")
                }
            }
            HStack(spacing: 0){
                Text("Measured at"+" ").font(.headline)
                Text(sensor.lastTempTime!, style: .time).font(.headline)
                if !areSameDay(date1: Date(), date2: sensor.lastTempTime!){
                    Text(createStringFromDate(date: sensor.lastTempTime!, format: ", dd. MMM. YYYY")).font(.headline)
                }
                Spacer()
            }
        }.padding()
        .frame(maxWidth:.infinity,alignment: .topLeading)
    }

}

struct SensorOverviewLastMeasurementView_Previews: PreviewProvider {
    static var previews: some View {
        SensorOverviewLastMeasurementView(sensor:testSensor1).makePreViewModifier()
    }
}
