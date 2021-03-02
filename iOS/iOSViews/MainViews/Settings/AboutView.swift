//
//  AboutView.swift
//  iOS
//
//  Created by Marc on 02.03.21.
//

import SwiftUI
import WidgetKit

struct AboutView: View {
    @State var alertShowing = false
    
    var body: some View {
        VStack{
            List{
                
                Link(destination: URL(string: "https://xn--gfrr-7qa.li/about")!, label: {
                    HStack{
                        Label(
                            title: { Text("Privacy Policy") },
                            icon: { Image("AppIcon-20") })
                        Spacer()
                        Image(systemName: "chevron.right").foregroundColor(.gray)
                    }
                }).buttonStyle(PlainButtonStyle())
                
                Link(destination: URL(string: "https://xn--gfrr-7qa.li")!, label: {
                    HStack{
                        Label(
                            title: { Text("Website") },
                            icon: { Image("AppIcon-20") })
                        Spacer()
                        Image(systemName: "chevron.right").foregroundColor(.gray)
                    }
                }).buttonStyle(PlainButtonStyle())
                
                Link(destination: URL(string: "https://www.coredump.ch/")!, label: {
                    HStack{
                        Label(
                            title: { Text("Coredump Web") },
                            icon: { Image("AppIcon-20") })
                        Spacer()
                        Image(systemName: "chevron.right").foregroundColor(.gray)
                    }
                }).buttonStyle(PlainButtonStyle())
                
                Link(destination: URL(string: "https://twitter.com/coredump_ch")!, label: {
                    HStack{
                        Label(
                            title: { Text("Coredump Twitter") },
                            icon: { Image("AppIcon-20") })
                        Spacer()
                        Image(systemName: "chevron.right").foregroundColor(.gray)
                    }
                }).buttonStyle(PlainButtonStyle())
                
                Link(destination: URL(string: "https://github.com/gfroerli")!, label: {
                    HStack{
                        Label(
                            title: { Text("Github") },
                            icon: { Image("AppIcon-20") })
                        Spacer()
                        Image(systemName: "chevron.right").foregroundColor(.gray)
                    }
                }).buttonStyle(PlainButtonStyle())
            }
            
            
        }.navigationBarTitle("About", displayMode: .inline)
        .navigationBarItems(trailing:
                                Button(action: {alertShowing=true}, label: {
                                    Text("Reset App").fontWeight(.regular)
                                }).alert(isPresented: $alertShowing, content: {
                                    Alert(
                                        title: Text("Are you sure?"),
                                        message: Text("Do you want to reset the app?"),
                                        primaryButton: .destructive(Text("Reset"), action: resetContent),
                                        secondaryButton: .cancel(Text("Cancel"), action: {})
                                    )
                                }) )
        
    }
    func resetContent(){
        UserDefaults(suiteName: "group.ch.gfroerli")?.set([], forKey: "favoritesIDs")
        UserDefaults(suiteName: "group.ch.gfroerli")?.set(0, forKey: "widgetSensorID")
        WidgetCenter.shared.reloadAllTimelines()
        
    }
}

struct AboutView_Previews: PreviewProvider {
    static var previews: some View {
        AboutView()
    }
}
