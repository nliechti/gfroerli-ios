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
    
    init(sensor: Sensor) {
        self.sensor = sensor
        _region = State(initialValue: MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: sensor.latitude ?? 0.0, longitude: sensor.longitude ?? 0.0),
            span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
        )
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            Map(coordinateRegion: $region, interactionModes: [])
            
            HStack(alignment: .top) {
                VStack(alignment: .leading) {
                    Text(sensor.device_name)
                        .font(.headline)
                    Text(sensor.caption!)
                        .font(.footnote)
                        .multilineTextAlignment(.leading)
                }
                
                Spacer()
                
                VStack(alignment: .trailing) {
                    Text(makeTemperatureString(double: sensor.latestTemp!))
                        .font(.headline)
                    Text(sensor.lastTempTime!, format: .relative(presentation: .named))
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
            .padding([.horizontal, .bottom])
            .lineLimit(2)
        }
        .frame(maxHeight: UIScreen.main.bounds.height * 0.3)
        .background(Color.secondarySystemGroupedBackground)
        .cornerRadius(15)
        .overlay(
            RoundedRectangle(cornerRadius: 15)
                .stroke(.tertiary, lineWidth: 1)
        )
        .padding([.horizontal, .bottom])
        .padding(.top, 2)
    }
}

struct SensorScrollItem_Previews: PreviewProvider {
    static var previews: some View {
        EmptyView()
    }
}
