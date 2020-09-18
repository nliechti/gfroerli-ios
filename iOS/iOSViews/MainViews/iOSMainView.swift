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
    @StateObject var sensorsVm = SensorViewModel()
    
    var body: some View {
        
        TabView(selection: $selectedTab){
            OverView(sensors: sensorsVm)
                .tabItem { Image(systemName: "thermometer.sun.fill")
                    Text("Overview") }
                .tag("Overview")
            AllSensorView(sensorsVm: sensorsVm)
                .tabItem { Image(systemName: "line.horizontal.3.circle.fill")
                    Text("All") }
                .tag("All")
            FavoritesView(sensorsVm: sensorsVm)
                .tabItem { Image(systemName: "star.fill")
                    Text("Favorites") }
                .tag("Favorites")
            SettingsView(activePath: pathComp, sensorsVm: sensorsVm)
                .tabItem { Image(systemName: "gearshape.fill")
                    Text("Settings") }
                .tag("Settings")
        }
        .onOpenURL(perform: { url in
            guard let tabIdentifier = url.tabIdentifier else {
                      return
                    }
            pathComp = url.pathComponents[1]
            selectedTab=tabIdentifier
        })
    }
}

struct iOSMainView_Previews: PreviewProvider {
    static var previews: some View {
        Group{
            iOSMainView(sensorsVm: testSensorVM)
                .previewDevice(PreviewDevice(rawValue: "iPhone 11 Pro Max"))
                .previewDisplayName("iPhone 11 Pro Max")
            iOSMainView(sensorsVm: testSensorVM)
                .previewDevice(PreviewDevice(rawValue: "iPhone 11 Pro"))
                .previewDisplayName("iPhone 11 Pro")
            iOSMainView(sensorsVm: testSensorVM)
                .previewDevice(PreviewDevice(rawValue: "iPhone SE"))
                .previewDisplayName("iPhone SE")
        }
        Group{
            iOSMainView(sensorsVm: testSensorVM)
                .preferredColorScheme(.dark)
                .previewDevice(PreviewDevice(rawValue: "iPhone 11 Pro Max"))
                .previewDisplayName("iPhone 11 Pro Max Dark")
            iOSMainView(sensorsVm: testSensorVM)
                .preferredColorScheme(.dark)
                .previewDevice(PreviewDevice(rawValue: "iPhone 11 Pro"))
                .previewDisplayName("iPhone 11 Pro Dark")
            iOSMainView(sensorsVm: testSensorVM)                .preferredColorScheme(.dark)
                .previewDevice(PreviewDevice(rawValue: "iPhone SE"))
                .previewDisplayName("iPhone SE Dark")
                
        }
    }
}
