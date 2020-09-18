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
    @Binding var loadingState : loadingState
    
    var body: some View {
        NavigationView{
            ScrollView(.vertical){
                VStack(alignment: .leading, spacing: 0){
                    Divider()
                    Text("Featured")
                        .font(.title)
                        .bold()
                        .padding()
                    
                    switch loadingState{
                    case .loading:
                        LoadingView().frame(width: UIScreen.main.bounds.width, height: 250)
                    case .loaded:
                        ForEach(sensors.sensorArray){sensor in
                                
                                NavigationLink(
                                    destination: SensorOverView(sensor: sensor),
                                    label: {
                                        SensorScrollItem(sensor: sensor, region: MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: sensor.latitude!, longitude: sensor.longitude!), span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)))
                                    }).buttonStyle(PlainButtonStyle())
                               
                        }
                    case .error:
                        ErrorView().frame(width: UIScreen.main.bounds.width, height: 250)
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
                                    destination: LakeOverView(lake: lake, sensors: sensors, loadingState: $loadingState),
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
            OverView(sensors: testSensorVM, loadingState: .constant(.loaded))
                .previewDevice(PreviewDevice(rawValue: "iPhone 11 Pro Max"))
                .previewDisplayName("iPhone 11 Pro Max")
            OverView(sensors: testSensorVM, loadingState: .constant(.loaded))
                .previewDevice(PreviewDevice(rawValue: "iPhone 11 Pro"))
                .previewDisplayName("iPhone 11 Pro")
            OverView(sensors: testSensorVM, loadingState: .constant(.loaded))
                .previewDevice(PreviewDevice(rawValue: "iPhone SE"))
                .previewDisplayName("iPhone SE")
        }
        Group{
            OverView(sensors: testSensorVM, loadingState: .constant(.loaded))
                .preferredColorScheme(.dark)
                .previewDevice(PreviewDevice(rawValue: "iPhone 11 Pro Max"))
                .previewDisplayName("iPhone 11 Pro Max Dark")
            OverView(sensors: testSensorVM, loadingState: .constant(.loaded))
                .preferredColorScheme(.dark)
                .previewDevice(PreviewDevice(rawValue: "iPhone 11 Pro"))
                .previewDisplayName("iPhone 11 Pro Dark")
            OverView(sensors: testSensorVM, loadingState: .constant(.loaded))
                .preferredColorScheme(.dark)
                .previewDevice(PreviewDevice(rawValue: "iPhone SE"))
                .previewDisplayName("iPhone SE Dark")
                
        }
    }
}
