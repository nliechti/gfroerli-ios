//
//  iOSMainView.swift
//  iOS
//
//  Created by Niklas Liechti on 01.07.20.
//

import SwiftUI
import MapKit

struct iOSMainView: View {
    @State var selectedTab = "Overview"
    @State var pathComp: String?
    @State var loadingState: loadingState = .loading
    @StateObject var sensorsVm = SensorListViewModel()
    
    var body: some View {
        //TabsView and Tabs
        TabView(selection: $selectedTab){
            OverView(sensors: sensorsVm, loadingState: $loadingState)
                .tabItem { Image(systemName: "thermometer.sun.fill")
                    Text("Overview") }
                .tag("Overview")
            AllSensorView(sensorsVm: sensorsVm, loadingState: $loadingState)
                .tabItem { Image(systemName: "line.horizontal.3.circle.fill")
                    Text("All") }
                .tag("All")
            FavoritesView()
                .tabItem { Image(systemName: "star.fill")
                    Text("Favorites") }
                .tag("Favorites")
            SettingsView(activePath: pathComp, loadingState: $loadingState, sensorsVm: sensorsVm)
                .tabItem { Image(systemName: "gear")
                    Text("Settings") }
                .tag("Settings")
        }
        //DeepLink handling
        .onOpenURL(perform: { url in
            guard let tabIdentifier = url.tabIdentifier else {
                return
            }
            pathComp = url.pathComponents[1]
            selectedTab=tabIdentifier
        })
        //fetching Sensors
        .onAppear(perform: {
            loadingState = .loading
            sensorsVm.getAllSensors { (result) in
                switch result {
                case .success(let str):
                    loadingState = .loaded
                case .failure(let error):
                    loadingState = .error
                    switch error {
                    case .badURL:
                        print("Bad URL")
                    case .requestFailed:
                        print("Network problems")
                    case.decodeFailed:
                        print("Decoding data failed")
                    case .unknown:
                        print("Unknown error")
                    }
                }
                
            }
        })
    }
}


struct iOSMainView_Previews: PreviewProvider {
    static var previews: some View {
            iOSMainView(sensorsVm: testSensorVM)
                .makePreViewModifier()
    }
}
