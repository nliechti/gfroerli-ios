//
//  MapView.swift
//  MapView
//
//  Created by Marc Kramer on 17.07.21.
//

import SwiftUI
import MapKit
import UIKit

struct MapView: View {
    @ObservedObject var sensorsVm: SensorListViewModel

    var body: some View {
        UIMapView(sensorsVm: sensorsVm)
            .edgesIgnoringSafeArea(.top)
    }
}

struct MapView_Previews: PreviewProvider {
    static var previews: some View {
        MapView(sensorsVm: SensorListViewModel.init())
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
