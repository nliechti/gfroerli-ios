//
//  SensorScrollItem.swift
//  iOS
//
//  Created by Marc Kramer on 25.08.20.
//

import SwiftUI
import MapKit

struct SensorScrollItem: View {
    var sensor: Sensor
    @State var region: MKCoordinateRegion
    @Environment(\.colorScheme) var colorScheme

    var body: some View {
        
        
        VStack(alignment: .leading, spacing: 0){
            Map(coordinateRegion: $region, interactionModes: [])
            VStack(alignment: .leading){
                
                HStack {
                    Text(sensor.device_name!)
                        .font(.headline)
                    Spacer()
                }
                Text(sensor.caption!)
                    .font(.footnote)

            }.padding()
            .background((colorScheme == .dark ? Color(.systemGray6) : Color.white))

        }
        .frame(width: UIScreen.main.bounds.width, height: 250, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                
                .padding(.bottom,10)
            
        
        
        
    }
}

struct SensorScrollItem_Previews: PreviewProvider {
    static var previews: some View {
        Group{
            SensorScrollItem(sensor: testSensor, region: MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 0.0000, longitude: 0.000), span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)))
            SensorScrollItem(sensor: testSensor, region: MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 0.0000, longitude: 0.000), span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))).preferredColorScheme(.dark)
    }
    }
}
