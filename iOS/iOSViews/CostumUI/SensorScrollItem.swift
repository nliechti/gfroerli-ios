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
    
    init(sensor: Sensor){
        self.sensor = sensor
        _region = State(wrappedValue: MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: sensor.latitude!, longitude: sensor.longitude!), span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)))
    }

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

            }
            .padding()
            .background(Color.secondarySystemGroupedBackground)
        }.cornerRadius(15)
        .padding()
        .frame(width: UIScreen.main.bounds.width, height: 250)
                
                .padding(.bottom,10)
            
        
        
        
    }
}

struct SensorScrollItem_Previews: PreviewProvider {
    static var previews: some View {
        Group{
            SensorScrollItem(sensor: testSensor)
            SensorScrollItem(sensor: testSensor).preferredColorScheme(.dark)
    }
    }
}
