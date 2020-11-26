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
        VStack(alignment: .leading){
            
            Text("Last Measurement").font(.title).bold()
            Text(String(format: "%.1f", sensor.latestTemp!)+"°" ).font(.system(size: 50))
            #warning("add remove if api fixed")
            // Text("Highest: " + String(format: "%.1f", sensor.maxTemp!))
            // Text("Lowest: " + String(format: "%.1f", sensor.minTemp!))
            // Text("Average: " + String(format: "%.1f", sensor.avgTemp!))
            
        }.padding()
        .frame(maxWidth:.infinity,alignment: .topLeading)
    }
}

struct SensorOverviewLastMeasurementView_Previews: PreviewProvider {

    static var previews: some View {
       
        SensorOverviewLastMeasurementView(sensor:testSensor).makePreViewModifier()
    }
}
