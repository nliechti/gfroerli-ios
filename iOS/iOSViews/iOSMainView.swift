//
//  iOSMainView.swift
//  iOS
//
//  Created by Niklas Liechti on 01.07.20.
//

import SwiftUI
import MapKit

struct iOSMainView: View {
    
    @State var mapState = MKCoordinateRegion(center: CLLocationCoordinate2DMake(47.226015,  8.734503), span: MKCoordinateSpan(latitudeDelta: 0.5, longitudeDelta:0.5))
    @ObservedObject var pins = SensorViewModel()
    
    init() {
        MKMapView.appearance().mapType = .satelliteFlyover
    }
    
    var body: some View {
        VStack {
            Map (coordinateRegion: $mapState, annotationItems: pins.sensorArray, annotationContent: { pin in
                MapAnnotation(coordinate: CLLocationCoordinate2D(latitude: pin.latitude!, longitude: pin.longitude!), content: {
                    Text(String(format: "%.1f", pin.last_measurement!.temperature!))
                        .minimumScaleFactor(0.3)
                        .lineLimit(1)
                        .frame(width: 40, height: 40)
                        .background(Color.blue)
                        .cornerRadius(90)
                
                    
                })
            })
            
            //                .mapSyle(.satelliteFlyover)
            .ignoresSafeArea()
        }
    }
}

struct iOSMainView_Previews: PreviewProvider {
    static var previews: some View {
        iOSMainView()
    }
}
