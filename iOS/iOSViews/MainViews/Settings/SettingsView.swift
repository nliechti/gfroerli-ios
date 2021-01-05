//
//  SettingsView.swift
//  iOS
//
//  Created by Marc Kramer on 22.08.20.
//

import SwiftUI
import WidgetKit
import StoreKit

struct SettingsView: View {
    @State var activePath: String?
    @State var alertShowing = false
    @Binding var loadingState: loadingState
    @ObservedObject var sensorsVm : SensorListViewModel
    @Environment(\.openURL) var openURL
    var body: some View {
        NavigationView{
            VStack{
                Form{
                    Section(header:Text("General")){
                        NavigationLink(destination: WidgetSettingsView(sensors: sensorsVm, loadingState: $loadingState), tag: "widgetSettings", selection: $activePath ,label: {Text("Widget Settings")})
                        Button(action: {
                            UIApplication.shared.open(URL.init(string: UIApplication.openSettingsURLString)!, options: [:], completionHandler: nil)

                        }, label: {
                            Text("Change Language")
                        })
                    }
                    Section(header:Text("Web")){
                        Link("Privacy Policy", destination: URL(string: "https://xn--gfrr-7qa.li/about")!)
                        
                        Link("Visit gfrör.li", destination: URL(string: "https://xn--gfrr-7qa.li/")!)

                        Link("Visit coredump.ch", destination: URL(string: "https://www.coredump.ch/")!)
                        
                    }
                    Section(header:Text("Feedback")){
                    Button(action: {
                        let email = "appdev@coredump.ch"
                             let subject = "Feedback iOS Version: \(Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "fail")"
                        
                            let body = getEmailBody()
                           guard let url = URL(string: "mailto:\(email)?subject=\(subject.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) ?? "")&body=\(body.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) ?? "")") else { return }
                        UIApplication.shared.open(url)
                        
                    }, label: {
                            Text("Contact us")
                        
                    })
                        Button(action: {
                            var components = URLComponents(url: URL(string: "https://apps.apple.com/us/app/gfr%C3%B6r-li/id1451431723")!, resolvingAgainstBaseURL: false)
                                                           
                            components?.queryItems = [
                              URLQueryItem(name: "action", value: "write-review")
                            ]
                            guard let writeReviewURL = components?.url else {
                              return
                            }
                            openURL(writeReviewURL)
                            
                        }, label: {
                                Text("Write a Review")
                            
                        })
                    }
                    Section(header: Text("Other"),footer:Text("Version:"+" \(Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "fail")").foregroundColor(.gray)){
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
