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
    
    var body: some View {
        
        VStack(spacing: 0){
            switch(selectedTab){
            case "Favorites": FavoritesView()
            case "Settings": SettingsView()
            default : OverView()
            }
            
            Spacer()
            
            HStack(spacing:0){
                CostumTabBarButton(tab: $selectedTab, title: "Overview", imageName: "thermometer.sun")
                Spacer(minLength: 0)
                CostumTabBarButton(tab: $selectedTab, title: "Favorites", imageName: "star")
                Spacer(minLength: 0)
                CostumTabBarButton(tab: $selectedTab, title: "Settings", imageName: "gearshape")
            }.padding(.top)                .padding(.bottom,UIApplication.shared.windows.first!.safeAreaInsets.bottom == 0 ? 15 : UIApplication.shared.windows.first!.safeAreaInsets.bottom)
            
            .padding(.horizontal, 35)
            .background(Color.gray.opacity(0.1))
        }.edgesIgnoringSafeArea(.all)
    }
}

struct iOSMainView_Previews: PreviewProvider {
    static var previews: some View {
        Group{
            iOSMainView()
                .previewDevice(PreviewDevice(rawValue: "iPhone 11 Pro Max"))
                .previewDisplayName("iPhone 11 Pro Max")
            iOSMainView()
                .previewDevice(PreviewDevice(rawValue: "iPhone 11 Pro"))
                .previewDisplayName("iPhone 11 Pro")
            iOSMainView()
                .previewDevice(PreviewDevice(rawValue: "iPhone SE"))
                .previewDisplayName("iPhone SE")
        }
    }
}
