//
//  SensorListItem.swift
//  iOS
//
//  Created by Marc Kramer on 04.12.20.
//

import SwiftUI

struct SensorListItem: View {
    var sensor: Sensor
    @Environment(\.colorScheme) var colorScheme
    var body: some View {
        VStack(){
            NavigationLink(
                destination: SensorOverView(id: sensor.id!),
                label: {
                    HStack(){
                        Text(sensor.device_name!).foregroundColor(colorScheme == .dark ? Color.white : Color.black)
                        Spacer()
                        Text(String(format: "%.1f", sensor.latestTemp!)+"°" ).foregroundColor(colorScheme == .dark ? Color.white : Color.black)
                        Image(systemName: "chevron.right").foregroundColor(.secondary)
                    }.padding()
                    .background(Color.secondarySystemGroupedBackground)
                    .cornerRadius(15)
                    
                })
        }
    }
}

struct SensorListItem_Previews: PreviewProvider {
    static var previews: some View {
        SensorListItem(sensor: testSensor)
        SensorListItem(sensor: testSensor).preferredColorScheme(.dark)

    }
}
