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
        SensorOverviewSponsorView(sensor: Binding.constant(testSensor))
    }
}
