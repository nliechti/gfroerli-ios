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
            Text(String(format: "%.1f", sensor.last_measurement!.temperature!)+"°" ).font(.system(size: 50))
            Text(createDateStringfromStringDate(string: sensor.last_measurement!.created_at!))
                .font(.footnote).foregroundColor(.gray)
        }
    }
}

struct SensorOverviewLastMeasurementView_Previews: PreviewProvider {

    static var previews: some View {
        Group{
            SensorOverviewLastMeasurementView(sensor:testSensor)
                .previewDevice(PreviewDevice(rawValue: "iPhone 11 Pro Max"))
                .previewDisplayName("iPhone 11 Pro Max")
            SensorOverviewLastMeasurementView(sensor: testSensor)
                .previewDevice(PreviewDevice(rawValue: "iPhone 11 Pro"))
                .previewDisplayName("iPhone 11 Pro")
            SensorOverviewLastMeasurementView(sensor: testSensor)
                .previewDevice(PreviewDevice(rawValue: "iPhone SE"))
                .previewDisplayName("iPhone SE")
        }
        Group{
            SensorOverviewLastMeasurementView(sensor:testSensor)
                .preferredColorScheme(.dark)
                .previewDevice(PreviewDevice(rawValue: "iPhone 11 Pro Max"))
                .previewDisplayName("iPhone 11 Pro Max Dark")
            SensorOverviewLastMeasurementView(sensor: testSensor)
                .preferredColorScheme(.dark)
                .previewDevice(PreviewDevice(rawValue: "iPhone 11 Pro"))
                .previewDisplayName("iPhone 11 Pro Dark")
            SensorOverviewLastMeasurementView(sensor: testSensor)
                .preferredColorScheme(.dark)
                .previewDevice(PreviewDevice(rawValue: "iPhone SE"))
                .previewDisplayName("iPhone SE Dark")
                
        }
    }
}
