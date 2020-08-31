//
//  SettingsView.swift
//  iOS
//
//  Created by Marc Kramer on 22.08.20.
//

import SwiftUI

struct SettingsView: View {
    var body: some View {
        NavigationView{
            VStack{
                Form{
                    Section(header:Text("General")){
                        NavigationLink(destination: WidgetSettingsView(), label: {Text("Widget Settings")})
                    }
                    Section(header:Text("Other")){
                        NavigationLink(destination: Text("Privacy Policy"), label: {Text("Privacy Policy")})
                        
                        Link("Gfrör.li Website", destination: URL(string: "https://xn--gfrr-7qa.li/")!)

                        Link("CoreDump Website", destination: URL(string: "https://www.coredump.ch/")!)
                    }
                }
            }.navigationTitle("Settings")
            .background(Color.gray.opacity(0.001))
            
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}