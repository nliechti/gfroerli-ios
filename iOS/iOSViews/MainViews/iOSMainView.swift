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
        
        VStack(spacing: 0){
            switch(selectedTab){
            case "Overview": OverView(sensors: sensorsVm)
            case "Favorites": FavoritesView(sensorsVm: sensorsVm)
            case "Settings": SettingsView(activePath: pathComp, sensorsVm: sensorsVm)
            case "All": AllSensorView(sensorsVm: sensorsVm)

            default: Text("YIKES")
            }

            HStack(spacing:0){
                CostumTabBarButton(tab: $selectedTab, title: "Overview", imageName: "thermometer.sun")
                Spacer(minLength: 0)
                CostumTabBarButton(tab: $selectedTab, title: "All", imageName: "line.horizontal.3.circle")
                Spacer(minLength: /*@START_MENU_TOKEN@*/0/*@END_MENU_TOKEN@*/)
                CostumTabBarButton(tab: $selectedTab, title: "Favorites", imageName: "star")
                Spacer(minLength: 0)
                
                CostumTabBarButton(tab: $selectedTab, title: "Settings", imageName: "gearshape")
            }.padding(.top)
            .padding(.bottom, 25)
            
            .padding(.horizontal, 35)
            .background(Color(.systemGray5).opacity(0.5))
            
        }.edgesIgnoringSafeArea(.all)
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
