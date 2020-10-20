//
//  OverView.swift
//  iOS
//
//  Created by Marc Kramer on 22.08.20.
//

import SwiftUI
import MapKit
struct OverView: View {
    @ObservedObject var sensors : SensorListViewModel
    @Binding var loadingState : loadingState
    var featuredSensorID = 1
    
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
                        NavigationLink(
                            destination: SensorOverView(sensor: sensors.sensorArray.first(where: {$0.id == featuredSensorID})!),
                            label: {
                                SensorScrollItem(sensor: sensors.sensorArray.first(where: {$0.id == featuredSensorID})!, region: MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: sensors.sensorArray.first(where: {$0.id == featuredSensorID})!.latitude!, longitude: sensors.sensorArray.first(where: {$0.id == featuredSensorID})!.longitude!), span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)))
                            }).buttonStyle(PlainButtonStyle())
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
                    /* Text("Rivers")
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
                     }*/
                }
                Spacer()
            }.navigationTitle("Gfrör.li")
            
            
            
        }
    }
}

struct OverView_Previews: PreviewProvider {
    static var previews: some View {
        OverView(sensors: testSensorVM, loadingState: .constant(.loading)).makePreViewModifier()
    }
}
