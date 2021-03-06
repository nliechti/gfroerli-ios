//
//  SensorScrollItem.swift
//  iOS
//
//  Created by Marc Kramer on 25.08.20.
//

import SwiftUI
import MapKit

struct SensorScrollItem: View {
    
    @Binding var region : MKCoordinateRegion
    @Binding var sensor: Sensor
    @State var title: LocalizedStringKey
   
    var body: some View {
        VStack(alignment: .leading){
            Text(title)
                .font(.title)
                .bold()
                .padding(.trailing)
                .lineLimit(1)
                .minimumScaleFactor(0.1)
                VStack(alignment: .leading, spacing: 0){
                    Map(coordinateRegion: $region, interactionModes: [])
                    VStack(alignment: .leading){
                        HStack {
                            Text(sensor.device_name)
                                .font(.headline)
                            Spacer()
                        }
                        Text(sensor.caption!)
                            .font(.footnote)
                    }.padding()
                    .lineLimit(1)
                    .minimumScaleFactor(0.1)
                }
                .layoutPriority(1)
                .onAppear(perform: {
                    region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: sensor.latitude!, longitude: sensor.longitude!), span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
                })
                
                .background(Color.secondarySystemGroupedBackground)
                .cornerRadius(15)
                .shadow(radius:1)
                .padding(1)
        }.frame(minWidth: UIScreen.main.bounds.width-40,maxWidth: UIScreen.main.bounds.width-40, minHeight: 250)
    }
}

struct SensorScrollItem_Previews: PreviewProvider {
    static var previews: some View {
        Group{
            //SensorScrollItem(sensor: testSensor, title: "test")
            // SensorScrollItem(sensor: testSensor, title: "test").preferredColorScheme(.dark)
        }
    }
}
