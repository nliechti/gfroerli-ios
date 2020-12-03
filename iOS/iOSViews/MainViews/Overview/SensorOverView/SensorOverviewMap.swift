//
//  SensorOverviewMap.swift
//  iOS
//
//  Created by Marc Kramer on 03.12.20.
//

import SwiftUI
import MapKit

struct SensorOverviewMap: View {
    @State var region: MKCoordinateRegion
    var annotation: [Sensor]
    var sensor: Sensor
    
    init(inSensor: Sensor){
        self.sensor = inSensor
       _region = State(wrappedValue: MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: sensor.latitude!, longitude: sensor.longitude!), span: MKCoordinateSpan(latitudeDelta: 0.005, longitudeDelta: 0.005)))
     annotation = [sensor]
        
    }
    
    var body: some View {
    
        ZStack(alignment: .bottom) {
            VStack(alignment:.leading) {
                Text("Location").font(.title).bold().padding([.top, .leading])
                Map (coordinateRegion: $region, annotationItems: annotation){ mark in
                    MapMarker(coordinate: CLLocationCoordinate2D(latitude: mark.latitude!, longitude: mark.longitude!))
                    
                }
            }
            HStack{
                Button {
                    openMaps()
                } label: {
                    Label("Get Directions", systemImage: "car.fill").foregroundColor(.white).padding(7)
                }.background(Color.blue)
                .cornerRadius(10)
            }.padding()
        }
    }
    
    func openMaps(){
        
        let coordinate = region.center
        let mapItem = MKMapItem(placemark: MKPlacemark(coordinate: coordinate, addressDictionary:nil))
        mapItem.name = sensor.device_name!
        mapItem.openInMaps(launchOptions: [MKLaunchOptionsDirectionsModeKey : MKLaunchOptionsDirectionsModeDriving])
    }
}

struct SensorOverviewMap_Previews: PreviewProvider {
    static var previews: some View {
        SensorOverviewMap(inSensor: testSensor).makePreViewModifier()
    }
}
