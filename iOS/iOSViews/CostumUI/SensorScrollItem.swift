//
//  SensorScrollItem.swift
//  iOS
//
//  Created by Marc Kramer on 25.08.20.
//

import SwiftUI
import MapKit

struct SensorScrollItem: View {
    
    @State var region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 0.0, longitude: 0.0), span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
    @StateObject var sensorVM = SingleSensorViewModel()
    @State var title: String
    @Binding var sensorID: Int {
        didSet{
            sensorVM.id = sensorID
            sensorVM.load()
        }
    }
    
    var body: some View {
        VStack(alignment: .leading){
            Text(title)
                .font(.title)
                .bold()
                .padding([.horizontal,.top])
            AsyncContentView(source: sensorVM){ sensor in
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
                    
                }
                .onAppear(perform: {
                    region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: sensor.latitude!, longitude: sensor.longitude!), span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
                })
                
                .background(Color.secondarySystemGroupedBackground)
                .frame(width: UIScreen.main.bounds.width, height: 250)
                .padding(.bottom, 50)
            }
            Spacer()
        }
        .onAppear(perform: {
            sensorVM.id = sensorID
            sensorVM.load()
        })
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
