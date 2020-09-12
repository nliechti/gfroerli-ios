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
    @StateObject var sensors = SensorViewModel()
    var body: some View {
        VStack(alignment: .leading) {
            topMap(lake: lake, region: lake.region, sensors: sensors)
            Text("Locations").font(.title).bold().padding(.horizontal)
            Form(){
                Section(){
                ForEach(sensors.sensorArray){ sensor in
                    if(lake.sensors.contains(String(sensor.id!))){
                        NavigationLink(
                            destination: SensorOverView(sensor: sensor),
                            label: {
                                HStack {
                                    Text(sensor.device_name!)
                                    Spacer()
                                    Text(String(sensor.last_measurement!.temperature!)+"°")
                                }
                            })
                    }
                }
            }
            }
        }.navigationBarTitle(lake.name)
    }
}

struct LakeOverView_Previews: PreviewProvider {
    static var previews: some View {
        Group{
            LakeOverView(lake: lakeOfZurich)
                .previewDevice(PreviewDevice(rawValue: "iPhone 11 Pro Max"))
                .previewDisplayName("iPhone 11 Pro Max")
            LakeOverView(lake: lakeOfZurich)
                .previewDevice(PreviewDevice(rawValue: "iPhone 11 Pro"))
                .previewDisplayName("iPhone 11 Pro")
            LakeOverView(lake: lakeOfZurich)
                .previewDevice(PreviewDevice(rawValue: "iPhone SE"))
                .previewDisplayName("iPhone SE")
        }
        Group{
            LakeOverView(lake: lakeOfZurich)
                .preferredColorScheme(.dark)
                .previewDevice(PreviewDevice(rawValue: "iPhone 11 Pro Max"))
                .previewDisplayName("iPhone 11 Pro Max Dark")
            LakeOverView(lake: lakeOfZurich)
                .preferredColorScheme(.dark)
                .previewDevice(PreviewDevice(rawValue: "iPhone 11 Pro"))
                .previewDisplayName("iPhone 11 Pro Dark")
            LakeOverView(lake: lakeOfZurich)               .preferredColorScheme(.dark)
                .previewDevice(PreviewDevice(rawValue: "iPhone SE"))
                .previewDisplayName("iPhone SE Dark")
                
        }
        
    }
}

struct topMap: View{
    var lake: Lake
    @State var region: MKCoordinateRegion
    @ObservedObject var sensors: SensorViewModel
    var body: some View{
        Map (coordinateRegion: $region, interactionModes: [],annotationItems: sensors.sensorArray, annotationContent: { pin in
                        MapAnnotation(coordinate: CLLocationCoordinate2D(latitude: pin.latitude!, longitude: pin.longitude!), content: {
                            Text(String(format: "%.1f", pin.last_measurement!.temperature!)+"°")
                                .minimumScaleFactor(0.3)
                                .foregroundColor(.white)
                                .lineLimit(1)
                                .frame(width: 40, height: 40)
                                .background(Color.blue)
                                .cornerRadius(90)
                                
                        
                            
                        })
            
                    }).frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height/3.5, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
        
        .onAppear(perform: {
            region = MKCoordinateRegion(center: lake.region.center, span: MKCoordinateSpan(latitudeDelta: 0.2, longitudeDelta:0.2))

        })
        
        
    }
    
}
