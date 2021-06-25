//
//  iOSMainView.swift
//  iOS
//
//  Created by Niklas Liechti on 01.07.20.
//

import SwiftUI
import MapKit
import UserNotifications

struct IOSMainView: View {
    @AppStorage("lastVersion", store: UserDefaults(suiteName: "group.ch.gfroerli")) var lastVersion: String = "0.0"

    @State var showSens = false
    @State var selectedTab = "Overview"
    @State var pathComp: String?
    @State var loadingState: loadingState = .loading
    @StateObject var sensorsVm = SensorListViewModel()
    @State var currentVersion = "0.0"
    @State var showUpdateView = false
    @ObservedObject var observer = Observer()
    var body: some View {

        // TabsView and Tabs
        TabView(selection: $selectedTab) {
            OverView(showDetail: $showSens, sensorsVM: sensorsVm)
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
            NavigationView {
                WhatsNewView(lastVersion: lastVersion, showDismiss: true)
            }
        }
       .sheet(isPresented: $showSens) {

            NavigationView {
                SensorOverView(id: Int(pathComp!)!).navigationBarItems(leading: Button(action: {showSens=false}, label: {Text("Close")}))
            }
        }

        // fetching Sensors
        .onAppear(perform: {
            sensorsVm.load()
            currentVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "0.0"
            if currentVersion > lastVersion {
                showUpdateView=true
            }
        })
        .onReceive(self.observer.$enteredForeground) { _ in
            sensorsVm.load()
        }
        // DeepLink handling
        .onOpenURL(perform: { url in
            guard let tabIdentifier = url.tabIdentifier else {
                return
            }
            print("owo")
            print(url.pathComponents[1])
            pathComp = url.pathComponents[1]
            selectedTab=tabIdentifier
            if selectedTab == "Overview"{
                // Workaround for SwiftUI bug
                DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1), execute: {
                    showSens = true
                })

            }
        })
    }

}

struct IOSMainView_Previews: PreviewProvider {
    static var previews: some View {
        IOSMainView(sensorsVm: testSensorVM)
            .makePreViewModifier()
    }
}
