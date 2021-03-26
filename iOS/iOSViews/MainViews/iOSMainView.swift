//
//  iOSMainView.swift
//  iOS
//
//  Created by Niklas Liechti on 01.07.20.
//

import SwiftUI
import MapKit
import UserNotifications

struct iOSMainView: View {
    @AppStorage("lastVersion", store: UserDefaults(suiteName: "group.ch.gfroerli")) var lastVersion: String = "0.0"
    
    @State var showSens = false
    @State var selectedTab = "Overview"
    @State var pathComp: String?
    @State var loadingState: loadingState = .loading
    @StateObject var sensorsVm = SensorListViewModel()
    @State var currentVersion = "0.0"
    @State var showUpdateView = false
    
    var body: some View {
        
        //TabsView and Tabs
        TabView(selection: $selectedTab){
            OverView(showDetail: $showSens, pathComp: $pathComp,sensorsVM: sensorsVm)
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
            
            SettingsView()
                .tabItem { Image(systemName: "gear")
                    Text("Settings") }
                .tag("Settings")
            
                
        }
        .sheet(isPresented: $showUpdateView) {
            NavigationView{
                WhatsNewView(lastVersion: lastVersion ,showDismiss: true)
            }
        }
        //DeepLink handling
        .onOpenURL(perform: { url in
            guard let tabIdentifier = url.tabIdentifier else {
                return
            }
            
            pathComp = url.pathComponents[1]
            selectedTab=tabIdentifier
            if selectedTab == "Overview"{
                showSens=true
            }
            
        })
        
        //fetching Sensors
        .onAppear(perform: {
            sensorsVm.load()
            currentVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "0.0"
            if currentVersion > lastVersion{
                showUpdateView=true
            }
            print(currentVersion)
            
        })
    }
    
}



struct iOSMainView_Previews: PreviewProvider {
    static var previews: some View {
        iOSMainView(sensorsVm: testSensorVM)
            .makePreViewModifier()
    }
}
