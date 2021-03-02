//
//  SettingsView.swift
//  iOS
//
//  Created by Marc Kramer on 22.08.20.
//

import SwiftUI
import WidgetKit
import StoreKit
import CoreLocation

struct SettingsView: View {
    @State var activePath: String?
    @Binding var loadingState: loadingState
    @ObservedObject var sensorsVm : SensorListViewModel
    @Environment(\.openURL) var openURL
    let locationManager = CLLocationManager()
    var body: some View {
        NavigationView{
            VStack{
                Form{
                    Section(header:Text("General")){
                        NavigationLink(destination: WidgetSettingsView(sensorsVM: sensorsVm, loadingState: $loadingState), tag: "widgetSettings", selection: $activePath ,label: {Text("Widget Settings")})
                        Button(action: {
                            UIApplication.shared.open(URL.init(string: UIApplication.openSettingsURLString)!, options: [:], completionHandler: nil)

                        }, label: {
                            Text("Change Language")
                        })
                        Button(action: {
                            print(sensorsVm.sensorArray.first!)
                            LocationNotificationHandler.addLocationNotification(for: sensorsVm.sensorArray.first!)
                           
                        }, label: {
                            Text("Location")
                        })
                        Button(action: {
                            
                            LocationNotificationHandler.testNotification()
                           
                        }, label: {
                            Text("NOTIF")
                        })
                        NavigationLink(
                            destination: AboutView(),
                            label: {
                                /*@START_MENU_TOKEN@*/Text("Navigate")/*@END_MENU_TOKEN@*/
                            })
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
                        
                        
                    }
                }
            }.navigationTitle("Settings")
            .background(Color.gray.opacity(0.001))
        }
    }
    
    
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView(activePath: nil, loadingState: .constant(.loaded), sensorsVm: SensorListViewModel()).makePreViewModifier()
    }
}
