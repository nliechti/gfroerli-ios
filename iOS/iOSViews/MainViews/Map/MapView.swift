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
import CoreLocationUI
import CoreLocation

struct MapView: View {
    @ObservedObject var sensorsVm: SensorListViewModel
    
    @State private var bottomSheetPosition: BottomSheetPosition = .hidden
    
    @State var selectedSensor: Sensor?
    
    @StateObject var locationManager = ObservableLocationManager()
    
    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            Map(coordinateRegion: $locationManager.region,
                showsUserLocation: true,
                annotationItems: sensorsVm.sensorArray) { sensor in
                MapAnnotation(coordinate: sensor.coordinates) {
                    
                    if locationManager.region.span.latitudeDelta <= 0.15 {
                        
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
            
            LocationButton(.currentLocation) {
                locationManager.updateLocation()
            }
            .cornerRadius(30)
            .symbolVariant(.fill)
            .foregroundColor(.white)
            .padding()
            
        }
        .edgesIgnoringSafeArea(.top)
        .bottomSheet(
            bottomSheetPosition: $bottomSheetPosition,
            options: [
                .swipeToDismiss,
                .tapToDissmiss,
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
