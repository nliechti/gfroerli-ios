//
//  SensorOverviewSponsorView.swift
//  iOS
//
//  Created by Marc Kramer on 11.09.20.
//

import SwiftUI

struct SensorOverviewSponsorView: View {
    @Binding var sensor : Sensor
    var body: some View {
        VStack(alignment: .leading){
            
            Text("Sponsorred by").font(.title).bold()
            Text(String(sensor.sponsor_id!))
        }
    }
}

struct SensorOverviewSponsorView_Previews: PreviewProvider {
    static var previews: some View {
        Group{
            SensorOverviewSponsorView(sensor: Binding.constant(testSensor))
                .previewDevice(PreviewDevice(rawValue: "iPhone 11 Pro Max"))
                .previewDisplayName("iPhone 11 Pro Max")
            SensorOverviewSponsorView(sensor: Binding.constant(testSensor))
                .previewDevice(PreviewDevice(rawValue: "iPhone 11 Pro"))
                .previewDisplayName("iPhone 11 Pro")
            SensorOverviewSponsorView(sensor: Binding.constant(testSensor))
                .previewDevice(PreviewDevice(rawValue: "iPhone SE"))
                .previewDisplayName("iPhone SE")
        }
        Group{
            SensorOverviewSponsorView(sensor: Binding.constant(testSensor))
                .preferredColorScheme(.dark)
                .previewDevice(PreviewDevice(rawValue: "iPhone 11 Pro Max"))
                .previewDisplayName("iPhone 11 Pro Max Dark")
            SensorOverviewSponsorView(sensor: Binding.constant(testSensor))
                .preferredColorScheme(.dark)
                .previewDevice(PreviewDevice(rawValue: "iPhone 11 Pro"))
                .previewDisplayName("iPhone 11 Pro Dark")
            SensorOverviewSponsorView(sensor: Binding.constant(testSensor))                .preferredColorScheme(.dark)
                .previewDevice(PreviewDevice(rawValue: "iPhone SE"))
                .previewDisplayName("iPhone SE Dark")
                
        }
    }
}
