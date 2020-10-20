//
//  LakeOverView.swift
//  iOS
//
//  Created by Marc Kramer on 22.08.20.
//

import SwiftUI
import MapKit

struct LakeOverView: View {
    var lake : Lake
    @ObservedObject var sensors : SensorListViewModel
    @Binding var loadingState: loadingState
    var body: some View {
        VStack(alignment: .leading) {
            topMap(lake: lake, region: lake.region, sensors: sensors)
            Text("Locations").font(.title).bold().padding(.horizontal)
            Form(){
                Section(){
                    switch loadingState{
                    case .loading:
                        LoadingView()
                    case .loaded:
                        ForEach(sensors.sensorArray){ sensor in
                            if(lake.sensors.contains(String(sensor.id!))){
                                NavigationLink(
                                    destination: SensorOverView(sensor: sensor),
                                    label: {
                                        HStack {
                                            Text(sensor.device_name!)
                                            Spacer()
                                            Text(String(format: "%.1f",sensor.last_measurement!.temperature!)+"°")
                                        }
                                    })
                            }
                        }
                    case .error:
                        ErrorView()
                    }
                
            }
            }
        }.navigationBarTitle(lake.name)
    }
}

struct LakeOverView_Previews: PreviewProvider {
    static var previews: some View {
        LakeOverView(lake: lakeOfZurich, sensors: testSensorVM, loadingState: .constant(.loaded)).makePreViewModifier()
    }
}

struct topMap: View{
    var lake: Lake
    @State var region: MKCoordinateRegion
    @ObservedObject var sensors: SensorListViewModel
    var body: some View{
        Map (coordinateRegion: $region,annotationItems: sensors.sensorArray, annotationContent: { pin in
                        MapAnnotation(coordinate: CLLocationCoordinate2D(latitude: pin.latitude!, longitude: pin.longitude!), content: {
                            
                            NavigationLink(
                                destination: /*@START_MENU_TOKEN@*/Text("Destination")/*@END_MENU_TOKEN@*/,
                                label: {
                                    Text(String(format: "%.1f", pin.last_measurement!.temperature!)+"°")
                                        .minimumScaleFactor(0.3)
                                        .foregroundColor(.white)
                                        .lineLimit(1)
                                        .frame(width: 40, height: 40)
                                        .background(Color.blue)
                                        .cornerRadius(90)
                                })
                            
                                
                        
                            
                        })
            
                    }).frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height/3.5, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
        
        .onAppear(perform: {
            region = MKCoordinateRegion(center: lake.region.center, span: MKCoordinateSpan(latitudeDelta: 0.2, longitudeDelta:0.2))

        })
        
        
    }
    
}
