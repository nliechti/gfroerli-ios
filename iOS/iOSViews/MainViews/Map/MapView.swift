//
//  MapView.swift
//  MapView
//
//  Created by Marc Kramer on 17.07.21.
//

import SwiftUI
import MapKit
import UIKit
import BottomSheet

struct MapView: View {
    @ObservedObject var sensorsVm: SensorListViewModel
    @State var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 46.7985, longitude: 8.2318),
        span: MKCoordinateSpan(latitudeDelta: 5, longitudeDelta: 5))
    @State private var bottomSheetPosition: BottomSheetPosition = .hidden
    
    @State var selectedSensor: Sensor?
    
    var body: some View {
        Map(coordinateRegion: $region, annotationItems: sensorsVm.sensorArray) { sensor in
            MapAnnotation(coordinate: sensor.coordinates) {
                if region.span.latitudeDelta <= 0.15 {
                    HStack {
                        Text(sensor.sensorName)
                        Text(makeTemperatureString(double: sensor.latestTemp!, precision: 2))
                        Image(systemName: "chevron.right")
                            .foregroundColor(.blue)
                    }
                    .padding(8)
                    .boxStyle()
                    .onTapGesture {
                        selectedSensor = sensor
                        bottomSheetPosition = .middle
                    }
                } else {
                    Image(systemName: "mappin.circle.fill")
                        .symbolRenderingMode(.palette)
                        .foregroundStyle(.white, .red)
                        .font(.system(size: 30))
                        .onTapGesture {
                            selectedSensor = sensor
                            bottomSheetPosition = .middle
                        }
                }
            }
        }
        
        .edgesIgnoringSafeArea(.top)
        .bottomSheet(
            bottomSheetPosition: $bottomSheetPosition,
            options: [
                .swipeToDismiss,
                .tapToDissmiss,
                .showCloseButton(action: {}),
                .appleScrollBehavior
            ],
            title: selectedSensor?.sensorName) {
            BottomSheetSensorView(sensor: $selectedSensor, bottomSheetPosition: $bottomSheetPosition)
        }
    }
}

struct BottomSheetSensorView: View {
    @Binding var sensor: Sensor?
    @Binding var bottomSheetPosition: BottomSheetPosition
    
    var body: some View {
        VStack {
            if sensor != nil {
               
                    SensorOverView(sensorID: sensor!.id, sensorName: sensor!.sensorName, transparentBG: true)
            } else {
                Text("Select Sensor")
            }
        }
    }
}

struct MapView_Previews: PreviewProvider {
    static var previews: some View {
        EmptyView()
    }
}

struct UIMapView: UIViewRepresentable {
    typealias UIViewType = MKMapView
    typealias Context = UIViewRepresentableContext<Self>
    
    @ObservedObject var sensorsVm: SensorListViewModel
    
    func makeUIView(context: Context) -> MKMapView {
        let mapView = MKMapView()
        mapView.mapType = .hybrid
        mapView.pointOfInterestFilter = .excludingAll
        
        return mapView
    }
    
    func updateUIView(_ view: MKMapView, context: Context) {
    }
}
