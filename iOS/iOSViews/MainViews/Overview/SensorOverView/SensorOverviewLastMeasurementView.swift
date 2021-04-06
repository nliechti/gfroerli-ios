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
        HStack{
            
        VStack(alignment: .leading){
            Text("Latest").font(.largeTitle).bold()
            Text(String(format: "%.1f", sensor.latestTemp!)+"°" ).font(.system(size: 50))
            Text("Today at " + createStringFromDate(date: sensor.lastTempTime!, format: getDateFormat(date1: Date(), date2: sensor.lastTempTime!)) ).font(.headline)
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
            
        }.padding()
        .frame(maxWidth:.infinity,alignment: .topLeading)
    }
    func getDateFormat(date1: Date,date2:Date) -> String{
        let calendar = Calendar.current
        let dayComp2 = calendar.dateComponents([.day], from: date1)
        let dayComp1 = calendar.dateComponents([.day], from: date2)
        
        if dayComp1.day == dayComp2.day {
            return "HH:MM"
        }
        return "HH:MM, dd.MM.yy"
    }
}

struct SensorOverviewLastMeasurementView_Previews: PreviewProvider {
    static var previews: some View {
        SensorOverviewLastMeasurementView(sensor:testSensor).makePreViewModifier()
    }
}
