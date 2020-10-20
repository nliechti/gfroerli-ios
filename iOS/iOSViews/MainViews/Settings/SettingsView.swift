//
//  SettingsView.swift
//  iOS
//
//  Created by Marc Kramer on 22.08.20.
//

import SwiftUI
import WidgetKit

struct SettingsView: View {
    @State var activePath: String?
    @State var alertShowing = false
    @Binding var loadingState: loadingState
    @ObservedObject var sensorsVm : SensorListViewModel
    var body: some View {
        NavigationView{
            VStack{
                Form{
                    Section(header:Text("General")){
                        NavigationLink(destination: WidgetSettingsView(sensors: sensorsVm, loadingState: $loadingState), tag: "widgetSettings", selection: $activePath ,label: {Text("Widget Settings")})
                    }
                    Section(header:Text("Web")){
                        Link("Privacy Policy", destination: URL(string: "https://xn--gfrr-7qa.li/about")!)
                        
                        Link("Gfrör.li Website", destination: URL(string: "https://xn--gfrr-7qa.li/")!)

                        Link("CoreDump Website", destination: URL(string: "https://www.coredump.ch/")!)
                        
                    }
                    Section(header: Text("Other"),footer:Text("Version: \(Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "fail")").foregroundColor(.gray)){
                        Button(action: {alertShowing=true}, label: {
                            Text("Reset App").foregroundColor(.red)
                        }).alert(isPresented: $alertShowing, content: {
                            Alert(
                              title: Text("Are you sure?"),
                              message: Text("Do you want to reset the app?"),
                              primaryButton: .destructive(Text("Reset"), action: resetContent),
                                secondaryButton: .cancel(Text("Cancel"), action: {})
                            )
                        })
                        
                    }
                }
            }.navigationTitle("Settings")
            .background(Color.gray.opacity(0.001))
        }
    }
    
    func resetContent(){
        UserDefaults(suiteName: "group.ch.gfroerli")?.set([], forKey: "favoritesIDs")
        UserDefaults(suiteName: "group.ch.gfroerli")?.set(0, forKey: "widgetSensorID")
        WidgetCenter.shared.reloadAllTimelines()

    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView(activePath: nil, loadingState: .constant(.loaded), sensorsVm: SensorListViewModel()).makePreViewModifier()
    }
}
