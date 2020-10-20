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
            //Text(createDateStringfromStringDate(string: sensor.last_measurement!.created_at!))
              //  .font(.footnote).foregroundColor(.gray)
        }
    }
}

struct SensorOverviewLastMeasurementView_Previews: PreviewProvider {

    static var previews: some View {
       
        SensorOverviewLastMeasurementView(sensor:testSensor).makePreViewModifier()
    }
}
