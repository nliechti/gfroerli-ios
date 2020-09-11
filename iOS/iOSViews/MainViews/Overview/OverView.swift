//
//  OverView.swift
//  iOS
//
//  Created by Marc Kramer on 22.08.20.
//

import SwiftUI
import MapKit
struct OverView: View {
    @ObservedObject var sensors : SensorViewModel
    var body: some View {
        NavigationView{
            ScrollView(.vertical){
                VStack(alignment: .leading, spacing: 0){
                    Text("Featured")
                        .font(.title)
                        .bold()
                        .padding()
                    
                        ForEach(sensors.sensorArray){sensor in
                            
                            NavigationLink(
                                destination: SensorOverView(sensor: sensor),
                                label: {
                                    SensorScrollItem(sensor: sensor, region: MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: sensor.latitude!, longitude: sensor.longitude!), span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)))
                                }).buttonStyle(PlainButtonStyle())
                           
                        }
                        
                    Divider()
                    
                    Text("Lakes")
                        .font(.title)
                        .bold()
                        .padding([.horizontal,.top])
                    ScrollView(.horizontal, showsIndicators: false){
                        HStack(spacing:0){
                            ForEach(lakes){ lake in
                                NavigationLink(
                                    destination: LakeOverView(lake: lake),
                                    label: {
                                        ScrollItem(sensorCount: lake.sensors.count, name: lake.name, region: lake.region)
                                    }).buttonStyle(PlainButtonStyle())
                                    .padding()
                            }
                        }
                    }
                    Text("Rivers")
                        .font(.title)
                        .bold()
                        .padding([.horizontal,.top])
                    ScrollView(.horizontal, showsIndicators: false){
                        HStack(spacing:0){
                            ForEach(rivers){ river in
                                NavigationLink(
                                    destination: Text(river.name),
                                    label: {
                                        ScrollItem(sensorCount: river.sensors.count, name: river.name, region: river.region)
                                        
                                    }).buttonStyle(PlainButtonStyle())
                                    .padding()
                            }
                        }
                    }
                }
                
                
                Spacer()
            }.navigationTitle("Gfrör.li")
            
            
        }
    }
}

struct OverView_Previews: PreviewProvider {
    static var previews: some View {
        Group{
            OverView(sensors: SensorViewModel())
                .previewDevice(PreviewDevice(rawValue: "iPhone 11 Pro Max"))
                .previewDisplayName("iPhone 11 Pro Max")
            OverView(sensors: SensorViewModel())
                .previewDevice(PreviewDevice(rawValue: "iPhone 11 Pro"))
                .previewDisplayName("iPhone 11 Pro")
            OverView(sensors: SensorViewModel())
                .previewDevice(PreviewDevice(rawValue: "iPhone SE"))
                .previewDisplayName("iPhone SE")
        }
    }
}
